const dotenv = require("dotenv");

dotenv.config();
const express = require("express");
const cors = require("cors");

const app = express();

const STAGE = process.env.NODE_ENV;

// ----------------------------------
// Database Connection
// ----------------------------------
const sequelize = require("./db");

if (STAGE !== "test") {
  sequelize
    .authenticate()
    .then(() => {
      console.log("Connection to database has been established");
    })
    .catch((err) => {
      console.error(err.message || "Unable to connect to the database");
    });

  sequelize
    .sync()
    .then(() => {
      console.log("Synced DB.");
    })
    .catch((err) => {
      console.error(err.message || "Failed to sync DB.");
    });
}

// ----------------------------------
// Middleware
// ----------------------------------

// Enable CORS
app.use(cors());

// Only accept JSON Content-Type
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ----------------------------------
// Routes
// ----------------------------------
const routes = require("./routes");

app.use("/payments/accounts", routes.account);
app.use("/payments", routes.payment);

app.use("/health", (req, res) => {
  res.send("Server is healthy");
});

// ----------------------------------
// Start the server
// ----------------------------------
const PORT = process.env.PORT || 3001;

const server = app.listen(PORT, () => {
  console.log(`Server is listening at port ${PORT}`);
});

module.exports = server;
