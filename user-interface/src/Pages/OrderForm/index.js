import React, { useEffect, useState } from "react";
import { FormControl, TextField, Button } from "@mui/material";
import "./index.css";
import wafbanner2 from "../../Common/Assets/wafback2.jpg";
import ArrowForward from "@mui/icons-material/ArrowForward";
import "./index.css";
import { useNavigate } from "react-router-dom";
import ArrowBack from "@mui/icons-material/ArrowBack";
import { useDispatch, useSelector } from "react-redux";
import { DateTimePicker } from "@mui/x-date-pickers/DateTimePicker";
import { LocalizationProvider } from "@mui/x-date-pickers/LocalizationProvider/LocalizationProvider";
import { AdapterMoment } from "@mui/x-date-pickers/AdapterMoment";
import moment from "moment";
import { postOrder } from "./Redux/actions";
import { Alert } from "react-bootstrap";
import { CREATE_ORDER_RESET } from "./Redux/constants";
import { TinyPoskitt } from "../../Common/LoadingAni";

function OrderForm() {
  const dispatch = useDispatch();
  const navigate = useNavigate();

  const createOrderR = useSelector((state) => state.createOrderReducer);
  const { loading, error, orderInfo } = createOrderR;

  const [form, setForm] = useState({
    display_info: "",
    flavour: "",
    quantity: "",
    bid_price: "",
    expiry_datetime: moment().toDate(),
  });

  const handleChange = (field, value) => {
    setForm({
      ...form,
      [field]: value,
    });
  };

  useEffect(() => {
    if (!loading && orderInfo) {
      dispatch({
        type: CREATE_ORDER_RESET,
      });
      navigate("/user/orderwaffle");
    }
  }, [dispatch, navigate, loading, orderInfo]);

  const handleOrderSubmit = async (event, values) => {
    event.preventDefault();
    dispatch(postOrder(values));
  };

  return (
    <div>
      <img src={wafbanner2} className="bg" alt="banner background" />
      <Button
        variant="dark"
        className="mt-5"
        onClick={() => {
          navigate("/user/orderwaffle");
        }}
      >
        <ArrowBack className="mx-1" /> back
      </Button>
      <div className="d-flex justify-content-end ">
        {loading && (
          <div className="d-flex justify-content-center align-items-center">
            <TinyPoskitt /> <h3 className="px-2">Loading...</h3> <TinyPoskitt />
          </div>
        )}
        <FormControl className="form-Box">
          <h1 className="mb-5"> I want a waffle!</h1>
          {error && (
            <Alert variant="danger" className="mb-5">
              {error}
            </Alert>
          )}
          <TextField
            className="mb-3"
            id="outlined-basic"
            label="Deliver to..."
            variant="outlined"
            onChange={(event) =>
              handleChange("delivery_info", event.target.value)
            }
          />
          <TextField
            className="mb-3"
            id="outlined-basic"
            label="Flavour"
            variant="outlined"
            onChange={(event) => handleChange("flavour", event.target.value)}
          />
          <TextField
            className="mb-3"
            id="outlined-basic"
            label="Quantity"
            variant="outlined"
            onChange={(event) => handleChange("quantity", event.target.value)}
          />
          <TextField
            className="mb-3"
            id="outlined-basic"
            label="Bid Price"
            variant="outlined"
            onChange={(event) => handleChange("bid_price", event.target.value)}
          />
          <LocalizationProvider dateAdapter={AdapterMoment}>
            <DateTimePicker
              className="mb-3"
              label="Deliver by..."
              value={form["expiry_datetime"]}
              onChange={(event) =>
                handleChange("expiry_datetime", event.toDate())
              }
              renderInput={(params) => <TextField {...params} />}
              minDateTime={moment()}
            />
          </LocalizationProvider>

          <Button
            variant="outlined"
            className="btn-custom"
            color="warning"
            onClick={(e) => handleOrderSubmit(e, form)}
          >
            <ArrowForward className="mx-1" /> Let's Run!
          </Button>
        </FormControl>
      </div>
    </div>
  );
}

export default OrderForm;
