// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/10.7.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.2/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
  apiKey: "AIzaSyCA9CQ_w9JkSfkeKw-cyJir2Ck9wqRCbHg",
  authDomain: "planing-931b8.firebaseapp.com",
  projectId: "planing-931b8",
  storageBucket: "planing-931b8.firebasestorage.app",
  messagingSenderId: "308528139700",
  appId: "1:308528139700:web:95ed9c331b3cfc6f3876e1",
  measurementId: "G-9B8NWE62LB"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();

// Set notification handler for all pages
self.addEventListener('push', function(event) {
  const data = event.data.json();
  const title = data.notification.title;
  const options = {
    body: data.notification.body,
    icon: '/favicon.png',
    data: data.data
  };
  
  event.waitUntil(self.registration.showNotification(title, options));
});

// Optional: Add background message handler
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/favicon.png'
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
