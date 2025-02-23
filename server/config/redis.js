const Redis = require("ioredis");
dotenv = require("dotenv");

const colors = require("colors");

dotenv.config();
const redisClient = new Redis(process.env.REDIS_URL);
const redisSubscriber = new Redis(process.env.REDIS_URL);
// const connectRedis = async () => {
//   try {
//     await redis.set("testKey", "Hello from Upstash");
//     const value = await redis.get("testKey");
//     console.log(`Redis Test: ${value}`.green.bold);
//   } catch (err) {
//     console.error("Redis Error:", err);
//   }
// };

module.exports = { redisClient, redisSubscriber };
