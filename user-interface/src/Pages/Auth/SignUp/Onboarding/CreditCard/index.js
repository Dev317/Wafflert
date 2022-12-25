import React, { useEffect } from "react";
import { Elements } from "@stripe/react-stripe-js";
import { loadStripe } from "@stripe/stripe-js";
import { useDispatch, useSelector } from "react-redux";
import { getClientSecret } from "../Redux/actions";
import Loading from "../../../../../Common/LoadingAni";
import { Container, Row, Col, Card } from "react-bootstrap";
import SetupForm from "./Component/SetupForm";

export default function CreditCard() {
  const dispatch = useDispatch();

  const setupSecretR = useSelector((state) => state.userOnboardingReducer);
  const { loading, error, clientSecret } = setupSecretR;

  const stripePromise = loadStripe(process.env.REACT_APP_STRIPE_API_KEY);

  useEffect(() => {
    dispatch(getClientSecret);
  }, [dispatch]);

  const options = {
    clientSecret: clientSecret,
  };

  return loading ? (
    <Loading />
  ) : (
    <Container className="h-100 my-5">
      <Row>
        <h1 className="my-5">Save your payment details... </h1>
      </Row>
      <Row>
        <Col xs={2} />
        <Col xs={8} className="d-flex flex-column justify-content-center">
          <Card className="p-4">
            <Elements stripe={stripePromise} options={options}>
              <SetupForm />
            </Elements>
          </Card>
        </Col>
        <Col xs={2} />
      </Row>
    </Container>
  );
}
