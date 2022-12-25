import React from "react";
import OrderTable from "./Component/OrderTable";
import { useNavigate } from "react-router-dom";
import { Button } from "@mui/material";
import ArrowBack from "@mui/icons-material/ArrowBack";
import ArrowForward from "@mui/icons-material/ArrowForward";
import { Image } from "react-bootstrap";
import wafback from "../../Common/Assets/wafback1.jpg";
import "./index.css"


function Order() {
  const navigate = useNavigate();


const ordersData =[
  {
    "data": {
      "orders": [
        {
          "bid_id": "12345678-abcd-abcd-abcd-12345678bid1",
          "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
          "delivery_info": "Deliver to SOE",
          "expiry_datetime": "Fri, 14 Oct 2022 12:00:00 GMT",
          "final_bid_price": 2.5,
          "flavour": "Cheese",
          "order_id": "12345678-abcd-abcd-abcd-12345678ord1",
          "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr1",
          "quantity": 1,
          "runner_user_id": "12345678-abcd-abcd-abcd-12345678usr2"
        },
        {
          "bid_id": "12345678-abcd-abcd-abcd-12345678bid2",
          "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
          "delivery_info": "Deliver to SCIS gate",
          "expiry_datetime": "Fri, 14 Oct 2022 12:05:00 GMT",
          "final_bid_price": 8.0,
          "flavour": "Strawberry",
          "order_id": "12345678-abcd-abcd-abcd-12345678ord2",
          "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr1",
          "quantity": 3,
          "runner_user_id": "12345678-abcd-abcd-abcd-12345678usr2"
        },
        {
          "bid_id": null,
          "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
          "delivery_info": "SOA L2",
          "expiry_datetime": "Fri, 14 Oct 2022 12:10:00 GMT",
          "final_bid_price": null,
          "flavour": "Kaya",
          "order_id": "12345678-abcd-abcd-abcd-12345678ord3",
          "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr2",
          "quantity": 2,
          "runner_user_id": null
        },
        {
          "bid_id": null,
          "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
          "delivery_info": "SCIS SR 2-1",
          "expiry_datetime": "Fri, 14 Oct 2022 12:15:00 GMT",
          "final_bid_price": null,
          "flavour": "PB",
          "order_id": "12345678-abcd-abcd-abcd-12345678ord4",
          "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr3",
          "quantity": 1,
          "runner_user_id": null
        },
        {
          "bid_id": null,
          "creation_datetime": "Fri, 14 Oct 2022 08:00:00 GMT",
          "delivery_info": "LKS L1",
          "expiry_datetime": "Fri, 14 Oct 2022 12:20:00 GMT",
          "final_bid_price": null,
          "flavour": "Blueberry Cheese",
          "order_id": "12345678-abcd-abcd-abcd-12345678ord5",
          "orderer_user_id": "12345678-abcd-abcd-abcd-12345678usr4",
          "quantity": 4,
          "runner_user_id": null
        }
      ]
    }
  }
]




  return (
    <div>
      <Image className="order-bg" fluid src={wafback} />
      <div className="d-flex flex-row justify-content-between">
      <Button
        variant="dark"
        className="mt-5"
        onClick={() => {
          navigate("/user/home");
        }}
      >
        
        <ArrowBack className="mx-1" /> back
      </Button>
      <Button
        variant="dark"
        className="mt-5"
        onClick={() => {
          navigate("/user/orderwaffleform");
        }}
      >
        
        <ArrowForward className="mx-1" /> Order waffle!
      </Button>
      </div>
      
      <OrderTable/>
    </div>
  );
}

export default Order;
