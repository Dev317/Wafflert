import {
  CREATE_ORDER_ERROR,
  CREATE_ORDER_REQUEST,
  CREATE_ORDER_RESET,
  CREATE_ORDER_SUCCESS,
} from "./constants";

export const createOrderReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case CREATE_ORDER_REQUEST:
      return { loading: true };
    case CREATE_ORDER_SUCCESS:
      return { loading: false, orderInfo: payload };
    case CREATE_ORDER_ERROR:
      return { loading: false, error: payload };
    case CREATE_ORDER_RESET:
      return { loading: false };
    default:
      return state;
  }
};
