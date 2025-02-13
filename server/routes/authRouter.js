const express = require("express");
const {
  authUser,
  registerUser,
  checkTokenValidity,
  getUser,
} = require("../controllers/authController");
const auth = require("../middlewares/auth");

const authRouter = express.Router();

authRouter.post("/api/signup", registerUser);
authRouter.post("/api/signin", authUser);
authRouter.post("/tokenIsValid", checkTokenValidity);
authRouter.get("/", auth, getUser);

module.exports = authRouter;
