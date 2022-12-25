process.env.NODE_ENV = "test";

const app = require("../src");
const supertest = require("supertest");
const request = supertest(app);
const sequelize = require("../src/db");

const Payment = require("../src/models/payment.model");
const Account = require("../src/models/account.model");

jest.mock("stripe", () => {
  return jest.fn(() => ({
    // PaymentIntents API mock
    paymentIntents: {
      create: jest.fn(() =>
        Promise.resolve({
          id: "pi_3LvErCIxgWYWAssY1G76QVir",
          object: "payment_intent",
          amount: 250,
          customer: "cus_MeXlZlC4rANJY6",
          payment_method_types: ["card"],
          status: "succeeded",
          transfer_data: { destination: "acct_1LvEI3RKiiZzqLhd" },
          transfer_group: "group_pi_3LvErCIxgWYWAssY1G76QVir",
        })
      ),
    },
    // Refunds API mock
    refunds: {
      create: jest.fn(() =>
        Promise.resolve({
          id: "re_3LvErCIxgWYWAssY1CLpLJLQ",
          object: "refund",
          amount: 250,
          balance_transaction: "txn_3LvErCIxgWYWAssY18KfDJGx",
          charge: "ch_3LvErCIxgWYWAssY1C6CaSPz",
          created: 1666335704,
          currency: "sgd",
          metadata: {},
          payment_intent: "pi_3LvErCIxgWYWAssY1G76QVir",
          reason: null,
          receipt_number: null,
          source_transfer_reversal: null,
          status: "succeeded",
          transfer_reversal: "trr_1LvFEiIxgWYWAssYMtv69uiF",
        })
      ),
    },
    // Customers API mock
    customers: {
      listPaymentMethods: jest.fn(() =>
        Promise.resolve({
          data: [
            {
              id: "card_1LvEr3IxgWYWAssYUNeUwzPp",
              object: "payment_method",
              customer: "cus_MeXlZlC4rANJY6",
            },
          ],
        })
      ),
    },
  }));
});

jest.setTimeout(30000);

beforeAll(async () => {
  try {
    // Connect to database
    await sequelize.authenticate();
    await sequelize.sync({ force: true });

    // Create accounts
    return await Account.bulkCreate([
      {
        userId: "e63e1633-933f-4c82-ace5-680117f49201",
        connectedAccountId: "acct_1LvEfvRLOi8hNEH5",
        customerId: "cus_MeXlZlC4rANJY6",
      },
      {
        userId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
        connectedAccountId: "acct_1LvEI3RKiiZzqLhd",
        customerId: "cus_MeXMzigdl65O7K",
      },
    ]);
  } catch (err) {
    console.error(err.message);
  }
});

afterAll(async () => {
  await sequelize.close();
  return app.close();
});

