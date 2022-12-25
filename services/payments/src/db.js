const dotenv = require("dotenv");

dotenv.config();

const { Sequelize } = require("sequelize");

const host = process.env.HOST;
const username = process.env.USER;
const password = process.env.PASSWORD;
const database = process.env.DB;

const sequelize = new Sequelize(database, username, password, {
  host,
  dialect: "mysql",
  logging: process.env.NODE_ENV === "test" ? false : console.log,
});

module.exports = sequelize;
