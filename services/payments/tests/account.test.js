process.env.NODE_ENV = "test";

const app = require("../src");
const supertest = require("supertest");
const request = supertest(app);
const sequelize = require("../src/db");

const Account = require("../src/models/account.model");

jest.mock("stripe", () => {
  return jest.fn(() => ({
    // AccountLinks API mock
    accountLinks: {
      create: jest.fn(() =>
        Promise.resolve({
          object: "account_link",
          url: "https://connect.stripe.com/setup/e/acct_1LvEI3RKiiZzqLhd/tuL2gMjAHvp0",
        })
      ),
    },
    // SetupIntents API mock
    setupIntents: {
      create: jest.fn(() =>
        Promise.resolve({
          id: "seti_1LvEUMIxgWYWAssYFmhgtb2R",
          object: "setup_intent",
          client_secret:
            "seti_1LvEUMIxgWYWAssYFmhgtb2R_secret_MeXZqhwaQG6adFmF8ZRC7Hp7eehfsGA",
        })
      ),
    },
    // Accounts (Connected Accounts) API mock
    accounts: {
      create: jest.fn(() =>
        Promise.resolve({
          id: "acct_1LvEI3RKiiZzqLhd",
          object: "account",
          email: "test@email.com",
        })
      ),
    },
    // Customers API mock
    customers: {
      create: jest.fn(() =>
        Promise.resolve({
          id: "cus_MeXMzigdl65O7K",
          object: "customer",
          email: "test@email.com",
        })
      ),
      listPaymentMethods: jest.fn(() =>
        Promise.resolve({
          data: [],
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
  } catch (err) {
    console.error(err.message);
  }
});

afterAll(async () => {
  await sequelize.close();
  return app.close();
});

describe("Accounts", () => {
  // ----------------------------------
  // GET /payments/accounts
  // ----------------------------------
  describe("GET /payments/accounts", () => {
    const MOCK_DATA = [];
    beforeEach(async () => {
      // Create account record
      const account = await Account.create({
        userId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
        connectedAccountId: "acct_1LvEI3RKiiZzqLhd",
        customerId: "cus_MeXMzigdl65O7K",
      });

      MOCK_DATA.push(account);

      return account;
    });

    afterEach(async () => {
      return await Account.destroy({ where: {} });
    });

    // SUCCESS: Get all
    test("returns all accounts", async () => {
      const res = await request
        .get("/payments/accounts")
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(200);
      expect(res.body.length).toBe(MOCK_DATA.length);

      return res;
    });

    // SUCCESS: Get a specific account
    test("returns specific account", async () => {
      const res = await request
        .get("/payments/accounts/a2f76b4e-1605-4e62-9e88-895920ba837b")
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(200);
      expect(res.body.userId).toBe("a2f76b4e-1605-4e62-9e88-895920ba837b");

      return res;
    });

    // ERROR 404: Get a specific account
    test("account info not found", async () => {
      const res = await request
        .get("/payments/accounts/invalid")
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(404);

      return res;
    });
  });

  // ----------------------------------
  // GET /payments/accounts/setup-link
  // ----------------------------------
  describe("GET /payments/accounts/setup-link", () => {
    beforeEach(async () => {
      // Create account record
      const account = await Account.create({
        userId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
        connectedAccountId: "acct_1LvEI3RKiiZzqLhd",
        customerId: "cus_MeXMzigdl65O7K",
      });
      return account;
    });

    afterEach(async () => {
      return await Account.destroy({ where: {} });
    });

    // SUCCESS: Get an account link
    test("returns account link", async () => {
      const res = await request
        .get(
          "/payments/accounts/setup-link/a2f76b4e-1605-4e62-9e88-895920ba837b"
        )
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(200);
      expect(res.body.accountLink).toBeTruthy();

      return res;
    });
  });

  // ----------------------------------
  // GET /payments/accounts/setup-secret
  // ----------------------------------
  describe("GET /payments/accounts/setup-secret", () => {
    beforeEach(async () => {
      // Create account record
      const account = await Account.create({
        userId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
        connectedAccountId: "acct_1LvEI3RKiiZzqLhd",
        customerId: "cus_MeXMzigdl65O7K",
      });
      return account;
    });

    afterEach(async () => {
      return await Account.destroy({ where: {} });
    });

    // SUCCESS: Get a client secret
    test("returns client secret", async () => {
      const res = await request
        .get(
          "/payments/accounts/setup-secret/a2f76b4e-1605-4e62-9e88-895920ba837b"
        )
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(200);
      expect(res.body.clientSecret).toBeTruthy();

      return res;
    });
  });

  // ----------------------------------
  // GET /payments/accounts/payment-methods
  // ----------------------------------
  describe("GET /payments/payment-methods", () => {
    beforeEach(async () => {
      // Create account record
      const account = await Account.create({
        userId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
        connectedAccountId: "acct_1LvEI3RKiiZzqLhd",
        customerId: "cus_MeXMzigdl65O7K",
      });
      return account;
    });

    afterEach(async () => {
      return await Account.destroy({ where: {} });
    });

    // ERROR 404: User does not have payment methods
    test("user does not have payment methods", async () => {
      const res = await request
        .get(
          "/payments/accounts/payment-methods/a2f76b4e-1605-4e62-9e88-895920ba837b"
        )
        .set("Content-Type", "application/json");

      // Assertions
      expect(res.status).toBe(404);
      expect(res.body.type).toBe("NoPaymentMethod");

      return res;
    });
  });

  // ----------------------------------
  // POST /payments/accounts
  // ----------------------------------
  describe("POST /payments/accounts", () => {
    afterEach(async () => {
      return await Account.destroy({ where: {} });
    });

    test("creates new stripe accounts", async () => {
      const res = await request
        .post("/payments/accounts")
        .set("Content-Type", "application/json")
        .send({
          userId: "a2f76b4e-1605-4e62-9e88-895920ba837b",
          email: "test@email.com",
        });

      // Assertions
      expect(res.status).toBe(201);
      expect(res.body.userId).toBe("a2f76b4e-1605-4e62-9e88-895920ba837b");
      expect(res.body.connectedAccountId).toBe("acct_1LvEI3RKiiZzqLhd");
      expect(res.body.customerId).toBe("cus_MeXMzigdl65O7K");

      return res;
    });
  });
});
