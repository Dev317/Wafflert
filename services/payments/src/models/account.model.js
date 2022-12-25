const { DataTypes } = require("sequelize");
const sequelize = require("../db");

const Account = sequelize.define("Account", {
  userId: {
    type: DataTypes.STRING,
    allowNull: false,
    primaryKey: true,
  },
  connectedAccountId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  customerId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

module.exports = Account;
