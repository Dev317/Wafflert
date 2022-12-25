import {
  USER_LOGIN_REQUEST,
  USER_LOGIN_SUCCESS,
  USER_LOGIN_ERROR,
  USER_LOGIN_RESET,
  USER_LOGOUT,
} from "./constants";
import { USER_ONBOARDING_STATUS_RESET } from "../../SignUp/Onboarding/Redux/constants";
import instance from "../../../../urls";

export const userLogin = (details) => async (dispatch) => {
  try {
    dispatch({
      type: USER_LOGIN_REQUEST,
    });
    const config = {
      headers: {
        "Content-type": "application/json",
      },
    };
    const { data } = await instance.post("/user/login/", details, config);

    dispatch({
      type: USER_LOGIN_SUCCESS,
      payload: data,
    });

    if (Object.keys(data).length !== 0) {
      localStorage.setItem("userInfo", JSON.stringify(data));
    }
  } catch (error) {
    dispatch({
      type: USER_LOGIN_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: USER_LOGIN_RESET });
    }, 5000);
  }
};

export const userRegister = (details) => async (dispatch) => {
  try {
    dispatch({
      type: USER_LOGIN_REQUEST,
    });
    const config = {
      headers: {
        "Content-type": "application/json",
      },
    };
    const { data } = await instance.post(
      `/user-mgmt/register`,
      details,
      config
    );

    dispatch({
      type: USER_LOGIN_SUCCESS,
      payload: data,
    });

    if (Object.keys(data).length !== 0) {
      localStorage.setItem("userInfo", JSON.stringify(data));
      console.log(localStorage);
    }
  } catch (error) {
    dispatch({
      type: USER_LOGIN_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: USER_LOGIN_RESET });
    }, 5000);
  }
};

export const userLogout = () => (dispatch) => {
  localStorage.clear();
  // localStorage.removeItem("userInfo");
  dispatch({ type: USER_LOGOUT });
  dispatch({ type: USER_ONBOARDING_STATUS_RESET });
};
