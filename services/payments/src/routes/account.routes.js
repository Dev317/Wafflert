const express = require("express");

const router = express.Router();

const controller = require("../controllers/account.controller");

router.get("/health", (req, res) => {
  res.status(200).send("Accounts endpoint healthy");
});

// GET Requests
router.get("/", controller.findAll);
router.get("/:userId", controller.findById);
router.get("/setup-link/:userId", controller.stripeAccountLink);
router.get("/setup-secret/:userId", controller.stripeSetupSecret);
router.get("/payment-methods/:userId", controller.checkPaymentMethods);
router.get(
  "/connected-account-verified/:userId",
  controller.checkAccountVerified,
);

// POST Requests
router.post("/", controller.create);

module.exports = router;
