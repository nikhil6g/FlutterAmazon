const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token)
      return res.status(401).json({ msg: "No auth token, acess denied" });

    const isVerified = jwt.verify(token, process.env.JWT_SECRET);

    if (!isVerified) {
      return res
        .status(401)
        .json({ msg: "token verification failed, authorization denied" });
    }

    req.userId = isVerified.id;
    req.token = token;
    next();
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

module.exports = auth;
