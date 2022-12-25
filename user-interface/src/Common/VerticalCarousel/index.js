import React, { useState } from "react";
import "./index.css";
import waffleLogo from "../Assets/waffle.png";
import { useNavigate } from "react-router-dom";
import { Button } from "react-bootstrap";

import topArrow from "../Assets/arrow-up-left-circle.svg";
import bottomArrow from "../Assets/arrow-down-left-circle.svg";

function VerticalCarousel(props) {
  const data = props.data;

  const navigate = useNavigate();

  const [prevClicked, setPrevClicked] = useState(false);
  const [nextClicked, setNextClicked] = useState(false);

  const [current, setCurrent] = useState(0);
  const length = 3;

  const nextSlide = () => {
    setCurrent(current === length - 1 ? 0 : current + 1);
    setNextClicked(true);
    setPrevClicked(false);
  };

  const prevSlide = () => {
    setCurrent(current === 0 ? length - 1 : current - 1);
    setPrevClicked(true);
    setNextClicked(false);
  };

  function isAuthenticated() {
    return false;
  }

  const getClass = (pos) => {
    return nextClicked
      ? `${pos}-movement-next`
      : prevClicked
      ? `${pos}-movement-prev`
      : "";
  };

  return (
    <div className="container">
      <div className="row mt-5">
        <div className="col-sm">
          <img
            className="waffleImg col-sm "
            src={waffleLogo}
            alt="waffle logo"
          />
        </div>
        <div className="col-sm">
          {data &&
            data.map((slides, index) => {
              let next;
              let prev;
              index === length - 1
                ? (next = data[0])
                : (next = data[index + 1]);
              index === 0
                ? (prev = data[length - 1])
                : (prev = data[index - 1]);
              return (
                <div key={index}>
                  {index === current && (
                    <div className="d-flex flex-column alignment">
                      <div className={getClass("top")}>
                        <h4>{next.text}</h4>
                      </div>

                      <Button id="prevBtn" onClick={prevSlide}>
                        <img src={topArrow} alt="top arrow icon" width="40px" />
                      </Button>

                      <button
                        id="centerText"
                        onClick={() =>
                          isAuthenticated
                            ? navigate(slides.link)
                            : navigate("/")
                        }
                      >
                        <div className={getClass("middle")}>
                          <h4>{slides.text}</h4>
                        </div>
                      </button>

                      <Button id="nextBtn" onClick={nextSlide}>
                        <img
                          src={bottomArrow}
                          alt="top arrow icon"
                          width="40px"
                        />
                      </Button>
                      <div className={getClass("bottom")}>
                        <h4>{prev.text}</h4>
                      </div>
                    </div>
                  )}
                </div>
              );
            })}
        </div>
      </div>
    </div>
  );
}

export default VerticalCarousel;
