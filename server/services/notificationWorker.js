import { redisSubscriber, redisClient } from "../config/redis.js";
import admin from "firebase-admin";

redisSubscriber.subscribe("product_notifications");

redisSubscriber.on("message", async (channel, message) => {
  if (channel === "product_notifications") {
    const { productId, productName } = JSON.parse(message);

    const subscribers = await redisClient.smembers(
      `notifications:product:${productId}`
    );

    subscribers.forEach(async (userData) => {
      const { userId, fcmToken } = JSON.parse(userData);
      const payload = {
        notification: {
          title: "Product Available",
          body: `The product ${productName} is now back in stock!`,
        },
        token: fcmToken,
      };

      try {
        await admin.messaging().send(payload);
        console.log(`Notification sent to ${userId}`);
      } catch (error) {
        console.error("FCM Error:", error);
      }
    });

    await redisClient.del(`notifications:product:${productId}`); // Remove subscriptions after notification
  }
});
