const Redis = require("ioredis");
dotenv = require("dotenv");

const colors = require("colors");

dotenv.config();

//When a Redis connection is in subscription mode (subscribe command is called), it can’t be used for anything else—not even publishing.
//redisClient is used for storage & publishing.
//redisSubscriber is used for real-time notifications.

const redisClient = new Redis(process.env.REDIS_URL);
const redisSubscriber = new Redis(process.env.REDIS_URL);

module.exports = { redisClient, redisSubscriber };
