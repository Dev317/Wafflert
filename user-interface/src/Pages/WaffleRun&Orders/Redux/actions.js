import {
  WAFFLE_RUN_REQUEST,
  WAFFLE_RUN_SUCCESS,
  WAFFLE_RUN_ERROR,
  WAFFLE_RUN_RESET,
  WAFFLE_PAST_RUN_REQUEST,
  WAFFLE_PAST_RUN_SUCCESS,
  WAFFLE_PAST_RUN_ERROR,
  WAFFLE_PAST_RUN_RESET,
  WAFFLE_ORDER_REQUEST,
  WAFFLE_ORDER_SUCCESS,
  WAFFLE_ORDER_ERROR,
  WAFFLE_ORDER_RESET,
  WAFFLE_PAST_ORDER_REQUEST,
  WAFFLE_PAST_ORDER_SUCCESS,
  WAFFLE_PAST_ORDER_ERROR,
  WAFFLE_PAST_ORDER_RESET,
  WAFFLE_CONFIRMED_ERROR,
  WAFFLE_CONFIRMED_REQUEST,
  WAFFLE_CONFIRMED_SUCCESS,
  WAFFLE_CONFIRMED_RESET,
} from "./constants";

import instance from "../../../urls";

export const getAllCurrentOrders = (details) => async (dispatch) => {
  try {
    dispatch({
      type: WAFFLE_ORDER_REQUEST,
    });
    const config = {
      headers: {
        "Content-type": "application/json",
      },
    };
    const { data } = await instance.get(
      `orders/orders-by-username/${details}`,
      config
    );

    const now = new Date();

    const currentOrders = data["data"]["orders"].filter((order) => {
      return new Date(order.expiry_datetime) > now;
    });

    dispatch({
      type: WAFFLE_ORDER_SUCCESS,
      payload: currentOrders,
    });
  } catch (error) {
    dispatch({
      type: WAFFLE_ORDER_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: WAFFLE_ORDER_RESET });
    }, 5000);
  }
};

export const getAllPastOrders = (details) => async (dispatch) => {
  try {
    dispatch({
      type: WAFFLE_PAST_ORDER_REQUEST,
    });
    const config = {
      headers: {
        "Content-type": "application/json",
      },
    };
    const { data } = await instance.get(`past_orders/${details}`, config);
    const now = new Date();
    const pastRuns = data["data"]["orders"].filter((order) => {
      return new Date(order.expiry_datetime) > now;
    });
    dispatch({
      type: WAFFLE_PAST_ORDER_SUCCESS,
      payload: pastRuns,
    });
  } catch (error) {
    dispatch({
      type: WAFFLE_PAST_ORDER_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: WAFFLE_PAST_ORDER_RESET });
    }, 5000);
  }
};

export const getAllCurrentRuns = (details) => async (dispatch) => {
  try {
    dispatch({
      type: WAFFLE_RUN_REQUEST,
    });
    const config = {
      headers: {
        "Content-type": "application/json",
      },
    };
    const { data } = await instance.get(
      `orders/runs-by-username/${details}`,
      config
    );

    const now = new Date();

    const currentRuns = data["data"]["orders"].filter((order) => {
      return new Date(order.expiry_datetime) > now;
    });

    dispatch({
      type: WAFFLE_RUN_SUCCESS,
      payload: currentRuns,
    });
  } catch (error) {
    dispatch({
      type: WAFFLE_RUN_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: WAFFLE_RUN_RESET });
    }, 5000);
  }
};

export const getAllPastRuns = (details) => async (dispatch) => {
  try {
    dispatch({
      type: WAFFLE_PAST_RUN_REQUEST,
    });
    const config = {
      headers: {
        "Content-type": "application/json",
      },
    };
    const { data } = await instance.get(`past_runs/${details}`, config);
    const now = new Date();
    const pastRuns = data["data"]["orders"].filter((order) => {
      return new Date(order.expiry_datetime) <= now;
    });
    dispatch({
      type: WAFFLE_PAST_RUN_SUCCESS,
      payload: pastRuns,
    });
  } catch (error) {
    dispatch({
      type: WAFFLE_PAST_RUN_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: WAFFLE_PAST_RUN_RESET });
    }, 5000);
  }
};

export const confirmOrder = (orderId) => async (dispatch) => {
  try {
    dispatch({
      type: WAFFLE_CONFIRMED_REQUEST,
    });

    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    const { token: jwtToken } = userInfo;

    const config = {
      headers: {
        "Content-type": "application/json",
        Authorization: `Bearer ${jwtToken}`,
      },
    };

    const { data } = await instance.patch(
      `complete-order/${orderId}`,
      {},
      config
    );

    dispatch({
      type: WAFFLE_CONFIRMED_SUCCESS,
      payload: data,
    });
    window.setTimeout(() => {
      dispatch({ type: WAFFLE_CONFIRMED_RESET });
    }, 5000);
  } catch (error) {
    dispatch({
      type: WAFFLE_CONFIRMED_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: WAFFLE_CONFIRMED_RESET });
    }, 5000);
  }
};
