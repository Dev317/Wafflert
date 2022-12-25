import {
  USER_ONBOARDING_STATUS_ERROR,
  USER_ONBOARDING_STATUS_REQUEST,
  USER_ONBOARDING_STATUS_SUCCESS,
  USER_ONBOARDING_STATUS_RESET,
  CLIENT_SECRET_RESET,
  CLIENT_SECRET_REQUEST,
  CLIENT_SECRET_ERROR,
  CLIENT_SECRET_SUCCESS,
} from "./constants";
import instance from "../../../../../urls";

export const getOnboardingStatus = async (dispatch) => {
  try {
    dispatch({
      type: USER_ONBOARDING_STATUS_REQUEST,
    });

    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    const jwtToken = userInfo["token"];
    const userId = userInfo["id"];

    const config = {
      headers: {
        "Content-type": "application/json",
        Authorization: `Bearer ${jwtToken}`,
      },
    };

    const { data } = await instance.get(
      `/user-mgmt/onboarding-status/${userId}`,
      config
    );

    let setupLink = "";

    if (!data.connectedAccountValid) {
      const { data } = await instance.get(
        `/payments/accounts/setup-link/${userId}`,
        config
      );

      setupLink = data.accountLink;
    }

    dispatch({
      type: USER_ONBOARDING_STATUS_SUCCESS,
      payload: { ...data, setupLink },
    });
  } catch (error) {
    console.log(error);
    dispatch({
      type: USER_ONBOARDING_STATUS_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: USER_ONBOARDING_STATUS_RESET });
    }, 7500);
  }
};

export const getClientSecret = async (dispatch) => {
  try {
    dispatch({
      type: CLIENT_SECRET_REQUEST,
    });

    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    const jwtToken = userInfo["token"];
    const userId = userInfo["id"];

    const config = {
      headers: {
        "Content-type": "application/json",
        Authorization: `Bearer ${jwtToken}`,
      },
    };

    const { data } = await instance.get(
      `/payments/accounts/setup-secret/${userId}`,
      config
    );

    dispatch({
      type: CLIENT_SECRET_SUCCESS,
      payload: data.clientSecret,
    });
  } catch (error) {
    console.log(error);
    dispatch({
      type: CLIENT_SECRET_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: CLIENT_SECRET_RESET });
    }, 5000);
  }
};
