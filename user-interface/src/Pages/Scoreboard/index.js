import React, { useEffect } from "react";
import Scoreboard from "./Components/Scoreboard";
import { Button } from "react-bootstrap";
import { useNavigate } from "react-router-dom";
import ArrowBack from "@mui/icons-material/ArrowBack";
import "./index.css";

function WaffleScoreboard() {
  const navigate = useNavigate();

  return (
    <div>
      <div className="d-flex flex-row gap-2">
        <Button
          variant="outlined"
          className="mt-5 btn-custom"
          onClick={() => {
            navigate("/user/home");
          }}
        >
          <ArrowBack className="mx-1" /> back
        </Button>
      </div>
      <h1 className="mt-5"> WaffLeaderboard </h1>
      <Scoreboard />
    </div>
  );
}

export default WaffleScoreboard;
