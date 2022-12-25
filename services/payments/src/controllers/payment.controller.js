const dotenv = require("dotenv");

dotenv.config();

const stripe = require("stripe")(process.env.STRIPE_API_KEY);
const cron = require("node-cron");
const sequelize = require("../db");
const Payment = require("../models/payment.model");
const Account = require("../models/account.model");

// ----------------------------------
// GET Methods
// ----------------------------------
const findAll = (req, res) => {
  Payment.findAll()
    .then((data) => {
      res.send(data);
    })
    .catch((err) => {
      res.status(500).send({
        message:
          err.message
          || "Some error occurred while retrieving payment records.",
      });
    });
};

const findById = (req, res) => {
  Payment.findByPk(req.params.bidId)
    .then((data) => {
      if (data) res.status(200).send(data);
      else {
        res.status(404).send({
          message: "No payment record associated with that bid ID.",
        });
      }
    })
    .catch((err) => {
      res.status(500).send({
        message:
          err.message
          || "Some error occurred while retrieving payment records.",
      });
    });
};

// ----------------------------------
// POST Methods
// ----------------------------------
const create = async (req, res) => {
  const stripeBuyerInfo = await Account.findByPk(req.body.buyerId);
  const stripeRunnerInfo = await Account.findByPk(req.body.runnerId);
  try {
    const result = await sequelize.transaction(async (t) => {
      const paymentMethods = await stripe.customers.listPaymentMethods(
        stripeBuyerInfo.customerId,
        { type: "card" },
      );

      if (paymentMethods.data.length < 1) {
        throw new Error({
          type: "NoPaymentMethod",
          message: "This account has no payment methods.",
        });
      }

      const session = await stripe.paymentIntents.create({
        amount: req.body.amountPaid * 100,
        currency: "sgd",
        confirm: true,
        customer: stripeBuyerInfo.customerId,
        payment_method_types: ["card"],
        payment_method: paymentMethods.data[0].id,
        transfer_data: {
          destination: stripeRunnerInfo.connectedAccountId,
        },
        metadata: {
          bidId: req.body.bidId,
        },
      });

      // console.log(session);

      const paymentIntentId = session.id;

      const payment = Payment.create(
        {
          bidId: req.body.bidId,
          paymentIntentId,
          buyerId: req.body.buyerId,
          runnerId: req.body.runnerId,
          amountPaid: req.body.amountPaid,
          status: "ONGOING",
        },
        { transaction: t },
      );

      return payment;
    });

    res.status(201).json(result);
  } catch (err) {
    // console.log(err);
    res.status(500).send({
      message:
        err.message || "Some error occurred while creating payment record.",
    });
  }
};

// ----------------------------------
// PATCH Methods
// ----------------------------------
const patch = async (req, res) => {
  const payment = await Payment.findByPk(req.params.bidId);

  if (!payment) {
    res.status(404).send({
      message: "No payment record associated with that bid ID.",
    });
    return;
  }

  if (payment.status !== "ONGOING") {
    res.status(405).set("Allow", "GET").send({
      message: "Cannot change the status of a cancelled or completed payment.",
    });
    return;
  }

  if (req.body.status === "COMPLETED") {
    try {
      const result = await sequelize.transaction(async (t) => {
        // do stripe payout
        // const payout = await stripe.payouts.create({
        //   amount: 24784,
        //   currency: 'sgd',
        //   source_type: 'bank_account',
        // });

        // update the payment object's status
        const response = await Payment.update(
          { status: "COMPLETED" },
          { where: { bidId: payment.bidId } },
          { transaction: t },
        );

        return response;
      });

      // send OK
      res.status(200).json(result);
    } catch (err) {
      res.status(500).send({
        message:
          err.message || "Some error occurred while updating payment record.",
      });
    }
  } else if (req.body.status === "CANCELLED") {
    try {
      await sequelize.transaction(async (t) => {
        // do stripe refund
        await stripe.refunds.create({
          payment_intent: payment.dataValues.paymentIntentId,
          reverse_transfer: true,
        });

        // update the payment object's status
        const response = await Payment.update(
          { status: "CANCELLED" },
          { where: { bidId: payment.bidId } },
          { transaction: t },
        );

        return response;
      });

      const paymentUpdated = await Payment.findByPk(req.params.bidId);

      // send OK
      res.status(200).send(paymentUpdated);
    } catch (err) {
      res.status(500).send({
        message:
          err.message || "Some error occurred while updating payment record.",
      });
    }
  } else {
    res.status(400).send({
      message: "Invalid status; can only be 'COMPLETED' or 'CANCELLED'.",
    });
  }
};

// ----------------------------------
// DELETE Methods
// ----------------------------------
const deletePayment = async (req, res) => {
  const payment = await Payment.findByPk(req.params.bidId);

  if (!payment) {
    res.status(404).send({
      message: "No payment record associated with that bid ID.",
    });
    return;
  }

  if (payment.status === "COMPLETED") {
    res.status(405).set("Allow", "GET").send({
      message: "Cannot delete a historically completed payment.",
    });
    return;
  }

  try {
    await sequelize.transaction(async (t) => {
      const response = await payment.destroy({ transaction: t });
      return response;
    });

    // send OK
    res.status(200).send({
      message: `Payment record ${payment.bidId} successfully deleted.`,
    });
  } catch (err) {
    res.status(500).send({
      message:
        err.message || "Some error occurred while deleting payment record.",
    });
  }
};

// ----------------------------------
// Scheduled Methods
// ----------------------------------

if (process.env.NODE_ENV !== "test") {
  cron.schedule("0 0 * * *", async () => {
    try {
      await sequelize.transaction(async (t) => {
        const response = await Payment.update(
          { status: "COMPLETED" },
          { where: { status: "ONGOING" } },
          { transaction: t },
        );

        return response;
      });
      const completed = new Date();
      console.log(
        `${completed.getHours()}.${completed.getMinutes()}: Successfully completed all payments at the end of day.`,
      );
    } catch (err) {
      console.error(
        err.message
          || "Something went wrong with completing all payments at the end of day.",
      );
    }
  });
}

module.exports = {
  findAll,
  findById,
  create,
  patch,
  deletePayment,
};
