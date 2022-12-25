import React, { useEffect } from "react";
import { Table, Button } from "react-bootstrap";
import { useDispatch, useSelector } from "react-redux";
import { getAllOrders } from "../Redux/actions";

function Scoreboard() {
  const dispatch = useDispatch();

  const scoreboardR = useSelector((state) => state.scoreboardReducer);
  const { loading, error, orderInfo } = scoreboardR;

  useEffect(() => {
    dispatch(getAllOrders);
  }, []);

  return (
    <Table striped borderless hover size="sm" className="mt-4">
      <thead>
        <tr>
          <th>#</th>
          <th>Orderer</th>
          <th>Bid</th>
          <th>Flavour</th>
          <th>Quantity</th>
          <th>Runner</th>
        </tr>
      </thead>
      <tbody>
        {orderInfo &&
          orderInfo.map((row, index) => {
            return (
              <tr key={index}>
                <td>{index + 1}</td>
                <td>@{row.orderer_name}</td>
                <td>{row.final_bid_price}</td>
                <td>{row.flavour}</td>
                <td>{row.quantity}</td>
                <td>@{row.runner_username}</td>
              </tr>
            );
          })}
      </tbody>
    </Table>
  );
}

export default Scoreboard;
