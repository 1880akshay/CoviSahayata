var admin = require("firebase-admin");

var serviceAccount = require("./covid-app-project-firebase-adminsdk.json");


admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
})

module.exports.admin = admin