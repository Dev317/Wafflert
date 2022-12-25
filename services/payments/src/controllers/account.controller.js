const dotenv = require("dotenv");

dotenv.config();

const stripe = require("stripe")(process.env.STRIPE_API_KEY);
const sequelize = require("../db");
const Account = require("../models/account.model");

// ----------------------------------
// GET Methods
// ----------------------------------
const findAll = (req, res) => {
  Account.findAll()
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
  Account.findByPk(req.params.userId)
    .then((data) => {
      if (data) res.status(200).send(data);
      else {
        res.status(404).send({
          message: "No payment account with that ID.",
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

const stripeAccountLink = async (req, res) => {
  try {
    const account = await Account.findByPk(req.params.userId);

    if (!account) {
      res.status(404).send({
        message: "No account associated with that ID.",
      });
      return;
    }

    const refreshUrl = process.env.STRIPE_ACCOUNT_LINK_REFRESH
      || "http://localhost:3000/user/onboarding/";
    const returnUrl = process.env.STRIPE_ACCOUNT_LINK_RETURN
      || "http://localhost:3000/user/onboarding/";

    const accountLink = await stripe.accountLinks.create({
      account: account.connectedAccountId,
      refresh_url: refreshUrl,
      return_url: returnUrl,
      type: "account_onboarding",
    });

    res.status(200).json({ accountLink: accountLink.url });
  } catch (err) {
    // Return HTTP 500
    res.status(500).send({
      message:
        err.message
        || "Some error occurred while retrieving account link to set up receive payment.",
    });
  }
};

const stripeSetupSecret = async (req, res) => {
  const account = await Account.findByPk(req.params.userId);

  const setupIntent = await stripe.setupIntents.create({
    customer: account.customerId,
    payment_method_types: ["card"],
  });

  res.status(200).json({ clientSecret: setupIntent.client_secret });
};

const checkPaymentMethods = async (req, res) => {
  try {
    const account = await Account.findByPk(req.params.userId);

    if (!account) {
      res.status(404).send({
        type: "UserInvalid",
        message: "No account associated with that ID.",
      });
      return;
    }

    const paymentMethods = await stripe.customers.listPaymentMethods(
      account.customerId,
      { type: "card" },
    );

    if (paymentMethods.data.length < 1) {
      res.status(404).send({
        type: "NoPaymentMethod",
        message: "This account has no payment methods.",
      });
    } else res.status(200).send(paymentMethods.data);
  } catch (err) {
    console.log(err.message);
    res.status(500).send({
      message:
        err.message || "Some error occurred while retrieving payment methods.",
    });
  }
};

const checkAccountVerified = async (req, res) => {
  try {
    const account = await Account.findByPk(req.params.userId);

    if (!account) {
      res.status(404).send({
        type: "UserInvalid",
        message: "No account associated with that ID.",
      });
      return;
    }

    const connectedAccount = await stripe.accounts.retrieve(
      account.connectedAccountId,
    );

    res.status(200).json({
      connectedAccountVerified: connectedAccount.payouts_enabled,
    });
  } catch (err) {
    console.log(err.message);
    res.status(500).send({
      message:
        err.message
        || "Some error occurred while retrieving Stripe connected account.",
    });
  }
};

// ----------------------------------
// POST Methods
// ----------------------------------
const create = async (req, res) => {
  try {
    const result = await sequelize.transaction(async (t) => {
      const stripeAccount = await stripe.accounts.create({
        country: "SG",
        type: "express",
        email: req.body.email,
        capabilities: {
          card_payments: { requested: true },
          transfers: { requested: true },
        },
        business_type: "individual",
        business_profile: {
          mcc: 5811,
          url: "https://jenpoer.github.io/",
        },
        metadata: {
          userId: req.body.userId,
        },
      });

      const customer = await stripe.customers.create({
        email: req.body.email,
        metadata: {
          userId: req.body.userId,
        },
      });

      const response = Account.create(
        {
          userId: req.body.userId,
          connectedAccountId: stripeAccount.id,
          customerId: customer.id,
        },
        { transaction: t },
      );

      return response;
    });

    res.status(201).json({ ...result.dataValues });
  } catch (err) {
    // Saga Pattern the stripe accounts by checking if they had been created

    // Return HTTP 500
    res.status(500).send({
      message:
        err.message
        || "Some error occurred while creating user's payment account.",
    });
  }
};

module.exports = {
  findAll,
  findById,
  stripeAccountLink,
  stripeSetupSecret,
  checkPaymentMethods,
  checkAccountVerified,
  create,
};
