import {
  USER_LOGIN_REQUEST,
  USER_LOGIN_SUCCESS,
  USER_LOGIN_ERROR,
  USER_LOGIN_RESET,
  USER_LOGOUT,
} from "./constants";

export const userLoginReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case USER_LOGIN_REQUEST:
      return { loading: true };
    case USER_LOGIN_SUCCESS:
      return { loading: false, userInfo: payload };
    case USER_LOGIN_ERROR:
      return { loading: false, error: payload };
    case USER_LOGIN_RESET:
    case USER_LOGOUT:
      return {};
    default:
      return state;
  }
};
