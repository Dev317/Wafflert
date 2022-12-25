import {
  USER_ONBOARDING_STATUS_ERROR,
  USER_ONBOARDING_STATUS_REQUEST,
  USER_ONBOARDING_STATUS_SUCCESS,
  USER_ONBOARDING_STATUS_RESET,
  CLIENT_SECRET_ERROR,
  CLIENT_SECRET_REQUEST,
  CLIENT_SECRET_SUCCESS,
  CLIENT_SECRET_RESET,
} from "./constants";

export const userOnboardingReducer = (state = {}, action) => {
  const { type, payload } = action;
  switch (type) {
    case USER_ONBOARDING_STATUS_REQUEST:
      return { loading: true };
    case USER_ONBOARDING_STATUS_SUCCESS:
      return { loading: false, onboardingInfo: payload };
    case USER_ONBOARDING_STATUS_ERROR:
      return { loading: false, error: payload };
    case USER_ONBOARDING_STATUS_RESET:
      return { loading: false };
    case CLIENT_SECRET_REQUEST:
      return { loading: true };
    case CLIENT_SECRET_ERROR:
      return { loading: false, error: payload };
    case CLIENT_SECRET_SUCCESS:
      return { loading: false, clientSecret: payload };
    case CLIENT_SECRET_RESET:
      return state;
    default:
      return state;
  }
};
