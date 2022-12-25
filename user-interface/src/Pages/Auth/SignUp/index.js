import React from "react";
import { Formik } from "formik";
import { Form, Button, Container, Row, Col, Alert } from "react-bootstrap";
import * as yup from "yup";
import { Link, useNavigate } from "react-router-dom";
import "./index.css";
import { TextField } from "@mui/material";

import { userRegister } from "../Login/Redux/actions";
import { useDispatch, useSelector } from "react-redux";
import background from "../../../Common/Assets/tripplets.jpg";
import { isValidJwt } from "../ProtectedRoutes/index";

const INTIALVALUES = {
  email: "",
  password: ""
};

const SCHEMA = yup.object().shape({
  email: yup.string().required("Email Required"),
  password: yup.string().required("Password Required")
});


const delay = ms => new Promise(res => setTimeout(res, ms));

const SignUp = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const userLoginR = useSelector(state => state.userLoginReducer);
  const { error  } = userLoginR;

  const userOnboard = useSelector(state => state.userOnboardingReducer);
  const {onboardingInfo } = userOnboard;

  const handleStudentLogin = async values => {
    dispatch(userRegister(values));
    await delay(3000);
    let jwtValid = isValidJwt();
    if (jwtValid) {
      if (onboardingInfo){
        if ( !onboardingInfo.connectedAccountValid || 
          !onboardingInfo.customerValid ||
          !onboardingInfo.telegramValid ){
          navigate("/user/onboarding");
      } else {
      navigate("/user/home/");
      }
    } else {
      navigate("/");
    }
  }
  };

  return (
    <Container>
      <img className="backgroundPos" src={background} alt="backgroundimg " />
      <Row>
        <Col />
        <Col>
          {error &&
            <Alert variant="danger">
              This email or password already exists!
            </Alert>}
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
              errors
            }) =>
              <Form onSubmit={handleSubmit} noValidate className=" signup-Box ">
                <h1 className="mb-3">SIGN UP </h1>
                <Form.Group className="mb-4" controlId="email">
                  <TextField
                    fullWidth
                    controlid="email"
                    id="outlined-basic"
                    label="Email"
                    variant="outlined"
                    type="text"
                    name="email"
                    placeholder="email"
                    value={values.email}
                    onChange={handleChange}
                    isInvalid={!!errors.email}
                    isvalid={touched.email && !errors.email}
                    feedback={errors.email}
                  />

                  {errors.email &&
                    <Form.Control.Feedback type="invalid">
                      {errors.email}
                    </Form.Control.Feedback>}
                  <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
                </Form.Group>

                <Form.Group className="mb-2" controlId="password">
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
                    isInvalid={!!errors.password}
                    isvalid={touched.password && !errors.password}
                    feedback={errors.password}
                  />
                  {errors.password &&
                    <Form.Control.Feedback type="invalid">
                      {errors.password}
                    </Form.Control.Feedback>}
                  <Form.Control.Feedback>Looks good!</Form.Control.Feedback>
                </Form.Group>

                <div className="d-flex justify-content-between mb-5">
                  <Link to="/" className="text-start text-muted">
                    Already have an account?
                  </Link>
                </div>

                <div className="d-grid gap-2 justify-content-center">
                  <Button
                    type="submit"
                    className="my-2 login-btn"
                    text="Login"
                    variant="dark"
                  >
                    Create new account
                  </Button>
                </div>
              </Form>}
          </Formik>{" "}
        </Col>
      </Row>
    </Container>
  );
};

export default SignUp;
