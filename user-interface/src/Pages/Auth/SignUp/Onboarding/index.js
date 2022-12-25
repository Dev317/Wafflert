import React, { useEffect } from "react";
import { Button, Container, Row, Col, Alert } from "react-bootstrap";
import { useDispatch, useSelector } from "react-redux";
import { useNavigate } from "react-router-dom";
import { getOnboardingStatus } from "./Redux/actions";
import DoneIcon from "@mui/icons-material/Done";
import CloseIcon from "@mui/icons-material/Close";
import ArrowForward from "@mui/icons-material/ArrowForward";
import { TinyPoskitt } from "../../../../Common/LoadingAni";
import { green, red } from "@mui/material/colors";

function Onboarding() {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const userOnboardingR = useSelector((state) => state.userOnboardingReducer);
  const { loading, error, onboardingInfo } = userOnboardingR;

  const TELE_URL =
    process.env.REACT_APP_NODE_ENV === "development"
      ? "https://t.me/wafbotdev_bot"
      : "http://t.me/WaF302_bot";

  useEffect(() => {
    dispatch(getOnboardingStatus);
  }, [dispatch]);

  const routeToSetupLink = (event) => {
    event.preventDefault();
    if (onboardingInfo) {
      window.location.href = onboardingInfo.setupLink;
    }
  };

  return (
    <Container className="container">
      {error && (
        <Alert variant="danger">
          Failure to retrieve information, please try again!
        </Alert>
      )}
      <Row className="my-5">
        <h1 className="my-5">Just a few more things to set up... </h1>
      </Row>
      <Row>
        <Col xs={2} />
        <Col xs={8} className="d-flex flex-column justify-content-center">
          {loading && (
            <div className="d-flex justify-content-center align-items-center">
              <TinyPoskitt /> <h3 className="px-2">Loading...</h3>{" "}
              <TinyPoskitt />
            </div>
          )}
          <Button
            variant="light"
            className="p-2 mb-5 onboard-btn "
            onClick={() => navigate("creditcard")}
            disabled={
              (onboardingInfo && onboardingInfo.customerValid) || loading
            }
          >
            <h5>
              {onboardingInfo && onboardingInfo.customerValid ? (
                <DoneIcon sx={{ color: green[500] }} />
              ) : (
                <CloseIcon sx={{ color: red[500] }} />
              )}
              <strong className="px-2">
                Input your credit card information to order waffles!
              </strong>
            </h5>
          </Button>
          <Button
            disabled={
              (onboardingInfo && onboardingInfo.connectedAccountValid) ||
              loading
            }
            onClick={(e) => routeToSetupLink(e)}
            variant="light"
            className="p-2 mb-5 onboard-btn"
          >
            <h5>
              {onboardingInfo && onboardingInfo.connectedAccountValid ? (
                <DoneIcon sx={{ color: green[500] }} />
              ) : (
                <CloseIcon sx={{ color: red[500] }} />
              )}
              <strong className="px-2">
                Input your bank account information to be a runner!
              </strong>
            </h5>
          </Button>
          <Button
            variant="light"
            className="p-2 mb-5 onboard-btn "
            href={TELE_URL}
            target="_blank"
            disabled={
              (onboardingInfo && onboardingInfo.telegramValid) || loading
            }
          >
            <h5>
              {onboardingInfo && onboardingInfo.telegramValid ? (
                <DoneIcon sx={{ color: green[500] }} />
              ) : (
                <CloseIcon sx={{ color: red[500] }} />
              )}
              <strong className="px-2">
                Set up Telegram to receive waffle notifications!
              </strong>
            </h5>
          </Button>
        </Col>
        <Col xs={2} />
      </Row>

      <Row className="my-5">
        <Col xs={2} />
        <Col xs={8} />
        <Col xs={2}>
          {onboardingInfo &&
          onboardingInfo.customerValid &&
          onboardingInfo.telegramValid &&
          onboardingInfo.connectedAccountValid ? (
            <Button
              variant="outline-success"
              onClick={() => navigate("/user/home/")}
            >
              It's waffle time! <ArrowForward className="mx-1" />
            </Button>
          ) : (
            <Button variant="outline-dark" disabled>
              A few more steps...
            </Button>
          )}
        </Col>
      </Row>
    </Container>
  );
}

export default Onboarding;
