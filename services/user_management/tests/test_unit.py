# Standard library imports...
import json
import os

# Third-party imports...
import pytest
import requests_mock

users_service_url = os.environ.get("users_service_url_internal")
payments_service_url = os.environ.get("payments_service_url_internal")

def call(client, path, method='GET', body=None, headers={
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }):

    if method == 'POST':
        response = client.post(path, data=json.dumps(body), headers=headers)
    elif method == 'PUT':
        response = client.put(path, data=json.dumps(body), headers=headers)
    elif method == 'PATCH':
        response = client.patch(path, data=json.dumps(body), headers=headers)
    elif method == 'DELETE':
        response = client.delete(path, headers=headers)
    else:
        response = client.get(path, headers=headers)

    return {
        "json": json.loads(response.data.decode('utf-8')),
        "code": response.status_code
    }

@pytest.mark.dependency()
def test_register_user(client, requests_mock):
    requests_mock.post(
        f'{users_service_url}/register/',
        status_code=201, 
        json={
            "id": "a2f76b4e-1605-4e62-9e88-895920ba837b",
            "first_name": "",
            "last_name": "",
            "username": "test@test.com",
            "telegram_id": "",
            "telegram_name": ""
        })

    requests_mock.post(
        f'{payments_service_url}/accounts',
        status_code=201, 
        json={
            "userId": "a2f76b4e-1605-4e62-9e88-895920ba837b",
            "connectedAccountId": "acct_1LvEI3RKiiZzqLhd",
            "customerId": "cus_MeXMzigdl65O7K",
            "updatedAt": "2022-10-21T06:01:09.832Z",
            "createdAt": "2022-10-21T06:01:09.832Z"
        })

    result = call(client, 'user-mgmt/register', 'POST', 
                {
                    "email": "test@test.com",
                    "password": "test"
                })

    assert result['code'] == 201
    assert result['json'] == {
            "id": "a2f76b4e-1605-4e62-9e88-895920ba837b",
            "first_name": "",
            "last_name": "",
            "username": "test@test.com",
            "telegram_id": "",
            "telegram_name": ""
        }

@pytest.mark.dependency()
def test_update_telegram_info(client, requests_mock):
    user_id = 'a2f76b4e-1605-4e62-9e88-895920ba837b'
    requests_mock.post(
        f'{users_service_url}/login/',
        status_code=200, 
        json={
            "id": user_id,
            "token": "token",
            "first_name": "",
            "last_name": "",
            "username": "test@test.com",
            "telegram_id": "",
            "telegram_name": ""
        })
    
    requests_mock.put(
        f'{users_service_url}/update-telegram-id/{user_id}/',
        status_code=200,
        json={
            "id": user_id,
            "telegram_username": "telegramname",
            "telegram_id": "123456789",
            "username": "test@test.com",
            "first_name": "",
            "last_name": ""
        })

    result = call(client, 'user-mgmt/telegram', 'POST', 
                {
                    "telegram_name": "telegramname",
                    "telegram_chat_id": "123456789",
                    "username": "test@test.com",
                    "password": "test"
                })

    assert result['code'] == 200
    assert result['json'] == {
            "user_id": user_id,
            "telegram_chat_id": "123456789",
            "telegram_name": "telegramname"
        }

@pytest.mark.dependency()
def test_onboarding_no_payment(client, requests_mock): 
    user_id = 'a2f76b4e-1605-4e62-9e88-895920ba837b'

    requests_mock.get(
        f'{users_service_url}/retrieve/{user_id}/',
        status_code=200,
        json={
            "id": user_id,
            "telegram_username": "telegramname",
            "telegram_id": "123456789",
            "username": "test@test.com",
            "first_name": "",
            "last_name": ""
        })

    requests_mock.get(
        f'{payments_service_url}/accounts/connected-account-verified/{user_id}',
        status_code=200,
        json={
            "connectedAccountVerified": True
            })

    requests_mock.get(
        f'{payments_service_url}/accounts/payment-methods/{user_id}',
        status_code=404,
        json={
            "type": "NoPaymentMethod",
            "message": "This account has no payment methods."
        }
    )

    result = call(client, f'user-mgmt/onboarding-status/{user_id}', 'GET', headers={
        'Content-Type': 'application/json',
        'Authorization': 'Bearer token'
    })

    assert result['code'] == 200
    assert result['json'] == {
            "connectedAccountValid": True,
            "customerValid": False,
            "telegramValid": True,
        }