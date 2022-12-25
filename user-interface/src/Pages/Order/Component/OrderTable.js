import React, { useEffect } from "react";
import { Table, Button, Alert } from "react-bootstrap";
import "../index.css";

import { useDispatch, useSelector } from "react-redux";
import { getOrderDetails, confirmRunner } from "../Redux/actions";
import { TinyPoskitt } from "../../../Common/LoadingAni";

function OrderTable() {
  const dispatch = useDispatch();

  const allOrders = useSelector((state) => state.ordersReducer);
  const { loading, error, orderInfo, acceptedOrder } = allOrders;

  const userInfo = JSON.parse(localStorage.getItem("userInfo"));
  // make loading error for error

  const handleRunnerAccept = (event, bidId) => {
    event.preventDefault();
    dispatch(confirmRunner(bidId));
  };

  useEffect(() => {
    dispatch(getOrderDetails);
  }, [dispatch]);

  useEffect(() => {
    if (!loading && acceptedOrder) {
      window.setTimeout(() => {
        dispatch(getOrderDetails);
      }, 3000);
    }
  }, [acceptedOrder]);

  return (
    <div className="d-flex flex-column mt-5">
      <h1 className="mb-5">The Waffle Market</h1>

      {!loading && acceptedOrder && (
        <Alert variant="success">Successfully accepted order!</Alert>
      )}
      <Table size="lg" responsive="md" borderless striped>
        <thead>
          <tr>
            <th>#</th>
            <th>Orderer</th>
            <th>Delivery Info</th>
            <th>Flavour</th>
            <th>Quantity</th>
            <th>Bid Price</th>
            <th></th>
          </tr>
        </thead>
        {orderInfo &&
          orderInfo.map((data, idx) => {
            return (
              <tbody key={idx}>
                <tr>
                  <td>{idx + 1}</td>
                  <td>{data.orderer_name}</td>
                  <td>{data.delivery_info}</td>
                  <td>{data.flavour}</td>
                  <td>{data.quantity} </td>
                  <td>{data.bid_price}</td>
                  <td>
                    {data.orderer_user_id === userInfo.id ? (
                      <></>
                    ) : data.runner_user_id === userInfo.id ? (
                      <Button variant="light" disabled>
                        Picked up
                      </Button>
                    ) : (
                      <Button
                        variant="btn btn-outline-dark"
                        onClick={(event) =>
                          handleRunnerAccept(event, data.bid_id)
                        }
                      >
                        Run for order
                      </Button>
                    )}
                  </td>
                </tr>
              </tbody>
            );
          })}
      </Table>
      {loading && (
        <div className="d-flex justify-content-center align-items-center">
          <TinyPoskitt /> <h3 className="px-2">Loading...</h3> <TinyPoskitt />
        </div>
      )}
      {!orderInfo && <h1>{error}</h1>}
    </div>
  );
}

export default OrderTable;
