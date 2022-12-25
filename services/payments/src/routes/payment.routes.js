const express = require("express");

const router = express.Router();

const controller = require("../controllers/payment.controller");

router.get("/health", (req, res) => {
  res.status(200).send("Payments endpoint healthy");
});

// GET Requests
router.get("/", controller.findAll);
router.get("/:bidId", controller.findById);

// POST Requests
router.post("/", controller.create);

// PATCH Requests
router.patch("/:bidId", controller.patch);

// DELETE Requests
router.delete("/:bidId", controller.deletePayment);

module.exports = router;
