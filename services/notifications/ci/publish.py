import asyncio
import aiormq
from amqp_mock import AmqpServer, HttpServer, Storage, create_amqp_mock
import json


async def main():
    notification_data = {
        'telegram_chat_id': 1205271847,
        'order_id': 'XYZ123',
        'order_status': 'Placed'
    }

    storage = Storage()

    http_server = HttpServer(storage, port=15672)
    amqp_server = AmqpServer(storage, port=5672)

    async with create_amqp_mock(http_server, amqp_server) as mock:
        connection = await aiormq.connect(f"amqp://{mock.amqp_server.host}:{mock.amqp_server.port}")

        channel = await connection.channel()
        exchange_name = "notifications.topic"
        exchange_type = "topic"
        await channel.exchange_declare(exchange=exchange_name,
                                       exchange_type=exchange_type, durable=True)

        await channel.basic_publish(json.dumps(notification_data).encode('utf-8'), exchange="notifications.topic", routing_key='order.*')
        message = await mock.client.get_exchange_messages("notifications.topic")
        assert message[0].value == notification_data

asyncio.run(main())
