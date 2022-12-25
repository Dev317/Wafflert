import os
import telebot
import threading
from flask import Flask, request, jsonify
import flask
from flask_cors import CORS
import time
import requests
import json
import socket

TOKEN = os.environ.get(key="TELEGRAM_BOT_API_KEY",
                       default="5743164553:AAHlr7G-pOUeWSL8oPr9xa9TnjRYmWsw8hs")
bot = telebot.TeleBot(token=TOKEN)

user_map = {}

app = Flask(__name__)


CORS(app)

user_composite_service_url = os.environ.get(
    key="user_composite_service_url", default='http://3.135.214.65:5000')


WEBHOOK_HOST = os.environ.get(key="TELEGRAM_BOT_HOST_IP", default="None")
WEBHOOK_PORT = 8443  # 443, 80, 88 or 8443 (port need to be 'open')
WEBHOOK_LISTEN = '0.0.0.0'  # In some VPS you may need to put here the IP addr

WEBHOOK_SSL_CERT = '../webhook_cert.pem'  # Path to the ssl certificate
WEBHOOK_SSL_PRIV = '../webhook_pkey.pem'  # Path to the ssl private key


WEBHOOK_URL_BASE = "https://%s:%s" % (WEBHOOK_HOST, WEBHOOK_PORT)
WEBHOOK_URL_PATH = "/%s/" % (TOKEN)


@app.after_request
def after_request(response):
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add(
        "Access-Control-Allow-Headers", "origin, x-csrftoken, content-type, accept"
    )
    response.headers.add("Access-Control-Allow-Methods", "GET,PUT,POST,DELETE")
    return response


@bot.message_handler(commands=['start'])
def send_welcome(message):
    bot.reply_to(message, """Hi there, this is The WafBot!

Here are some of the commands that you might need 🤗:
📌  /register    : to link your TelegramId to your Waffle profile
📤  /subscribe   : to subscribe for surprise Waffle drop!""")


@bot.message_handler(commands=['register'])
def create_profile(message):
    response = bot.reply_to(message, "Please provide us your username!")
    bot.register_next_step_handler(response, post_password)


def post_password(message):
    user_map['username'] = message.text
    response = bot.reply_to(
        message, f"Hi {message.text}! Please provide us your password!")
    bot.register_next_step_handler(response, verify_step)


def verify_step(message):
    response = bot.reply_to(message, "Verifying...")

    user_map['password'] = message.text
    telegram_name = message.chat.username
    telegram_chat_id = message.chat.id

    payload = {
        "username": user_map["username"],
        "password": user_map["password"],
        "telegram_name": telegram_name,
        "telegram_chat_id": telegram_chat_id
    }

    try:
        url = user_composite_service_url + "/user-mgmt/telegram"
        response = requests.post(url, json=payload)

        if (response.status_code == 200):
            bot.reply_to(message, "Registration successful!")
        else:
            bot.reply_to(
                message, 'Oops! Invalid credentials. Please type /register to retry')
    except Exception as e:
        bot.reply_to(
            message, 'Oops! Something is wrong. Please type /register to retry')


@app.route("/health")
def health_check():
    '''This end point checks for health status'''

    return jsonify(
        {
            "message": "Service is healthy.",
        }
    ), 200


@app.route("/send", methods=["POST"])
def send_message():
    '''This end point sends notification via telegram_chat_id'''

    data = request.get_json()
    chat_id = data["chat_id"]
    text = data["text"]

    bot.send_message(chat_id=chat_id, text=text)
    return jsonify(
        {
            "message": "Sent!",
        }
    ), 200


@app.route("/")
def hello_world():
    return f"Telebot @{TOKEN} is live"


def start_bot():
    print("Bot started")
    print(user_composite_service_url)
    bot.infinity_polling()


def start_flask_app():
    app.run(host='0.0.0.0', port=5001, threaded=True)


@app.route(WEBHOOK_URL_PATH, methods=['POST'])
def webhook():
    if flask.request.headers.get('content-type') == 'application/json':
        json_string = flask.request.get_data().decode('utf-8')
        update = telebot.types.Update.de_json(json_string)
        bot.process_new_updates([update])
        return "Deployed successfully", 200
    else:
        flask.abort(403)


if __name__ == "__main__":
    if WEBHOOK_HOST == "None":
        run_app_thread = threading.Thread(target=start_flask_app)
        start_bot_thread = threading.Thread(target=start_bot)
        run_app_thread.start()
        start_bot_thread.start()
    else:
        bot.remove_webhook()
        time.sleep(0.1)
        bot.set_webhook(url=WEBHOOK_URL_BASE + WEBHOOK_URL_PATH)
        app.run(host="0.0.0.0", port=5001, debug=True)