describe("Payments", () => {
  // ----------------------------------
  // GET /payments
  // ----------------------------------
  describe("GET /payments", () => {
    const MOCK_DATA = [];

    beforeEach(async () => {
      // Create payment record
      const payment = await Payment.create({
        bidId: "b55cb921-188d-4da8-860c-bc30a76f9df5",
        paymentIntentId: "pi_3LvErCIxgWYWAssY1G76QVir",
        buyerId: "e63e1633-933f-4c82-ace5-680117f49201",
        runnerId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
        amountPaid: 2.5,
        status: "ONGOING",
      });

      payment.createdAt = payment.createdAt.toString();
      payment.updatedAt = payment.updatedAt.toString();

      MOCK_DATA.push(payment);

      return payment;
    });

    afterEach(async () => {
      return await Payment.destroy({ where: {} });
    });

    // SUCCESS: Get all
    test("returns all payment records", async () => {
      const res = await request
        .get("/payments")
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(200);
      expect(res.body.length).toBe(MOCK_DATA.length);

      return res;
    });

    // SUCCESS: Get a specific payment record
    test("returns specific payment record", async () => {
      const res = await request
        .get("/payments/b55cb921-188d-4da8-860c-bc30a76f9df5")
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(200);
      expect(res.body.bidId).toBe("b55cb921-188d-4da8-860c-bc30a76f9df5");

      return res;
    });

    // ERROR 404: Get a specific payment record
    test("payment record not found", async () => {
      const res = await request
        .get("/payments/invalid")
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(404);

      return res;
    });
  });

  // ----------------------------------
  // POST /payments
  // ----------------------------------
  describe("POST /payments", () => {
    afterEach(async () => {
      return await Payment.destroy({ where: {} });
    });

    // SUCCESS: Create a new payment record
    test("creates a new payment record", async () => {
      const res = await request
        .post("/payments")
        .set("Content-Type", "application/json")
        .send({
          bidId: "b55cb921-188d-4da8-860c-bc30a76f9df5",
          buyerId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
          runnerId: "e63e1633-933f-4c82-ace5-680117f49201",
          amountPaid: 2.5,
        });

      // Assertions
      expect(res.status).toBe(201);
      expect(res.body.bidId).toBe("b55cb921-188d-4da8-860c-bc30a76f9df5");
      expect(res.body.buyerId).toBe("a2f76b4e-1605-4e62-9e88-895920ba837b");
      expect(res.body.runnerId).toBe("e63e1633-933f-4c82-ace5-680117f49201");
      expect(res.body.paymentIntentId).toBeTruthy();
      expect(res.body.amountPaid).toBe(2.5);
      expect(res.body.status).toBe("ONGOING");

      return res;
    });
  });

  // ----------------------------------
  // PATCH /payments
  // ----------------------------------
  describe("PATCH /payments", () => {
    beforeEach(async () => {
      try {
        // Create Payment record
        const payment = await Payment.create({
          bidId: "b55cb921-188d-4da8-860c-bc30a76f9df5",
          paymentIntentId: "pi_3LvErCIxgWYWAssY1G76QVir",
          buyerId: "e63e1633-933f-4c82-ace5-680117f49201",
          runnerId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
          amountPaid: 2.5,
          status: "ONGOING",
        });

        return payment;
      } catch (err) {
        console.log(err);
      }
    });

    afterEach(async () => {
      return await Payment.destroy({ where: {} });
    });

    // SUCCESS: Refund payment
    test("refunds payment", async () => {
      const res = await request
        .patch("/payments/b55cb921-188d-4da8-860c-bc30a76f9df5")
        .set("Content-Type", "application/json")
        .send({
          status: "CANCELLED",
        });

      // Assertions
      expect(res.status).toBe(200);
      expect(res.body.status).toBe("CANCELLED");

      return res;
    });

    // ERROR 400: Status is not one of "CANCELLED" or "COMPLETED"
    test("invalid status to update", async () => {
      const res = await request
        .patch("/payments/b55cb921-188d-4da8-860c-bc30a76f9df5")
        .set("Content-Type", "application/json")
        .send({
          status: "INVALID",
        });

      // Assertions
      expect(res.status).toBe(400);

      return res;
    });
  });

  // ----------------------------------
  // DELETE /payments
  // ----------------------------------
  describe("PATCH /payments", () => {
    beforeEach(async () => {
      try {
        // Create Payment record
        const payment = await Payment.create({
          bidId: "b55cb921-188d-4da8-860c-bc30a76f9df5",
          paymentIntentId: "pi_3LvErCIxgWYWAssY1G76QVir",
          buyerId: "e63e1633-933f-4c82-ace5-680117f49201",
          runnerId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
          amountPaid: 2.5,
          status: "ONGOING",
        });

        return payment;
      } catch (err) {
        console.log(err);
      }
    });

    afterEach(async () => {
      return await Payment.destroy({ where: {} });
    });

    // SUCCESS: Deleted payment
    test("refunds payment", async () => {
      const res = await request
        .delete("/payments/b55cb921-188d-4da8-860c-bc30a76f9df5")
        .set("Content-Type", "application/json");

      // Check for presence of the object in DB
      const check = await Payment.findByPk(
        "b55cb921-188d-4da8-860c-bc30a76f9df5"
      );

      // Assertions
      expect(res.status).toBe(200);
      expect(check).toBeFalsy();

      return check;
    });
  });
});
