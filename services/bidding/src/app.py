import socket
import os
import uuid

from datetime import datetime
from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
db_name = '/bid_service_db'
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


class Bid(db.Model):
    __tablename__ = 'bid'

    bid_id = db.Column(db.String, primary_key=True)
    order_id = db.Column(db.String, nullable=False)
    creation_datetime = db.Column(db.DateTime, nullable=False)
    expiry_datetime = db.Column(db.DateTime, nullable=False)
    bid_price = db.Column(db.Float(precision=2), nullable=False)
    bid_status = db.Column(db.String, nullable=False,
                           default='OPEN')
    last_updated = db.Column(db.DateTime, nullable=False,
                             default=datetime.now)

    def __init__(self, order_id, creation_datetime, expiry_datetime,
                 bid_price, bid_status='OPEN'):
        self.order_id = order_id
        self.creation_datetime = creation_datetime
        self.expiry_datetime = expiry_datetime
        self.bid_price = bid_price
        self.bid_status = bid_status

    # ? modify to return datetime in a more readable format?
    def to_dict(self):
        return {
            "bid_id": self.bid_id,
            "order_id": self.order_id,
            "creation_datetime":
            self.creation_datetime.strftime('%Y-%m-%d %H:%M:%S'),
            "expiry_datetime":
            self.expiry_datetime.strftime('%Y-%m-%d %H:%M:%S'),
            "bid_price": self.bid_price,
            "bid_status": self.bid_status,
            "last_updated":
            self.last_updated.strftime('%Y-%m-%d %H:%M:%S')
        }


@app.route("/health")
def health_check():
    hostname = socket.gethostname()
    local_ip = socket.gethostbyname(hostname)

    return jsonify(
        {
            "message": "Bidding Service is healthy.",
            "service:": "bidding",
            "ip_address": local_ip
        }
    ), 200


@app.route("/bids")
def get_all():
    bid_list = Bid.query.all()
    if len(bid_list) != 0:
        return jsonify(
            {
                "data": {
                    "bids": [bid.to_dict() for bid in bid_list]
                }
            }
        ), 200
    return jsonify(
        {
            "message": "There are no bids."
        }
    ), 404


@app.route("/bids/<string:bid_id>")
def find_by_id(bid_id):
    bid = Bid.query.filter_by(bid_id=bid_id).first()
    if bid:
        return jsonify(
            {
                "data": bid.to_dict()
            }
        ), 200
    return jsonify(
        {
            "message": "Bid not found."
        }
    ), 404


@app.route("/bids", methods=['POST'])
def new_bid():
    try:
        data = request.get_json()
        bid = Bid(**data)

        # Add create and add UUID
        bid_id = str(uuid.uuid4())
        bid.bid_id = bid_id
        (formatted_date, ) = datetime.strptime(bid.expiry_datetime, '%Y-%m-%d %H:%M:%S'),
        bid.expiry_datetime = formatted_date

        db.session.add(bid)
        db.session.commit()
    except Exception as e:
        return jsonify(
            {
                "message": "An error occurred creating the bid.",
                "error": str(e)
            }
        ), 500

    return jsonify(
        {
            "data": bid.to_dict()
        }
    ), 201


@app.route("/bids/<string:bid_id>", methods=['PATCH'])
def update_bid(bid_id):
    bid = Bid.query.with_for_update(of=Bid)\
        .filter_by(bid_id=bid_id).first()
    if bid is not None:
        data = request.get_json()
        if 'expiry_datetime' in data.keys():
            bid.expiry_datetime = data['expiry_datetime']
        if 'bid_price' in data.keys():
            bid.bid_price = data['bid_price']
        if 'bid_status' in data.keys():
            bid.bid_status = data['bid_status']

        bid.last_updated = datetime.now()

        try:
            db.session.commit()
        except Exception as e:
            return jsonify(
                {
                    "message": "An error occurred updating the bid.",
                    "error": str(e)
                }
            ), 500
        return jsonify(
            {
                "data": bid.to_dict()
            }
        ), 200
    return jsonify(
        {
            "data": {
                "bid_id": bid_id
            },
            "message": "Bid not found."
        }
    ), 404


@app.route("/bids/fufill-bid/<string:bid_id>", methods=['PATCH'])
def fufill_bid(bid_id):
    bid = Bid.query.with_for_update(of=Bid)\
        .filter_by(bid_id=bid_id).first()
    if bid is not None:
        if bid.bid_status == 'CLOSED':
            return jsonify(
                {
                    "message": "An error occurred updating the bid.",
                    "error": "Waffle has already been bidded for"
                }
            ), 500
        bid.bid_status = 'CLOSED'
        bid.last_updated = datetime.now()

        try:
            db.session.commit()
        except Exception as e:
            return jsonify(
                {
                    "message": "An error occurred updating the bid.",
                    "error": str(e)
                }
            ), 500
        return jsonify(
            {
                "data": bid.to_dict()
            }
        ), 200
    return jsonify(
        {
            "data": {
                "bid_id": bid_id
            },
            "message": "Bid not found."
        }
    ), 404


@app.route("/bids/<string:bid_id>", methods=['DELETE'])
def delete_bid(bid_id):
    bid = Bid.query.with_for_update(of=Bid)\
        .filter_by(bid_id=bid_id).first()
    if bid is not None:
        db.session.delete(bid)
        try:
            db.session.commit()
        except Exception as e:
            return jsonify(
                {
                    "message": "An error occurred deleting the bid.",
                    "error": str(e)
                }
            ), 500
        return jsonify(
            {
                "message": "Bid successfully deleted."
            }
        ), 200
    return jsonify(
        {
            "data": {
                "bid_id": bid_id
            },
            "message": "Bid not found."
        }
    ), 404


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5077, debug=True)
