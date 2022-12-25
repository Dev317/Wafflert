import json
import os
import socket

import requests
from flask import Flask, jsonify, request
from flask_cors import CORS

if os.environ.get("stage") == "PRODUCTION":
    users_service_url = os.environ.get("users_service_url")
    payments_service_url = os.environ.get("payments_service_url")
else:
    users_service_url = os.environ.get("users_service_url_internal")
    payments_service_url = os.environ.get("payments_service_url_internal")

app = Flask(__name__)

CORS(app)


@app.route("/user-mgmt/health")
def health_check():

    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)

    return (
        jsonify(
            {
                "message": "Service is healthy.",
                "service:": "user-mgmt",
                "ip_address": local_ip,
            }
        ),
        200,
    )


@app.route("/user-mgmt/register", methods=["POST"])
# /user-mgmt/register
def register_user():
    userId = ""
    try:
        req = request.get_json()

        # (1) Register user in Users Service
        res_user = requests.post(
            users_service_url + "/register/",
            data=json.dumps(req),
            headers={"Content-Type": "application/json"},
        )

        if res_user.status_code != 201:
            raise Exception("Failed to register user account.")

        userId = res_user.json()["id"]

        # (2) Create Stripe accounts for user in Payments Service
        stripe_req_body = {
            "userId": userId,
            "email": res_user.json()["username"]
            }

        res_stripe = requests.post(
            payments_service_url + "/accounts",
            data=json.dumps(stripe_req_body),
            headers={"Content-Type": "application/json"},
        )

        if res_stripe.status_code != 201:
            requests.delete(
                users_service_url +
                f"/delete-waffle-user/{userId}")
            raise Exception("Failed to create Stripe accounts for user.")

        return (jsonify(res_user.json()), 201)
    except Exception as err:
        payment_down_msg = "Max retries exceeded with url: /payments/accounts"
        if payment_down_msg in str(err):
            requests.delete(
                users_service_url +
                f"/delete-waffle-user/{userId}")
            return (
                jsonify(
                    {
                        "message": "Payments service cannot be reached.",
                    }
                ),
                500,
            )
        else:
            return (
                jsonify(
                    {
                        "message": str(err),
                    }
                ),
                500,
            )


@app.route("/user-mgmt/telegram", methods=["POST"])
# /user-mgmt/telegram
def update_telegram_info():
    print(users_service_url)
    try:
        req = request.get_json()

        # req consists of {username, password, telegram_name, telegram_chat_id}

        user_req_body = {
            "username": req["username"],
            "password": req["password"]}

        tele_req_body = {
            "telegram_username": req["telegram_name"],
            "telegram_id": req["telegram_chat_id"],
        }

        # (1) Validate if user exists & with a valid username, password
        res_validate = requests.post(
            users_service_url + "/login/",
            data=json.dumps(user_req_body),
            headers={"Content-Type": "application/json"},
        )

        if res_validate.status_code != 200:
            raise Exception("Failed to authenticate user.")

        user_id = res_validate.json()["id"]
        token = res_validate.json()["token"]

        # (2) Update the user's telegram ID
        res_user = requests.put(
            users_service_url + f"/update-telegram-id/{user_id}/",
            data=json.dumps(tele_req_body),
            headers={
                "Content-Type": "application/json",
                "Authorization": f"Bearer {token}",
            },
        )

        if res_user.status_code != 200:
            raise Exception("Failed to update user's Telegram ID.")

        final_res = {
            "user_id": res_user.json()["id"],
            "telegram_name": res_user.json()["telegram_username"],
            "telegram_chat_id": res_user.json()["telegram_id"],
        }

        # Return response back to Telegram Bot Service
        return (jsonify(final_res), 200)

    except KeyError as key_err:
        return (jsonify({
            "message": f"Request must include {str(key_err)}"
            }), 400)

    except Exception as err:
        return (
            jsonify(
                {
                    "message": str(err),
                }
            ),
            500,
        )


@app.route("/user-mgmt/onboarding-status/<string:user_id>", methods=["GET"])
# /user-mgmt/onboarding-status
def retrieve_onboarding_status(user_id):
    try:
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

        # (1) Check Telegram ID
        res_telegram_info = requests.get(
            users_service_url + f"/retrieve/{user_id}/",
            headers={
                "Content-Type": "application/json",
                "Authorization": f"Bearer {token}"},
        )

        if res_telegram_info.status_code != 200:
            raise Exception("Failed to retrieve user info.")

        telegram_info = (
            res_telegram_info.json()["telegram_username"] is not None
            and res_telegram_info.json()["telegram_id"] is not None
        )

        # (2) Check connected account status
        res_connected_account = requests.get(
            payments_service_url +
            "/accounts/connected-account-verified/" + user_id,
            headers={"Content-Type": "application/json"},
        )

        if res_connected_account.status_code != 200:
            raise Exception(
                "Failed to retrieve Stripe Connected Account status.")

        conn_account = res_connected_account.json()["connectedAccountVerified"]

        # (3) Check payment methods
        res_payment_methods = requests.get(
            payments_service_url + "/accounts/payment-methods/" + user_id,
            headers={"Content-Type": "application/json"},
        )

        payment_method = False

        if res_payment_methods.status_code == 200:
            payment_method = True
        elif (
            res_payment_methods.status_code == 404
            and res_payment_methods.json()["type"] == "NoPaymentMethod"
        ):
            payment_method = False
        else:
            raise Exception("Failed to retrieve payment methods.")

        final_res = {
            "connectedAccountValid": conn_account,
            "customerValid": payment_method,
            "telegramValid": telegram_info,
        }

        return (jsonify(final_res), 200)
    except Exception as err:
        return (
            jsonify(
                {
                    "message": str(err),
                }
            ),
            500,
        )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
