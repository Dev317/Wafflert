import json
import pytest


def call(client, path, method='GET', body=None):
    mimetype = 'application/json'
    headers = {
        'Content-Type': mimetype,
        'Accept': mimetype
    }

    if method == 'POST':
        response = client.post(path, data=json.dumps(body), headers=headers)
    elif method == 'PUT':
        response = client.put(path, data=json.dumps(body), headers=headers)
    elif method == 'PATCH':
        response = client.patch(path, data=json.dumps(body), headers=headers)
    elif method == 'DELETE':
        response = client.delete(path)
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


# @pytest.mark.dependency()
# def test_get_all(client):
#     result = call(client, 'orders')
#     assert result['code'] == 200
#     print(result['json']['data']['orders'])
#     assert result['json']['data']['orders'] == [
#         {
#         "bid_id": "12345678-abcd-abcd-abcd-12345678bid1",
#         "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
#         "delivery_info": "Deliver to SOE",
#         "expiry_datetime": "Fri, 14 Oct 2022 12:00:00 GMT",
#         "final_bid_price": 2.5,
#         "flavour": "Cheese",
#         "order_id": "12345678-abcd-abcd-abcd-12345678ord1",
#         "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr1",
#         "quantity": 1,
#         "runner_user_id": "12345678-abcd-abcd-abcd-12345678usr2"
#       },
#       {
#         "bid_id": "12345678-abcd-abcd-abcd-12345678bid2",
#         "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
#         "delivery_info": "Deliver to SCIS gate",
#         "expiry_datetime": "Fri, 14 Oct 2022 12:05:00 GMT",
#         "final_bid_price": 8.0,
#         "flavour": "Strawberry",
#         "order_id": "12345678-abcd-abcd-abcd-12345678ord2",
#         "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr1",
#         "quantity": 3,
#         "runner_user_id": "12345678-abcd-abcd-abcd-12345678usr2"
#       },
#       {
#         "bid_id": None,
#         "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
#         "delivery_info": "SOA L2",
#         "expiry_datetime": "Fri, 14 Oct 2022 12:10:00 GMT",
#         "final_bid_price": None,
#         "flavour": "Kaya",
#         "order_id": "12345678-abcd-abcd-abcd-12345678ord3",
#         "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr2",
#         "quantity": 2,
#         "runner_user_id": None
#       },
#       {
#         "bid_id": None,
#         "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
#         "delivery_info": "SCIS SR 2-1",
#         "expiry_datetime": "Fri, 14 Oct 2022 12:15:00 GMT",
#         "final_bid_price": None,
#         "flavour": "PB",
#         "order_id": "12345678-abcd-abcd-abcd-12345678ord4",
#         "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr3",
#         "quantity": 1,
#         "runner_user_id": None
#       },
#       {
#         "bid_id": None,
#         "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
#         "delivery_info": "LKS L1",
#         "expiry_datetime": "Fri, 14 Oct 2022 12:20:00 GMT",
#         "final_bid_price": None,
#         "flavour": "Blueberry Cheese",
#         "order_id": "12345678-abcd-abcd-abcd-12345678ord5",
#         "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr4",
#         "quantity": 4,
#         "runner_user_id": None
#       }
#     ]
