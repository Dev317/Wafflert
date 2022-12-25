import {
  USER_DETAILS_REQUEST,
  USER_DETAILS_SUCCESS,
  USER_DETAILS_ERROR,
  USER_DETAILS_RESET,

} from "./constants";
import axios from "axios";


export const getUserDetails = async (dispatch) => {
  try {
    dispatch({
      type: USER_DETAILS_REQUEST
    });
    const config = {
      headers: {
        "Content-type": "application/json"
      }
    };

    const { data } = await axios.get(`/user/`, config);

    dispatch({
      type: USER_DETAILS_SUCCESS,
      payload: data
    });

  } catch (error) {
    dispatch({
      type: USER_DETAILS_ERROR,
      payload:
        error.response && error.response.data.detail
          ? error.response.data.detail
          : error.message
    });
    window.setTimeout(() => {
      dispatch({ type: USER_DETAILS_RESET });
    }, 5000);
  }
};
