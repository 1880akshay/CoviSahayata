const express = require('express');
const { admin } = require('./firebase-config');

const app = express();
app.use(express.json());

const port = 3000;

const db = admin.firestore();

app.post('/firebase/notification', async (req, res) => {
    var sender = await db.collection('users').doc(req.body.uid1).get();
    db.collection('users').doc(req.body.uid2).get().then(receiver => {
        admin.messaging().sendToDevice(
            receiver.data()['tokens'],
            {
                data: {
                    title: 'New Message',
                    body: 'You have a new message from '+sender.data()['name'],
                    payload: JSON.stringify({
                        uid1: req.body.uid2,
                        uid2: req.body.uid1,
                    })
                },
            }
        ).then( response => {
            console.log("Notification sent successfully");
            res.status(200).send("Notification sent successfully");
        })
        .catch( error => {
            console.log(error);
        });
    }); 
})

app.listen(port, () => {
    console.log("listening to port "+port);
})