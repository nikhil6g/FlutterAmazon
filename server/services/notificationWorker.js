const { redisSubscriber, redisClient } = require("../config/redis.js");
const { admin } = require("../config/firebaseAdmin");

redisSubscriber.subscribe("product_notifications");

redisSubscriber.on("message", async (channel, message) => {
  if (channel === "product_notifications") {
    const { productId, productName } = JSON.parse(message);

    const subscribers = await redisClient.smembers(
      `notifications:product:${productId}`
    );

    for (const userData of subscribers) {
      const { userId, fcmToken, isBanned } = JSON.parse(userData);

      if (isBanned) {
        continue; //skip sending notification if the user is banned
      }

      const payload = {
        notification: {
          title: "Product Available",
          body: `The product ${productName} is now back in stock!`,
        },
        data: {
          productId: productId,
        },
        token: fcmToken,
      };

      try {
        await admin.messaging().send(payload);
        console.log(`Notification sent to ${userId}`);
      } catch (error) {
        console.error("FCM Error:", error);
      }
    }

    await redisClient.del(`notifications:product:${productId}`); // Remove subscriptions after notification
  }
});
