importScripts("https://www.gstatic.com/firebasejs/7.23.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/7.23.0/firebase-messaging.js");
firebase.initializeApp({
    apiKey: "AIzaSyDCki0lW1aRG1bU0SrfnYip_NiBf5XtgY4",
    authDomain: "anadmagicar.firebaseapp.com",
    databaseURL: "https://anadmagicar.firebaseio.com",
    projectId: "anadmagicar",
    storageBucket: "anadmagicar.appspot.com",
    messagingSenderId: "611322359852",
    appId: "1:611322359852:web:e29d692156c486173b6189",
    measurementId: "G-TRQNPKLH6E"
});
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});