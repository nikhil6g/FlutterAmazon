const express = require("express");
const connectDB = require("./config/db");

const authRouter = require("./routes/authRouter");
const adminRouter = require("./routes/adminRouter");
const productRouter = require("./routes/productRouter");
const userRouter = require("./routes/userRouter");
const dotenv = require("dotenv");
const cors = require("cors");

dotenv.config();
connectDB();
const app = express();

//middlewares
app.use(
  cors({
    origin: "*", // Frontend origins
    methods: ["GET", "POST", "DELETE"],
    credentials: true,
  })
);
app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);

//connections

app.listen(process.env.PORT, "0.0.0.0", () => {
  console.log(`connected at port ${process.env.PORT} hello!! node`.yellow.bold);
});
