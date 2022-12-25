import {
  WAFFLE_PAST_RUN_REQUEST,
  WAFFLE_PAST_RUN_SUCCESS,
  WAFFLE_PAST_RUN_ERROR,
  WAFFLE_PAST_RUN_RESET
} from "./constants";

export const pastRunReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case WAFFLE_PAST_RUN_REQUEST:
      return { pastrloading: true };
    case WAFFLE_PAST_RUN_SUCCESS:
      return { pastrloading: false, pastwaffleRun: payload };
    case WAFFLE_PAST_RUN_ERROR:
      return { pastrloading: false, pastrerror: payload };
    case WAFFLE_PAST_RUN_RESET:
      return {};

    default:
      return state;
  }
};
