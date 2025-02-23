const admin = require("firebase-admin");
const serviceAccount = require("../serviceAccountKey.json");
const dotenv = require("dotenv");

dotenv.config();

try {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  }); // It will automatically use GOOGLE_APPLICATION_CREDENTIALS
  // console.log(`${process.env.GOOGLE_APPLICATION_CREDENTIALS} is initialized`);
  // admin
  //   .auth()
  //   .listUsers(1)
  //   .then((listUsersResult) => {
  //     console.log("admin is initialized");
  //   })
  //   .catch((error) => {
  //     console.log("admin is not initialized, or there is another error", error);
  //   });
} catch (error) {
  console.error("Firebase Admin SDK initialization error:", error);
}

module.exports = admin;
