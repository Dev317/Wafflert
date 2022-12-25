import React, { useEffect } from "react";
import { Formik } from "formik";
import { Form, Button, Container, Row, Col, Alert } from "react-bootstrap";
import * as yup from "yup";
import { Link, useNavigate } from "react-router-dom";
import "./index.css";

import { userLogin } from "./Redux/actions";
import { getOnboardingStatus } from "../SignUp/Onboarding/Redux/actions";
import { useDispatch, useSelector } from "react-redux";
import background from "../../../Common/Assets/tripplets.jpg";
import { TinyPoskitt } from "../../../Common/LoadingAni";

import { isValidJwt } from "../ProtectedRoutes/index";
import { TextField } from "@mui/material";

const INTIALVALUES = {
  username: "",
  password: "",
};

const SCHEMA = yup.object().shape({
  username: yup.string().required("Email Required"),
  password: yup.string().required("Password Required"),
});

const Login = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const userLoginR = useSelector((state) => state.userLoginReducer);
  const userOnboardingR = useSelector((state) => state.userOnboardingReducer);
  const { loading, error } = userLoginR;
  const {
    error: errorOnboarding,
    onboardingInfo,
    loading: loadingOnboard,
  } = userOnboardingR;

  useEffect(() => {
    let jwtValid = isValidJwt();
    if (jwtValid) {
      if (!loadingOnboard && onboardingInfo) {
        if (
          onboardingInfo.connectedAccountValid &&
          onboardingInfo.customerValid &&
          onboardingInfo.telegramValid
        ) {
          navigate("/user/home/");
        } else {
          navigate("/user/onboarding");
        }
      }
    } else {
      navigate("/");
    }
  }, [navigate, userLoginR, onboardingInfo, loadingOnboard, dispatch]);

  const handleStudentLogin = async (values) => {
    dispatch(userLogin(values));
    window.setTimeout(() => {
      if (!error && isValidJwt()) {
        dispatch(getOnboardingStatus);
      }
    }, 2000);
  };

  return (
    <Container>
      <img className="backgroundPos" src={background} alt="backgroundimg " />
      <Row>
        <Col />
        <Col>
          {error && (
            <Alert variant="danger">
              Incorrect email or password, please try again!
            </Alert>
          )}
          {errorOnboarding && (
            <Alert variant="danger">
              Failure to retrieve information, please try again!
            </Alert>
          )}
          <Formik
            initialValues={INTIALVALUES}
            onSubmit={handleStudentLogin}
            validationSchema={SCHEMA}
          >
            {({
              isSubmitting,
              handleSubmit,
              handleChange,
              values,
              touched,
              errors,
            }) => (
              <Form onSubmit={handleSubmit} noValidate className=" loginBox">
                <h1 className="mb-3"> LOGIN </h1>
                <TextField
                  fullWidth
                  className="mb-4"
                  controlid="username"
                  id="outlined-basic"
                  label="Email"
                  variant="outlined"
                  type="text"
                  name="username"
                  placeholder="username"
                  value={values.username}
                  onChange={handleChange}
                  isinvalid={(!!errors.username).toString()}
                  isvalid={
                    touched.username && !errors.username ? "true" : "false"
                  }
                  feedback={errors.username}
                />
                {errors.username && (
                  <Form.Control.Feedback type="invalid">
                    {errors.username}
                  </Form.Control.Feedback>
                )}

                <TextField
                  fullWidth
                  className="mb-2"
                  controlid="password"
                  id="outlined-basic"
                  label="Password"
                  variant="outlined"
                  type="password"
                  name="password"
                  placeholder="Password"
                  value={values.password}
                  onChange={handleChange}
                  isinvalid={(!!errors.password).toString()}
                  isvalid={
                    touched.password && !errors.password ? "true" : "false"
                  }
                  feedback={errors.password}
                />
                {errors.password ? (
                  <Form.Control.Feedback type="invalid">
                    {errors.password}
                  </Form.Control.Feedback>
                ) : (
                  <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
                )}

                <div className="d-flex justify-content-between mb-5">
                  <Link to="/signup" className="text-start text-muted">
                    Create an account!
                  </Link>
                  <Link to="/forget" className="text-end text-muted">
                    Forget password?
                  </Link>
                </div>

                <div className="d-grid gap-2 justify-content-center">
                  <Button
                    type="submit"
                    className="my-2 login-btn"
                    text="Login"
                    variant="dark"
                  >
                    Login
                  </Button>
                </div>
                {(loading || loadingOnboard) && (
                  <div className="d-flex justify-content-center align-items-center">
                    <TinyPoskitt />{" "}
                    <h3 className="px-2">Something's cooking...</h3>{" "}
                    <TinyPoskitt />
                  </div>
                )}

                <small className="text-center text-wrap">
                  By engaging in our services, you have fully agreed to our
                  Terms of Service and have given written consent to our Data
                  Notice.
                </small>
              </Form>
            )}
          </Formik>{" "}
        </Col>
      </Row>
    </Container>
  );
};

export default Login;
