import socket
import os
import uuid

from datetime import datetime
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
db_name = '/order_service_db'
print(os.environ.get('db_conn'))
if os.environ.get('db_conn'):
    app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('db_conn')+db_name
else:
    app.config['SQLALCHEMY_DATABASE_URI'] = None
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ENGINE_OPTIONS'] = {'pool_size': 100,
                                           'pool_recycle': 280}
app.config['SECRET_KEY'] = 'secret'

db = SQLAlchemy(app)

CORS(app)


class Order(db.Model):
    __tablename__ = 'order'

    order_id = db.Column(db.String, primary_key=True)
    bid_id = db.Column(db.String)
    orderer_user_id = db.Column(db.String, nullable=False)
    runner_user_id = db.Column(db.String)
    orderer_username = db.Column(db.String, nullable=False)
    runner_username = db.Column(db.String)
    flavour = db.Column(db.String(128), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    delivery_info = db.Column(db.String(128), nullable=False)
    creation_datetime = db.Column(db.DateTime, nullable=False,
                                  default=datetime.now)
    expiry_datetime = db.Column(db.DateTime, nullable=False)
    final_bid_price = db.Column(db.Float(precision=2))

    def __init__(self, orderer_user_id, orderer_username, flavour, quantity,
                 delivery_info, expiry_datetime, final_bid_price=0,
                 bid_id=None, runner_user_id=None, runner_username=None):
        self.bid_id = bid_id
        self.orderer_user_id = orderer_user_id
        self.runner_user_id = runner_user_id
        self.orderer_username = orderer_username
        self.runner_username = runner_username
        self.flavour = flavour
        self.quantity = quantity
        self.delivery_info = delivery_info
        self.expiry_datetime = expiry_datetime
        self.final_bid_price = final_bid_price

    # ? modify to return datetime in a more readable format?
    def to_dict(self):
        return {
            "order_id": self.order_id,
            "bid_id": self.bid_id,
            "orderer_user_id": self.orderer_user_id,
            "runner_user_id": self.runner_user_id,
            "orderer_name": self.orderer_username,
            "runner_username": self.runner_username,
            "flavour": self.flavour,
            "quantity": self.quantity,
            "delivery_info": self.delivery_info,
            "creation_datetime":
            self.creation_datetime.strftime('%Y-%m-%d %H:%M:%S'),
            "expiry_datetime":
            self.expiry_datetime.strftime('%Y-%m-%d %H:%M:%S'),
            "final_bid_price": self.final_bid_price
        }


@app.route("/health")
def health_check():
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)

    return jsonify(
        {
            "message": "Service is healthy.",
            "service:": "orders",
            "ip_address": local_ip
        }
    ), 200


@app.route("/orders")
def get_all():
    order_list = Order.query.all()
    if len(order_list) != 0:
        return jsonify(
            {
                "data": {
                    "orders": [order.to_dict() for order in order_list]
                }
            }
        ), 200
    return jsonify(
        {
            "message": "There are no orders."
        }
    ), 404


@app.route("/orders/<string:order_id>")
def find_by_id(order_id):
    order = Order.query.filter_by(order_id=order_id).first()
    if order:
        return jsonify(
            {
                "data": order.to_dict()
            }
        ), 200
    return jsonify(
        {
            "message": "Order not found."
        }
    ), 404


@app.route("/past_orders/<string:orderer_user_id>")
def find_by_orderer_id(orderer_user_id):
    order_list = Order.query.filter_by(orderer_user_id=orderer_user_id).all()
    if order_list:
        return jsonify(
            {
                "data": {
                    "orders": [order.to_dict() for order in order_list]
                }
            }
        ), 200
    return jsonify(
        {
            "message": "User has no past orders."
        }
    ), 404


@app.route("/past_runs/<string:runner_user_id>")
def find_by_runner_id(runner_user_id):
    order_list = Order.query.filter_by(runner_user_id=runner_user_id).all()
    if order_list:
        return jsonify(
            {
                "data": {
                    "orders": [order.to_dict() for order in order_list]
                }
            }
        ), 200
    return jsonify(
        {
            "message": "User has no past runs."
        }
    ), 404


@app.route("/orders/orders-by-username/<string:orderer_username>")
def find_by_orderer_username(orderer_username):
    order_list = Order.query.filter_by(orderer_username=orderer_username).all()
    if order_list:
        return jsonify(
            {
                "data": {
                    "orders": [order.to_dict() for order in order_list]
                }
            }
        ), 200
    return jsonify(
        {
            "message": "User has no past orders."
        }
    ), 404


@app.route("/orders/runs-by-username/<string:runner_username>")
def find_by_runner_username(runner_username):
    order_list = Order.query.filter_by(runner_username=runner_username).all()
    if order_list:
        return jsonify(
            {
                "data": {
                    "orders": [order.to_dict() for order in order_list]
                }
            }
        ), 200
    return jsonify(
        {
            "message": "User has no past runs."
        }
    ), 404


# ! Add error handling for creation time
@app.route("/order", methods=['POST'])
def new_order():
    try:
        data = request.get_json()
        order = Order(**data)

        # Add create and add UUID
        order_id = str(uuid.uuid4())
        order.order_id = order_id

        (formatted_date,) = datetime.strptime(
            order.expiry_datetime, '%Y-%m-%dT%H:%M:%S.%fZ'),
        order.expiry_datetime = formatted_date

        db.session.add(order)
        db.session.commit()
    except Exception as e:
        return jsonify(
            {
                "message": "An error occurred creating the order.",
                "error": str(e)
            }
        ), 500

    return jsonify(
        {
            "data": order.to_dict()
        }
    ), 201


@app.route("/orders/<string:order_id>", methods=['PATCH'])
def update_order(order_id):
    order = Order.query.with_for_update(of=Order)\
                 .filter_by(order_id=order_id).first()
    if order is not None:
        data = request.get_json()
        if 'bid_id' in data.keys():
            order.bid_id = data['bid_id']
        if 'runner_user_id' in data.keys():
            order.runner_user_id = data['runner_user_id']
        if 'runner_username' in data.keys():
            order.runner_username = data['runner_username']
        if 'flavour' in data.keys():
            order.flavour = data['flavour']
        if 'quantity' in data.keys():
            order.quantity = data['quantity']
        if 'delivery_info' in data.keys():
            order.delivery_info = data['delivery_info']
        if 'expiry_time' in data.keys():
            order.expiry_time = data['expiry_time']
        if 'final_bid_price' in data.keys():
            order.final_bid_price = data['final_bid_price']
        try:
            db.session.commit()
        except Exception as e:
            return jsonify(
                {
                    "message": "An error occurred updating the order.",
                    "error": str(e)
                }
            ), 500
        return jsonify(
            {
                "data": order.to_dict()
            }
        ), 200
    return jsonify(
        {
            "data": {
                "order_id": order_id
            },
            "message": "Order not found."
        }
    ), 404


@app.route("/orders/<string:order_id>", methods=['DELETE'])
def delete_order(order_id):
    order = Order.query.with_for_update(of=Order)\
                 .filter_by(order_id=order_id).first()
    if order is not None:
        db.session.delete(order)
        try:
            db.session.commit()
        except Exception as e:
            return jsonify(
                {
                    "message": "An error occurred deleting the order.",
                    "error": str(e)
                }
            ), 500
        return jsonify(
            {
                "message": "Order successfully deleted."
            }
        ), 200
    return jsonify(
        {
            "data": {
                "order_id": order_id
            },
            "message": "Order not found."
        }
    ), 404


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002, debug=True)
