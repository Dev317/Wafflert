import {
  WAFFLE_ORDER_REQUEST,
  WAFFLE_ORDER_SUCCESS,
  WAFFLE_ORDER_ERROR,
  WAFFLE_ORDER_RESET
} from "./constants";

export const currentOrdersReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case WAFFLE_ORDER_REQUEST:
      return { orderloading: true };
    case WAFFLE_ORDER_SUCCESS:
      return { orderloading: false, waffleOrder: payload };
    case WAFFLE_ORDER_ERROR:
      return { orderloading: false, ordererror: payload };
    case WAFFLE_ORDER_RESET:
      return {};

    default:
      return state;
  }
};
