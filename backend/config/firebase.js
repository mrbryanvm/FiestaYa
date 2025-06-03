const path = require('path');
const admin = require("firebase-admin");
const dotenv = require('dotenv');
dotenv.config();

const serviceAccountPath = path.resolve(__dirname, process.env.GOOGLE_CREDENTIALS);

admin.initializeApp({
  credential: admin.credential.cert(require(serviceAccountPath))
});

module.exports = admin;
