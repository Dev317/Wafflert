import {
  WAFFLE_RUN_REQUEST,
  WAFFLE_RUN_SUCCESS,
  WAFFLE_RUN_ERROR,
  WAFFLE_RUN_RESET
} from "./constants";

export const runReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case WAFFLE_RUN_REQUEST:
      return { runloading: true };
    case WAFFLE_RUN_SUCCESS:
      return { runloading: false, waffleRuns: payload };
    case WAFFLE_RUN_ERROR:
      return { runloading: false, runerror: payload };
    case WAFFLE_RUN_RESET:
      return {};
    default:
      return state;
  }
};
