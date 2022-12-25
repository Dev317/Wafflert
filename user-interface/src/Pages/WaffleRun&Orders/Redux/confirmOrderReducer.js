import {
  WAFFLE_CONFIRMED_ERROR,
  WAFFLE_CONFIRMED_REQUEST,
  WAFFLE_CONFIRMED_RESET,
  WAFFLE_CONFIRMED_SUCCESS,
} from "./constants";

export const confirmOrderReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case WAFFLE_CONFIRMED_REQUEST:
      return { loading: true };
    case WAFFLE_CONFIRMED_SUCCESS:
      return { loading: false, message: payload };
    case WAFFLE_CONFIRMED_ERROR:
      return { loading: false, error: payload };
    case WAFFLE_CONFIRMED_RESET:
      return { loading: false };
    default:
      return state;
  }
};
