import os
import socket
import json
import requests
import pika

from flask import Flask, request, jsonify
from flask_cors import CORS

import amqp_setup

if os.environ.get('stage') == 'production-ecs':
    orders_service_url = os.environ.get('orders_service_url')
    payment_service_url = os.environ.get('payment_service_url')
    bidding_service_url = os.environ.get('bidding_service_url')
    user_service_url = os.environ.get('user_service_url')
else:
    orders_service_url = os.environ.get('orders_service_url_internal')
    payment_service_url = os.environ.get('payment_service_url_internal')
    bidding_service_url = os.environ.get('bidding_service_url_internal')
    user_service_url = os.environ.get('user_service_url_internal')

app = Flask(__name__)

CORS(app)


@app.route("/order-mgmt/health")
def health_check():
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)

    return jsonify(
            {
                "message": "Service is healthy.",
                "service:": "order-mgmt",
                "ip_address": local_ip
            }
    ), 200


@app.route("/place-order", methods=['POST'])
def place_order():
    # Check if JWT token passed in
    token = None
    if "Authorization" in request.headers:
        token = request.headers["Authorization"].split(" ")[1]

    if not token:
        return (
            jsonify(
                {
                    "message": "Authentication token is missing.",
                }
            ),
            401
        )

    payload = request.get_json()

    #################################################################
    # (1) Check if user has valid payment method
    #################################################################

    payments_response = requests.get(
        payment_service_url + '/accounts/payment-methods/'
        + payload['user_id'],
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if payments_response.status_code == 404:
        print('[ERROR]: NO PAYMENT METHOD FOUND')
        return jsonify(
                {
                    "message": "Unable to place order.",
                    "error": "Payment method for user not found."

                }
            ), 404
    if payments_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING PAYMENT SERVICE')
        return jsonify(
                {
                    "message": "Unable to place order.",
                    "error": "Unable to check payment method of user."

                }
            ), 500

    print('[SUCCESS]: /PLACE-ORDER CHECK VALID PAYMENT')

    #################################################################
    # (2) Post to order service to create order
    #################################################################

    place_order_response = requests.post(
        orders_service_url + '/order',
        data=json.dumps({
            "orderer_user_id": payload["user_id"],
            "orderer_username": payload["username"],
            "flavour": payload["flavour"],
            "quantity": payload["quantity"],
            "delivery_info": payload["delivery_info"],
            "expiry_datetime": payload["expiry_datetime"]
        }),
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if place_order_response.status_code != 201:
        print('[ERROR]: ISSUE ACCESSING ORDER SERVICE: PLACE ORDER')
        print(place_order_response.json())
        return jsonify(
                {
                    "message": "Unable to place order.",
                    "error": "Unable to create order."

                }
            ), 500

    print('[SUCCESS]: /PLACE-ORDER ORDER PLACED')
    print('ORDER DETAILS:')
    print(place_order_response.json()["data"])

    #################################################################
    # (3) Post to bid service to create bid
    #################################################################

    completed_order = place_order_response.json()['data']
    completed_order.update({"bid_price": payload["bid_price"]})

    bid_response = requests.post(
        bidding_service_url,
        data=json.dumps({
            "order_id": completed_order["order_id"],
            "creation_datetime": completed_order["creation_datetime"],
            "expiry_datetime": completed_order["expiry_datetime"],
            "bid_price": completed_order["bid_price"],
        }),
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if bid_response.status_code != 201:
        print('[ERROR]: ISSUE ACCESSING BIDDING SERVICE: PLACE BID')
        print('BID RES: ------------------------')
        print(bid_response.json())
        print('---------------------------------')
        print('ROLLING BACK CHANGES (orders)')

        # Undo order creation
        requests.delete(
            orders_service_url + '/orders/' + completed_order["order_id"],
            headers={
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        )
        print('[ROLL BACK]: ROLLING BACK PLACE ORDER')

        return jsonify(
                {
                    "message": "Unable to place order.",
                    "error": "Unable to create bid."

                }
            ), 500

    print('[SUCCESS]: /PLACE-ORDER BID PLACED')
    print('BID DETAILS:')
    print(bid_response.json()["data"])

    #################################################################
    # (4) Update order with bid id
    #################################################################

    update_order_response = requests.patch(
        orders_service_url + '/orders/' + completed_order["order_id"],
        data=json.dumps({
            "bid_id": bid_response.json()["data"]["bid_id"],
        }),
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if update_order_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING ORDER SERVICE: UPDATE ORDER')
        print('ORDER RES: ------------------------')
        print(update_order_response.json())
        print('---------------------------------')
        print('ROLLING BACK CHANGES (orders, bidding)')

        # Undo order creation
        requests.delete(
            orders_service_url + '/orders/' + completed_order["order_id"],
            headers={
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        )
        print('[ROLL BACK]: ROLLING BACK PLACE ORDER')

        requests.delete(
            bidding_service_url + '/' + bid_response.json()["bid_id"],
            headers={
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        )
        print('[ROLL BACK]: ROLLING BACK PLACE BID')

        return jsonify(
                {
                    "message": "Unable to place order.",
                    "error": "Unable to update order with bid id."

                }
        ), 500

    print('[SUCCESS]: /PLACE-ORDER ORDER UPDATED WITH BID')
    completed_order['bid_id'] = bid_response.json()["data"]["bid_id"]

    #################################################################
    # (5) Get tele chat id for notification service to send to
    #################################################################

    user_info_response = requests.get(
        user_service_url + "/retrieve/" + completed_order["orderer_user_id"],
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {token}"},
    )

    if user_info_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING USER SERVICE: GET USER INFO')
        print('USER INFO RES: ------------------------')
        print(user_info_response.json())
        print('---------------------------------')
        return jsonify(
            {
                "message": "Unable to place order.",
                "error": "Unable to access user infomation."
            }
        ), 500

    print('[SUCCESS]: /PLACE-ORDER GET TELEID')

    #################################################################
    # (6) Send a notification to AMQP broker to notify user
    # that order has been placed
    #################################################################

    notification_data = {
        "telegram_chat_id": user_info_response.json()["telegram_id"],
        "order_id": completed_order["order_id"],
        "order_status": "Order Successfully Placed!",
    }

    connection = pika.BlockingConnection(amqp_setup.parameters)

    channel = connection.channel()

    channel.basic_publish(
        exchange=amqp_setup.exchange_name, routing_key="order.new",
        body=json.dumps(notification_data),
        properties=pika.BasicProperties(delivery_mode=2))

    connection.close()

    print('[SUCCESS]: /PLACE-ORDER NOTIFICATION SENT TO BROKER')
    print('[NOTIFICATION DATA]--------------------')
    print(notification_data)
    print('---------------------------------------')

    return jsonify(
        {
            "message": "Order placed.",
            "data": completed_order
        }
    ), 200


@app.route("/accept-order/<string:bid_id>", methods=['PATCH'])
def accept_order(bid_id):
    # Check if JWT token passed in
    token = None
    if "Authorization" in request.headers:
        token = request.headers["Authorization"].split(" ")[1]

    if not token:
        return (
            jsonify(
                {
                    "message": "Authentication token is missing.",
                }
            ),
            401
        )

    payload = request.get_json()

    #################################################################
    # (1) Check if user has valid paying account (to receive money)
    #################################################################
    temp_url = '/accounts/connected-account-verified/'+payload['user_id']
    payment_valid_response = requests.get(
        payment_service_url + temp_url,
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if payment_valid_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING PAYMENT SERVICE:')
        print('PAYMENT RES: ---------------------')
        print('Payment status code:' + payment_valid_response.status_code)
        print(payment_valid_response.json())
        print('---------------------------------')

        return jsonify(
                {
                    "message": "Unable to accept order.",
                    "error": "Unable to access payment method."

                }
        ), 500

    verified = payment_valid_response.json()['connectedAccountVerified']
    if verified == "false":
        return jsonify(
                {
                    "message": "Unable to accept order.",
                    "error": "User does not have valid payment method."
                }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER PAYMENT METHOD FOUND')

    #################################################################
    # (2) Fufill bid (mark as closed)
    #################################################################

    update_bid_response = requests.patch(
        bidding_service_url + '/fufill-bid/' + bid_id,
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if update_bid_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING BIDDING SERVICE: FUFILL BID')
        print('BID RES: ------------------------')
        print(update_bid_response.json())
        print('---------------------------------')
        return jsonify(
                {
                    "message": "Unable to accept order.",
                    "error": "Unable to update bid."

                }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER BID UPDATED WITH CLOSED STATUS')

    #################################################################
    # (3) Update order with final bid price
    #################################################################

    temp_url = '/orders/' + update_bid_response.json()["data"]["order_id"]
    update_order_response = requests.patch(
        orders_service_url + temp_url,
        data=json.dumps({
            "runner_user_id": payload["user_id"],
            "runner_username": payload["username"],
            "final_bid_price": update_bid_response.json()["data"]["bid_price"],
        }),
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if update_order_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING ORDER SERVICE: UPDATE ORDER')
        print('ORDER RES: ----------------------')
        print(update_order_response.json())
        print('---------------------------------')
        print('ROLLING BACK CHANGES (bidding)')

        requests.patch(
            bidding_service_url + '/' + bid_id,
            data=json.dumps({
                "bid_status": 'OPEN',
            }),
            headers={
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        )

        return jsonify(
                {
                    "message": "Unable to accept order.",
                    "error": "Unable to update order with bid price."

                }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER ORDER UPDATED WITH BID PRICE')

    #################################################################
    # (4) Call payment service to hold money
    #################################################################

    post_payment_response = requests.post(
        payment_service_url,
        data=json.dumps({
            "bidId": bid_id,
            "buyerId":
            update_order_response.json()['data']['orderer_user_id'],
            "runnerId": payload["user_id"],
            "amountPaid":
            update_bid_response.json()["data"]["bid_price"]
        }),
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if post_payment_response.status_code != 201:
        print('[ERROR]: ISSUE ACCESSING PAYMENTS SERVICE: HOLD MONEY')
        print('PAYMENTS RES: ------------------------')
        print(post_payment_response.json())
        print('---------------------------------')
        print('ROLLING BACK CHANGES (orders, bidding)')

        requests.patch(
            bidding_service_url + '/' + bid_id,
            data=json.dumps({
                "bid_status": 'OPEN',
            }),
            headers={
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        )

        ord_id = update_bid_response.json()["data"]["order_id"]
        requests.patch(
            orders_service_url + '/orders/' + ord_id,
            data=json.dumps({
                "final_bid_price": None,
            }),
            headers={
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        )

        return jsonify(
                {
                    "message": "Unable to accept order.",
                    "error": "Unable to process payment transaction."

                }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER PAYMENT RECORD MADE')

    #################################################################
    # (5) Get orderer tele id from user service
    #################################################################
    updated_order_data = update_order_response.json()['data']

    temp_url = "/retrieve/" + updated_order_data["orderer_user_id"]
    orderer_info_response = requests.get(
        user_service_url + temp_url,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {token}"},
    )

    if orderer_info_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING USER SERVICE: GET ORDERER INFO')
        print('USER INFO RES: -------------------')
        print(orderer_info_response.json())
        print('---------------------------------')
        return jsonify(
            {
                "message": "Unable to accept order.",
                "error": "Unable to access user infomation."
            }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER GET ORDERER TELEID')

    #################################################################
    # (6) Get runner tele id from user service
    #################################################################

    runner_info_response = requests.get(
        user_service_url + "/retrieve/" + updated_order_data["runner_user_id"],
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {token}"},
    )

    if runner_info_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING USER SERVICE: GET RUNNER INFO')
        print('USER INFO RES: -------------------')
        print(runner_info_response.json())
        print('---------------------------------')
        return jsonify(
            {
                "message": "Unable to accept order.",
                "error": "Unable to access user infomation."
            }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER GET RUNNER TELEID')

    #################################################################
    # (7) Send a notification to AMQP broker to notify both orderer
    # and runner that order has been accepted
    #################################################################

    orderer_notification_data = {
        "telegram_chat_id": orderer_info_response.json()["telegram_id"],
        "order_id": updated_order_data["order_id"],
        "order_status": "A runner has agreed to pick up your order",
    }

    runner_notification_data = {
        "telegram_chat_id": runner_info_response.json()["telegram_id"],
        "order_id": updated_order_data["order_id"],
        "order_status": "You are now the runner for this order!",
    }

    connection = pika.BlockingConnection(amqp_setup.parameters)

    channel = connection.channel()

    channel.basic_publish(
        exchange=amqp_setup.exchange_name, routing_key="order.accept",
        body=json.dumps(orderer_notification_data),
        properties=pika.BasicProperties(delivery_mode=2))

    print('[SUCCESS]: /ACCEPT-ORDER NOTIFICATION SENT TO BROKER')
    print('[ORDERER NOTIFICATION DATA]------------')
    print(orderer_notification_data)
    print('---------------------------------------')

    channel.basic_publish(
        exchange=amqp_setup.exchange_name, routing_key="order.accept",
        body=json.dumps(runner_notification_data),
        properties=pika.BasicProperties(delivery_mode=2))

    print('[SUCCESS]: /ACCEPT-ORDER NOTIFICATION SENT TO BROKER')
    print('[RUNNER NOTIFICATION DATA]-------------')
    print(runner_notification_data)
    print('---------------------------------------')

    connection.close()

    return jsonify(
        {
            "message": "Order accepted.",
            "data": updated_order_data
        }
    ), 200


@app.route("/complete-order/<string:order_id>", methods=['PATCH'])
def complete_order(order_id):
    # Check if JWT token passed in
    token = None
    if "Authorization" in request.headers:
        token = request.headers["Authorization"].split(" ")[1]

    if not token:
        return (
            jsonify(
                {
                    "message": "Authentication token is missing.",
                }
            ),
            401
        )

    #################################################################
    # (1) Get order information
    #################################################################

    order_response = requests.get(
        orders_service_url + '/orders/' + order_id,
        headers={
                'Content-Type': 'application/json',
                'Accept': 'application/json'
        }
    )

    if order_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING ORDER SERVICE: GET ORDER INFO')
        print('ORDER RES: ----------------------')
        print(order_response.json())
        print('---------------------------------')
        return jsonify(
            {
                "message": "Unable to place order.",
                "error": "Unable to access user infomation."
            }
        ), 500

    print('[SUCCESS]: /COMPLETE-ORDER GET ORDER INFO')

    order_data = order_response.json()['data']

    #################################################################
    # (2) Complete transaction
    #################################################################

    payment_response = requests.patch(
        payment_service_url + '/' + order_data['bid_id'],
        data=json.dumps({
            "status": 'COMPLETED'
        }),
        headers={
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    )

    if payment_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING PAYMENTS SERVICE: COMPLETE')
        print('PAYMENTS RES: -------------------')
        print(payment_response.json())
        print('---------------------------------')
        return jsonify(
                {
                    "message": "Unable to complete order.",
                    "error": "Unable to complete payment."

                }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER PAYMENT RECORD MADE')

    #################################################################
    # (3) Get orderer tele id from user service
    #################################################################

    temp_url = "/retrieve/" + order_data["orderer_user_id"]
    orderer_info_response = requests.get(
        user_service_url + temp_url,
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {token}"},
    )

    if orderer_info_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING USER SERVICE: GET ORDERER INFO')
        print('USER INFO RES: -------------------')
        print(orderer_info_response.json())
        print('---------------------------------')
        return jsonify(
            {
                "message": "Unable to accept order.",
                "error": "Unable to access user infomation."
            }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER GET ORDERER TELEID')

    #################################################################
    # (4) Get runner tele id from user service
    #################################################################

    runner_info_response = requests.get(
        user_service_url + "/retrieve/" + order_data["runner_user_id"],
        headers={
            "Content-Type": "application/json",
            "Authorization": f"Bearer {token}"},
    )

    if runner_info_response.status_code != 200:
        print('[ERROR]: ISSUE ACCESSING USER SERVICE: GET RUNNER INFO')
        print('USER INFO RES: -------------------')
        print(runner_info_response.json())
        print('---------------------------------')
        return jsonify(
            {
                "message": "Unable to accept order.",
                "error": "Unable to access user infomation."
            }
        ), 500

    print('[SUCCESS]: /ACCEPT-ORDER GET RUNNER TELEID')

    #################################################################
    # (5) Send a notification to AMQP broker to notify both orderer
    # and runner that order has been accepted
    #################################################################

    orderer_notification_data = {
        "telegram_chat_id": orderer_info_response.json()["telegram_id"],
        "order_id": order_data["order_id"],
        "order_status": "Order Received! Enjoy your waffle 🧇",
    }

    runner_notification_data = {
        "telegram_chat_id": runner_info_response.json()["telegram_id"],
        "order_id": order_data["order_id"],
        "order_status": "Order Delivered! ",
    }

    connection = pika.BlockingConnection(amqp_setup.parameters)

    channel = connection.channel()

    channel.basic_publish(
        exchange=amqp_setup.exchange_name, routing_key="order.accept",
        body=json.dumps(orderer_notification_data),
        properties=pika.BasicProperties(delivery_mode=2))

    print('[SUCCESS]: /COMPLETE-ORDER NOTIFICATION SENT TO BROKER')
    print('[ORDERER NOTIFICATION DATA]------------')
    print(orderer_notification_data)
    print('---------------------------------------')

    channel.basic_publish(
        exchange=amqp_setup.exchange_name, routing_key="order.accept",
        body=json.dumps(runner_notification_data),
        properties=pika.BasicProperties(delivery_mode=2))

    print('[SUCCESS]: /COMPLETE-ORDER NOTIFICATION SENT TO BROKER')
    print('[RUNNER NOTIFICATION DATA]-------------')
    print(runner_notification_data)
    print('---------------------------------------')

    connection.close()

    return jsonify(
        {
            "message": "Order completed.",
            "data": order_data
        }
    ), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5003, debug=True)
