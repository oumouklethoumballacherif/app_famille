importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyD2NEBlXm4zL4tInOuCUj1MtbguTCUsJd",
    authDomain: "famille-tree.firebaseapp.com",
    projectId: "famille-tree",
    storageBucket: "famille-tree.firebasestorage.app",
    messagingSenderId: "469138142638",
    appId: "1:469138142638:web:3cbcd8fdded6a0dddec43f"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
    console.log('[firebase-messaging-sw.js] Received background message ', payload);
    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: '/icons/Icon-192.png'
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
