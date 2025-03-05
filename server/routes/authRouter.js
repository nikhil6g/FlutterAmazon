const express = require("express");
const {
  authUser,
  registerUser,
  logout,
  checkTokenValidity,
  getUser,
} = require("../controllers/authController");
const auth = require("../middlewares/auth");

const authRouter = express.Router();

authRouter.post("/api/signup", registerUser);
authRouter.post("/api/signin", authUser);
authRouter.post("/api/logout", auth, logout);
authRouter.post("/tokenIsValid", checkTokenValidity);
authRouter.get("/", auth, getUser);

module.exports = authRouter;
