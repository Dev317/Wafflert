import {
  ALL_ORDERS_ERROR,
  ALL_ORDERS_REQUEST,
  ALL_ORDERS_RESET,
  ALL_ORDERS_SUCCESS,
} from "./constants";

export const scoreboardReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case ALL_ORDERS_REQUEST:
      return { loading: true };
    case ALL_ORDERS_SUCCESS:
      return { loading: false, orderInfo: payload };
    case ALL_ORDERS_ERROR:
      return { loading: false, error: payload };
    case ALL_ORDERS_RESET:
      return state;
    default:
      return state;
  }
};
