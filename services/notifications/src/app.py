import json
import amqp_setup
from os import environ
import requests

TELEGRAM_URL = environ.get(
    key='TELEGRAM_URL', default='http://3.135.214.65:5001')


def callback(channel, method, properties, body):
    message_body = json.loads(body)
    telegram_chat_id = message_body['telegram_chat_id']
    order_id = message_body['order_id']
    order_status = message_body['order_status']

    payload = {
        'chat_id': telegram_chat_id,
        'text': f'Order ID:{order_id} - Status:{order_status}'
    }

    url = f'{TELEGRAM_URL}/send'
    response = requests.post(url=url, json=payload)
    print(response.status_code)
    return "Success"


amqp_setup.channel.basic_consume(
    queue=amqp_setup.queue_name, on_message_callback=callback, auto_ack=True)
amqp_setup.channel.start_consuming()
