import {
  CREATE_ORDER_ERROR,
  CREATE_ORDER_REQUEST,
  CREATE_ORDER_RESET,
  CREATE_ORDER_SUCCESS,
} from "./constants";
import instance from "../../../urls";

export const postOrder = (details) => async (dispatch) => {
  try {
    dispatch({
      type: CREATE_ORDER_REQUEST,
    });

    const userInfo = JSON.parse(localStorage.getItem("userInfo"));
    const {
      token: jwtToken,
      id: user_id,
      telegram_username: username,
    } = userInfo;

    const config = {
      headers: {
        "Content-type": "application/json",
        Authorization: `Bearer ${jwtToken}`,
      },
    };

    const { data } = await instance.post(
      `/place-order`,
      { ...details, user_id: user_id, username: username },
      config
    );

    dispatch({
      type: CREATE_ORDER_SUCCESS,
      payload: data,
    });
  } catch (error) {
    dispatch({
      type: CREATE_ORDER_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message,
    });
    window.setTimeout(() => {
      dispatch({ type: CREATE_ORDER_RESET });
    }, 10000);
  }
};
