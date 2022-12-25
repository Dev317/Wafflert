import React, { useEffect } from "react";
import "./index.css";

import { useNavigate } from "react-router-dom";
import ArrowBack from "@mui/icons-material/ArrowBack";

import Table from "react-bootstrap/Table";
import Button from "react-bootstrap/Button";
import Image from "react-bootstrap/Image";
import back from "./Waffle.png";
import { TinyPoskitt } from "../../Common/LoadingAni";

import { useDispatch, useSelector } from "react-redux";
import {
  getAllCurrentOrders,
  getAllPastOrders,
  getAllCurrentRuns,
  getAllPastRuns,
  confirmOrder,
} from "./Redux/actions";
import { Alert } from "react-bootstrap";

function OrderRunForm() {
  const navigate = useNavigate();
  const dispatch = useDispatch();

  const currentOrders = useSelector((state) => state.currentOrdersReducer);
  const { waffleOrder, orderloading } = currentOrders;

  const pastOrders = useSelector((state) => state.pastOrderReducer);
  const { pastWaffleOrder, pastoloading } = pastOrders;

  const currentRuns = useSelector((state) => state.runReducer);
  const { waffleRuns, runloading } = currentRuns;

  const pastRuns = useSelector((state) => state.pastRunReducer);
  const { pastwaffleRun, pastrloading } = pastRuns;

  const confirmOrderR = useSelector((state) => state.confirmOrderReducer);
  const { loading: confirmLoading, message: confirmMsg } = confirmOrderR;

  useEffect(() => {
    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    if (userInfo) {
      const { telegram_username: username, id: userId } = userInfo;

      dispatch(getAllCurrentOrders(username));
      dispatch(getAllPastOrders(userId));
      dispatch(getAllCurrentRuns(username));
      dispatch(getAllPastRuns(userId));
    }
  }, [dispatch]);

  const handleConfirm = (event, orderId) => {
    event.preventDefault();
    dispatch(confirmOrder(orderId));
  };

  return (
    <div>
      <Image className="bg" src={back} alt={"background"} />
      {/* <img src={wafbanner3} className="bg" alt="banner background" /> */}
      <Button
        variant="dark"
        className="my-5"
        onClick={() => {
          navigate("/user/home/");
        }}
      >
        <ArrowBack className="mx-1" /> back
      </Button>
      <div className="d-flex flex-column justify-content-start ">
        <h1>Waffle Orders & Runs</h1>

        {/* pastorders  */}
        <h2 className="mt-5 ml-1">My ongoing orders</h2>
        {!confirmLoading && confirmMsg && (
          <Alert variant="success">Waffle received!</Alert>
        )}
        <Table variant="dark" striped bordered hover size="sm">
          <thead>
            <tr>
              <th>#</th>
              <th>Flavour</th>
              <th>Quantity</th>
              <th>Delivery Info</th>
              <th>Ordered For</th>
              <th>Status</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {waffleOrder &&
              waffleOrder.map((order, idx) => {
                return (
                  <tr key={idx}>
                    <td>{idx + 1}</td>
                    <td>{order.flavour}</td>
                    <td>{order.quantity}</td>
                    <td>{order.delivery_info}</td>
                    <td>{order.expiry_datetime}</td>
                    <td>
                      {order.final_bid_price > 0 ? "Picked up" : "Ongoing"}
                    </td>
                    <td>
                      {order.final_bid_price > 0 && (
                        <Button
                          variant="outline-warning"
                          onClick={(e) => handleConfirm(e, order.order_id)}
                        >
                          Received!
                        </Button>
                      )}
                    </td>
                  </tr>
                );
              })}
            {orderloading && (
              <div className="d-flex justify-content-center align-items-center">
                <TinyPoskitt /> <h3 className="px-2">Loading...</h3>{" "}
                <TinyPoskitt />
              </div>
            )}
            {!waffleOrder && <h1> No orders! </h1>}
          </tbody>
        </Table>

        <h2 className="mt-5 ml-1">My Current Runs</h2>
        <Table variant="dark" striped bordered hover size="sm">
          <thead>
            <tr>
              <th>#</th>
              <th>Flavour</th>
              <th>Quantity</th>
              <th>Delivery Info</th>
              <th>Deliver By</th>
              <th>Final bid price </th>
              <th>Orderer username</th>
            </tr>
          </thead>
          <tbody>
            {waffleRuns &&
              waffleRuns.map((order, idx) => {
                return (
                  <tr key={idx}>
                    <td>{idx + 1}</td>
                    <td>{order.flavour}</td>
                    <td>{order.quantity}</td>
                    <td>{order.delivery_info}</td>
                    <td>{order.expiry_datetime}</td>
                    <td>{order.final_bid_price}</td>
                    <td>{order.orderer_name}</td>
                  </tr>
                );
              })}
            {runloading && (
              <div className="d-flex justify-content-center align-items-center">
                <TinyPoskitt /> <h3 className="px-2">Loading...</h3>{" "}
                <TinyPoskitt />
              </div>
            )}
            {!waffleRuns && <h1>No Orders!</h1>}
          </tbody>
        </Table>

        {/* Past Runs */}
        <h2 className="mt-5 ml-1">My past orders</h2>
        <Table striped bordered hover size="sm">
          <thead>
            <tr>
              <th>#</th>
              <th>Flavour</th>
              <th>Quantity</th>
              <th>Delivery Info</th>
              <th>Date & time ordered</th>
              <th>Final bid price </th>
              <th>Runner</th>
            </tr>
          </thead>
          <tbody>
            {pastWaffleOrder &&
              pastWaffleOrder.map((order, idx) => {
                return (
                  <tr key={idx}>
                    <td>{idx + 1}</td>
                    <td>{order.flavour}</td>
                    <td>{order.quantity}</td>
                    <td>{order.delivery_info}</td>
                    <td>{order.creation_datetime}</td>
                    <td>{order.final_bid_price}</td>
                    <td>{order.runner_username}</td>
                  </tr>
                );
              })}
            {pastoloading && (
              <div className="d-flex justify-content-center align-items-center">
                <TinyPoskitt /> <h3 className="px-2">Loading...</h3>{" "}
                <TinyPoskitt />
              </div>
            )}
            {!pastWaffleOrder && <h1>No orders!</h1>}
          </tbody>
        </Table>

        {/* Past Runs */}
        <h2 className="mt-5 ml-1">My past runs</h2>
        <Table striped bordered hover size="sm">
          <thead>
            <tr>
              <th>#</th>
              <th>Flavour</th>
              <th>Quantity</th>
              <th>Delivery Info</th>
              <th>Date & time ordered</th>
              <th>Final bid price </th>
              <th>Orderer username </th>
              <th>Orderer Id </th>
            </tr>
          </thead>
          <tbody>
            {pastwaffleRun &&
              pastwaffleRun.map((order, idx) => {
                return (
                  <tr key={idx}>
                    <td>{idx + 1}</td>
                    <td>{order.flavour}</td>
                    <td>{order.quantity}</td>
                    <td>{order.delivery_info}</td>
                    <td>{order.creation_datetime}</td>
                    <td>{order.final_bid_price}</td>
                    <td>{order.orderer_name}</td>
                    <td>{order.order_id}</td>
                  </tr>
                );
              })}
            {pastrloading && (
              <div className="d-flex justify-content-center align-items-center">
                <TinyPoskitt /> <h3 className="px-2">Loading...</h3>{" "}
                <TinyPoskitt />
              </div>
            )}
            {!pastwaffleRun && <h1>No orders!</h1>}
          </tbody>
        </Table>
      </div>
    </div>
  );
}

export default OrderRunForm;
