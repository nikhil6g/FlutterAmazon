const admin = require("firebase-admin");
const serviceAccount = require("../serviceAccountKey.json");
const dotenv = require("dotenv");

dotenv.config();

try {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
} catch (error) {
  console.error("Firebase Admin SDK initialization error:", error);
}

module.exports = { admin };
