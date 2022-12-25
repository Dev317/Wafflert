import {
  USER_DETAILS_REQUEST,
  USER_DETAILS_SUCCESS,
  USER_DETAILS_ERROR,
  USER_DETAILS_RESET,

} from "./constants";

export const userDetailsReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case USER_DETAILS_REQUEST:
      return { loading: true };
    case USER_DETAILS_SUCCESS:
      return { loading: false, userDetailsInfo: payload };
    case USER_DETAILS_ERROR:
      return { loading: false, error: payload };
    case USER_DETAILS_RESET:
    default:
      return state;
  }
};
