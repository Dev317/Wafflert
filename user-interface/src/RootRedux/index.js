import thunk from "redux-thunk";
import reducers from "./Reducers";
import { configureStore } from "@reduxjs/toolkit";

const middleware = [thunk];

const userSessionFromStorage = localStorage.getItem("UserInfo")
  ? JSON.parse(localStorage.getItem("userInfo"))
  : null;

const preloadedState = {
  userLoginReducer: { userInfo: userSessionFromStorage },
};

const store = configureStore({
  reducer: reducers,
  middleware,
  preloadedState,
});

export default store;
