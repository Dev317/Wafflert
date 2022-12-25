import React from "react";
import VerticalCarousel from "../../Common/VerticalCarousel";
import { Button } from "@mui/material";
import { useNavigate } from "react-router-dom";
import { useDispatch } from "react-redux";
import ArrowBack from "@mui/icons-material/ArrowBack";
import { userLogout } from "../Auth/Login/Redux/actions";

function LandingPage() {
  const navigate = useNavigate();
  const dispatch = useDispatch();
  const data = [
    {
      id: 0,
      text: "Waffle Market",
      link: "/user/orderwaffle",
    },
    {
      id: 1,
      text: "WaffLeaderboard",
      link: "/user/wafflescoreboard", // all completed orders
    },
    {
      id: 2,
      text: "My Waffle Orders & Runs",
      link: "/user/wafflerunnorders",
    },
  ];

  return (
    <>
      <Button
        variant="dark"
        className="mt-5"
        onClick={() => {
          dispatch(userLogout());
          navigate("/");
        }}
      >
        <ArrowBack className="mx-1" /> logout
      </Button>
      <VerticalCarousel data={data} />
    </>
  );
}

export default LandingPage;
