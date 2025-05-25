// Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyCA9CQ_w9JkSfkeKw-cyJir2Ck9wqRCbHg",
  authDomain: "planing-931b8.firebaseapp.com",
  projectId: "planing-931b8",
  storageBucket: "planing-931b8.firebasestorage.app",
  messagingSenderId: "308528139700",
  appId: "1:308528139700:web:95ed9c331b3cfc6f3876e1",
  measurementId: "G-9B8NWE62LB"
};

// Initialize Firebase ONLY if it hasn't been initialized already
if (!window.firebase || !firebase.apps || !firebase.apps.length) {
  firebase.initializeApp(firebaseConfig);
}

// Configurar Firebase Auth para web
try {
  const auth = firebase.auth();
  
  // Configurar idioma local
  auth.useDeviceLanguage();
  
  // Configurar persistencia para mantener la sesión entre recargas
  auth.setPersistence(firebase.auth.Auth.Persistence.LOCAL)
    .then(() => {
      console.log('Firebase Auth: Persistencia local configurada correctamente');
    })
    .catch((error) => {
      console.error('Firebase Auth: Error configurando persistencia:', error);
    });
    
  // Log para depuración
  console.log('Firebase Auth configurado correctamente');
} catch (e) {
  console.error('Error configurando Firebase Auth:', e);
}

// Log para depuración
console.log('Firebase configurado correctamente en la versión web');
