from pytest import mark
from telethon import TelegramClient
from telethon.tl.custom.message import Message
import pytest
import requests_mock
import json
import requests


def call(client, path, method='GET', body=None):
    mimetype = 'application/json'
    headers = {
        'Content-Type': mimetype,
        'Accept': mimetype
    }

    if method == 'POST':
        response = client.post(path, data=json.dumps(body), headers=headers)
    else:
        response = client.get(path)

    return {
        "json": json.loads(response.data.decode('utf-8')),
        "code": response.status_code
    }


@pytest.mark.dependency()
def test_health(client):
    result = call(client, 'health')
    assert result['code'] == 200


@pytest.mark.dependency()
def test_send_notification(client):
    result = call(client, 'send', 'POST', {
        "chat_id": 1205271847,
        "text": "Order submitted!",
    })

    assert result['code'] == 200
    assert result['json']['message'] == "Sent!"


@pytest.mark.anyio
async def test_start(conv, requests_mock):
    requests_mock.post('https://user_composite-api.com/user-mgmt/telegram',
                       json={"message": "Registration successful!"}
                       )

    await conv.send_message("/register")

    resp: Message = await conv.get_response()

    assert "Please provide us your username!" in resp.raw_text

    message = "Minh"
    await conv.send_message(message)
    resp: Message = await conv.get_response()

    assert "Please provide us your password!" in resp.raw_text

    message = "minhtest"
    await conv.send_message(message)

    resp: Message = await conv.get_response()
    assert "Verifying..." in resp.raw_text

    resp: Message = await conv.get_response()
    assert "Registration successful!" in requests.post(
        "https://user_composite-api.com/user-mgmt/telegram").json()['message']
