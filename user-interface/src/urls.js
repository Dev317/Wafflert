import axios from "axios";

const getBaseURL = () => {
  let url;
  const stage = process.env.REACT_APP_NODE_ENV;

  switch (stage) {
    case "development":
      url = "http://localhost:8080/v1";
      break;
    case "production":
      url = "https://mecowzaii5.execute-api.us-east-2.amazonaws.com/v1";
      break;
    default:
      url = "http://127.0.0.1:8000/";
  }
  console.log(url);

  return url;
};

const instance = axios.create({
  baseURL: getBaseURL(),
  timeout: 10000,
});

export default instance;
