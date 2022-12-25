import {
  WAFFLE_PAST_ORDER_REQUEST,
  WAFFLE_PAST_ORDER_SUCCESS,
  WAFFLE_PAST_ORDER_ERROR,
  WAFFLE_PAST_ORDER_RESET
} from "./constants";


export const pastOrderReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case WAFFLE_PAST_ORDER_REQUEST:
      return { pastoloading: true };
    case WAFFLE_PAST_ORDER_SUCCESS:
      return { pastoloading: false, pastWaffleOrder: payload };
    case WAFFLE_PAST_ORDER_ERROR:
      return { pastoloading: false, pastoerror: payload };
    case WAFFLE_PAST_ORDER_RESET:
      return {};

    default:
      return state;
  }
};
