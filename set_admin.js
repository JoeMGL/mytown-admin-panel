const admin = require("firebase-admin");

// Load Firebase Admin SDK JSON (Replace with your file path)
const serviceAccount = require("./mytown-admin-sdk.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

// 🔹 Function to Assign Admin Role
const setAdmin = async (uid) => {
  try {
    await admin.auth().setCustomUserClaims(uid, { admin: true });
    console.log(`✅ User ${uid} is now an admin!`);
  } catch (error) {
    console.error("❌ Error setting admin role:", error);
  }
};

// 🔹 Replace "USER_UID_HERE" with the Firebase UID of the user
setAdmin("TcLrKE61g8aD7DwgW7ee13EP0cq1");
