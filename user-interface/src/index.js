import React, { Suspense, lazy } from "react";
import ReactDOM from "react-dom/client";
import { Container } from "react-bootstrap";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import "./index.css";
import "bootstrap/dist/css/bootstrap.min.css";
import { ParallaxProvider } from "react-scroll-parallax";
import { Provider } from "react-redux";
import store from "./RootRedux/index";

import ScrollToTop from "./Common/ScrollToTop";

import ProtectedRoutes from "./Pages/Auth/ProtectedRoutes";

const LoginPage = lazy(() => import("./Pages/Auth/Login"));
const SignUpPage = lazy(() => import("./Pages/Auth/SignUp"));

const LandingPage = lazy(() => import("./Pages/LandingPage"));
const Onboarding = lazy(() => import("./Pages/Auth/SignUp/Onboarding"));
const CreditCard = lazy(() =>
  import("./Pages/Auth/SignUp/Onboarding/CreditCard")
);

const Scoreboard = lazy(() => import("./Pages/Scoreboard"));
const WaffleRunNOrders = lazy(() => import("./Pages/WaffleRun&Orders"));
const OrderPage = lazy(() => import("./Pages/Order"));
const OrderForm = lazy(() => import("./Pages/OrderForm"));

const root = ReactDOM.createRoot(document.getElementById("root"));
root.render(
  <Provider store={store}>
    <ParallaxProvider>
      <Router>
        <ScrollToTop />
        <Suspense fallback={<div />}>
          <Container>
            <Routes>
              {/* landing */}

              <Route path="/" element={<LoginPage />} />
              <Route path="signup" element={<SignUpPage />} />

              <Route path="user" element={<ProtectedRoutes />}>
                <Route path="home" element={<LandingPage />} />
                <Route path="onboarding" element={<ProtectedRoutes />}>
                  <Route path="" element={<Onboarding />} />
                  <Route path="creditcard" element={<CreditCard />} />
                </Route>
                <Route path="wafflescoreboard" element={<Scoreboard />} />
                <Route path="wafflerunnorders" element={<WaffleRunNOrders />} />

                <Route path="orderwaffle" element={<OrderPage />} />
                <Route path="orderwaffleform" element={<OrderForm />} />
              </Route>
            </Routes>
          </Container>
        </Suspense>
      </Router>
    </ParallaxProvider>
  </Provider>
);
