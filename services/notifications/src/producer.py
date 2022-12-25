import amqp_setup
import pika
import json

notification_data = {
    'telegram_chat_id': 1205271847,
    'order_id': 'XYZ123',
    'order_status': 'Placed'
}

connection = pika.BlockingConnection(amqp_setup.parameters)

channel = connection.channel()

channel.basic_publish(
    exchange=amqp_setup.exchange_name, routing_key="order.new",
    body=json.dumps(notification_data),
    properties=pika.BasicProperties(delivery_mode=2))

connection.close()
