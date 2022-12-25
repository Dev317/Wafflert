import { combineReducers } from "redux";

import * as userLoginReducer from "../../Pages/Auth/Login/Redux/reducers";
import * as orderReducer from "../../Pages/Order/Redux/reducers";
import * as userOnboardingReducer from "../../Pages/Auth/SignUp/Onboarding/Redux/reducers";
import * as createOrderReducer from "../../Pages/OrderForm/Redux/reducers";
import * as scoreboardReducer from "../../Pages/Scoreboard/Redux/reducers";

import * as currentOrdersReducer from "../../Pages/WaffleRun&Orders/Redux/currentOrdersReducer";
import * as pastOrderReducer from "../../Pages/WaffleRun&Orders/Redux/pastOrderReducer";
import * as pastRunReducer from "../../Pages/WaffleRun&Orders/Redux/pastRunReducer";
import * as runReducer from "../../Pages/WaffleRun&Orders/Redux/runReducer";
import * as confirmOrderReducer from "../../Pages/WaffleRun&Orders/Redux/confirmOrderReducer";

const reducers = combineReducers({
  ...userLoginReducer,
  ...orderReducer,
  ...userOnboardingReducer,
  ...createOrderReducer,
  ...scoreboardReducer,
  ...currentOrdersReducer,
  ...pastOrderReducer,
  ...pastRunReducer,
  ...runReducer,
  ...confirmOrderReducer,
});

export default reducers;
