import React from "react";
import wafposkit from "../Assets/wafposkit.png";
import { Image } from "react-bootstrap";
import "./index.css";

function index() {
  return (
    <div className="rotate d-flex flex-row  align-items-center justify-content-center">
      <Image
        className="wafposkit"
        fluid
        size="sm"
        src={wafposkit}
        alt="spinning prof poskit"
      />
      <h2 className="m-4"> Something's cooking.... </h2>
      <Image
        className="wafposkit"
        fluid
        size="sm"
        src={wafposkit}
        alt="spinning prof poskit"
      />
    </div>
  );
}

export const TinyPoskitt = () => {
  return (
    <Image
      className="wafposkit tiny"
      size="sm"
      src={wafposkit}
      alt="smol prof poskitt"
    />
  );
};

export default index;
