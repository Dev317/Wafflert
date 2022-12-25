const { DataTypes } = require("sequelize");
const sequelize = require("../db");

const Payment = sequelize.define("Payment", {
  bidId: {
    type: DataTypes.STRING,
    allowNull: false,
    primaryKey: true,
  },
  paymentIntentId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  buyerId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  runnerId: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  amountPaid: {
    type: DataTypes.DOUBLE,
    allowNull: false,
  },
  status: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  transferred: {
    type: DataTypes.DATE,
    allowNull: true,
  },
});

module.exports = Payment;
