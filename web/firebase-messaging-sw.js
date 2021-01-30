importScripts('https://www.gstatic.com/firebasejs/8.2.4/firebase-app.js');
  importScripts(
      'https://www.gstatic.com/firebasejs/8.2.4/firebase-messaging.js');
firebase.initializeApp({
    apiKey: "AIzaSyDCki0lW1aRG1bU0SrfnYip_NiBf5XtgY4",
    authDomain: "anadmagicar.firebaseapp.com",
    databaseURL: "https://anadmagicar.firebaseio.com",
    projectId: "anadmagicar",
    storageBucket: "anadmagicar.appspot.com",
    messagingSenderId: "611322359852",
    appId: "1:611322359852:web:e29d692156c486173b6189",
});
const messaging = firebase.messaging();

  