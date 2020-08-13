const firebase = require("firebase");

console.log("Here in connection")
const fireBaseApp = firebase.initializeApp({
    serviceAccount: require("../Config/fireBase.json"),
    databaseURL: "https://project-covid19-67c4d.firebaseio.com/"
});
const db = firebase.database();
const ref = db.ref("/test");
ref.on("value",(snapshot) => {
    const data = snapshot.val();   //Data is in JSON format.
    console.log(data);
}, (error) => {
    console.log(error)
})

