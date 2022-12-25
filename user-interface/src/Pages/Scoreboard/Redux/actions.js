import {
  ALL_ORDERS_ERROR,
  ALL_ORDERS_REQUEST,
  ALL_ORDERS_RESET,
  ALL_ORDERS_SUCCESS,
} from "./constants";
import instance from "../../../urls";

const NUM_RECORDS = 10;

export const getAllOrders = async (dispatch) => {
  try {
    dispatch({
      type: ALL_ORDERS_REQUEST,
    });

    const config = {
      headers: {
        "Content-type": "application/json",
      },
    };

    const { data } = await instance.get(`/orders`, config);

    let orders = data["data"]["orders"];

    orders
      .sort((a, b) => {
        return a.final_bid_price < b.final_bid_price
          ? -1
          : a.final_bid_price > b.final_bid_price
          ? 1
          : 0;
      })
      .reverse();

    orders = orders.filter((order) => {
      return order.runner_user_id !== null;
    });

    dispatch({
      type: ALL_ORDERS_SUCCESS,
      payload: orders.slice(0, NUM_RECORDS),
    });
  } catch (error) {
    dispatch({
      type: ALL_ORDERS_ERROR,
      payload: error.response && error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: ALL_ORDERS_RESET });
    }, 5000);
  }
};
