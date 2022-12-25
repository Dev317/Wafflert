import {
  USER_ORDER_REQUEST,
  USER_ORDER_SUCCESS,
  USER_ORDER_ERROR,
  USER_ORDER_RESET,
  RUNNER_ACCEPT_ERROR,
  RUNNER_ACCEPT_REQUEST,
  RUNNER_ACCEPT_SUCCESS,
  RUNNER_ACCEPT_RESET,
} from "./constants";

export const ordersReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case USER_ORDER_REQUEST:
      return { loading: true };
    case USER_ORDER_SUCCESS:
      return { loading: false, orderInfo: payload };
    case USER_ORDER_ERROR:
      return { loading: false, error: payload };
    case USER_ORDER_RESET:
      return state;
    case RUNNER_ACCEPT_REQUEST:
      return { loading: true };
    case RUNNER_ACCEPT_SUCCESS:
      return { loading: false, acceptedOrder: payload };
    case RUNNER_ACCEPT_ERROR:
      return { loading: false, error: payload };
    case RUNNER_ACCEPT_RESET:
      return state;
    default:
      return state;
  }
};
