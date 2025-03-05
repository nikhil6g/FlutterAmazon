const asyncHandler = require("express-async-handler");
const User = require("../models/user");
const mongoose = require("mongoose");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { redisClient } = require("../config/redis");

//@description     Auth the user
//@route           POST /api/signin
//@access          Public
const authUser = asyncHandler(async (req, res) => {
  try {
    //get the data from client
    const { email, password } = req.body;

    //Check a data in database present or not
    const user = await User.findOne({ email }); // it is short hand syntax of 'email' : email
    if (!user) {
      //existingUser is null or not
      return res
        .status(400)
        .json({ msg: "User with this email does not exists!" });
    }

    //Check if password is matching or not
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password!!" });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET);
    res.json({ token, ...user._doc }); //... for object destructuring

    // Fetch all subscribed products for this user and remove the ban
    const keys = await redisClient.keys("notifications:product:*");

    for (const key of keys) {
      const subscribers = await redisClient.smembers(key);

      for (const userData of subscribers) {
        const parsedData = JSON.parse(userData);
        if (parsedData.userId === user._id.toString()) {
          parsedData.isBanned = false;

          await redisClient.srem(key, userData);
          await redisClient.sadd(key, JSON.stringify(parsedData));
        }
      }
    }
  } catch (e) {
    res.status(500).json({
      error: e.message,
    });
  }
});

//@description     Register new user
//@route           POST /api/signup
//@access          Public
const registerUser = asyncHandler(async (req, res) => {
  try {
    //get the data from client
    const { name, email, password } = req.body;

    //Check atleast one data in database is same with it or not
    const existingUser = await User.findOne({ email }); // it is short hand syntax of 'email' : email
    if (existingUser) {
      //existingUser is null or not
      return res
        .status(400)
        .json({ msg: "User with same email already exists" });
    }

    //encrypting password
    const hashedPassword = await bcryptjs.hash(password, 8);

    //post that data in database
    let user = new User({
      email,
      password: hashedPassword, //order does not matter
      name,
    });
    user = await user.save();

    //return data to the client
    res.json(user);
  } catch (e) {
    res.status(500).json({
      error: e.message,
    });
  }
});

//@description     logout the user
//@route           POST /api/logout
//@access          Protected
const logout = asyncHandler(async (req, res) => {
  const userId = req.userId;

  if (!userId) {
    return res.status(400).json({ error: "Missing userId" });
  }

  try {
    // Fetch all subscribed products for this user and ban for this user for getting any notification
    const keys = await redisClient.keys("notifications:product:*");

    for (const key of keys) {
      const subscribers = await redisClient.smembers(key);

      for (const userData of subscribers) {
        const parsedData = JSON.parse(userData);
        if (parsedData.userId === userId) {
          parsedData.isBanned = true;

          await redisClient.srem(key, userData);
          await redisClient.sadd(key, JSON.stringify(parsedData));
        }
      }
    }

    return res.json({ message: "User Logs out successfully.." });
  } catch (error) {
    return res.status(500).json({ error: "Failed to logout" });
  }
});

//@description     Check token validity
//@route           POST /tokenIsValid
//@access          Public
const checkTokenValidity = asyncHandler(async (req, res) => {
  try {
    const token = req.header("x-auth-token");

    if (!token) return res.json(false);

    const isVerified = jwt.verify(token, process.env.JWT_SECRET);

    if (!isVerified) {
      return res.json(false);
    }

    const user = await User.findById(isVerified.id);

    if (!user) {
      return res.json(false);
    }
    res.json(true);
  } catch (e) {
    res.status(500).json({
      error: e.message,
    });
  }
});

//@description     Get user data
//@route           Get /
//@access          Protected
const getUser = asyncHandler(async (req, res) => {
  const user = await User.findById(req.userId);
  res.json({ ...user._doc, token: req.token });
});

module.exports = {
  authUser,
  registerUser,
  logout,
  checkTokenValidity,
  getUser,
};
