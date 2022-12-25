import {
  USER_ORDER_REQUEST,
  USER_ORDER_SUCCESS,
  USER_ORDER_ERROR,
  USER_ORDER_RESET,
  RUNNER_ACCEPT_ERROR,
  RUNNER_ACCEPT_RESET,
  RUNNER_ACCEPT_REQUEST,
  RUNNER_ACCEPT_SUCCESS,
} from "./constants";
import instance from "../../../urls";

export const getOrderDetails = async (dispatch) => {
  try {
    dispatch({
      type: USER_ORDER_REQUEST,
    });
    const config = {
      headers: {
        "Content-type": "application/json",
      },
    };

    const { data: biddingData } = await instance.get(`/bids`, config);

    let bids = biddingData["data"]["bids"].filter((bid) => {
      return (
        bid["bid_status"] === "OPEN" &&
        new Date(bid["expiry_datetime"]) > Date.now()
      );
    });

    bids = await Promise.all(
      bids.map(async (bid) => {
        try {
          const { data: order } = await instance.get(
            `/orders/${bid["order_id"]}`,
            config
          );
          return { ...order["data"], ...bid };
        } catch (error) {
          throw error;
        }
      })
    );

    bids = bids
      .sort((a, b) => {
        return a.bid_price < b.bid_price
          ? -1
          : a.bid_price > b.bid_price
          ? 1
          : 0;
      })
      .reverse();

    dispatch({
      type: USER_ORDER_SUCCESS,
      payload: bids,
    });
  } catch (error) {
    dispatch({
      type: USER_ORDER_ERROR,
      payload: error.response && error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: USER_ORDER_RESET });
    }, 5000);
  }
};

export const confirmRunner = (bidId) => async (dispatch) => {
  try {
    dispatch({
      type: RUNNER_ACCEPT_REQUEST,
    });

    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    const {
      token: jwtToken,
      id: user_id,
      telegram_username: username,
    } = userInfo;

    const config = {
      headers: {
        "Content-type": "application/json",
        Authorization: `Bearer ${jwtToken}`,
      },
    };

    const { data } = await instance.patch(
      `/accept-order/${bidId}`,
      { user_id: user_id, username: username },
      config
    );

    dispatch({
      type: RUNNER_ACCEPT_SUCCESS,
      payload: data,
    });
  } catch (error) {
    dispatch({
      type: RUNNER_ACCEPT_ERROR,
      payload: error.response && error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: RUNNER_ACCEPT_RESET });
    }, 5000);
  }
};
