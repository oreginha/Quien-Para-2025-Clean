// Archivo de autenticación Google específico para la versión web
// Soluciona el problema StorageRelay URI is not allowed for 'NATIVE_ANDROID' client type

// Función para iniciar autenticación con Google
function initGoogleAuth() {
  // Esta función es llamada una vez que la página ha cargado
  console.log('Inicializando Google Authentication para web...');

  // No hacemos nada más aquí, solo confirmamos que el script está cargado
  // La autenticación real será manejada por Firebase directamente
  window.googleAuthInitialized = true;
}

// Función para iniciar sesión con Google (será llamada desde Dart)
function signInWithGoogle() {
  return new Promise((resolve, reject) => {
    console.log('Iniciando proceso de autenticación con Google...');

    const provider = new firebase.auth.GoogleAuthProvider();
    provider.addScope('email');
    provider.addScope('profile');

    // Configurar el tipo de cliente como WEB
    provider.setCustomParameters({
      'prompt': 'select_account',
      'client_type': 'WEB',
      'login_hint': 'user@example.com'
    });

    // Usar signInWithRedirect para autenticación web
    firebase.auth().signInWithRedirect(provider)
      .then(() => {
        console.log('Redirección iniciada para autenticación con Google');
        resolve({ status: 'redirect_initiated' });
      })
      .catch((error) => {
        console.error('Error en autenticación con Google:', error);
        if (error.code === 'auth/popup-closed-by-user' ||
          error.code === 'auth/cancelled-popup-request' ||
          error.code === 'auth/redirect-cancelled-by-user') {
          resolve({
            status: 'cancelled',
            message: 'Autenticación cancelada por el usuario'
          });
        } else {
          reject(error);
        }
      });
  });
}

// Función para obtener el resultado de la redirección
function getRedirectResult() {
  return new Promise((resolve, reject) => {
    firebase.auth().getRedirectResult()
      .then((result) => {
        if (result.user) {
          console.log('Autenticación con Google exitosa');
          const userData = {
            status: 'success',
            uid: result.user.uid,
            email: result.user.email,
            name: result.user.displayName,
            photoURL: result.user.photoURL
          };
          resolve(userData);
        } else {
          resolve(null);
        }
      })
      .catch((error) => {
        console.error('Error al obtener resultado de redirección:', error);
        if (error.code === 'auth/popup-closed-by-user' ||
          error.code === 'auth/cancelled-popup-request') {
          resolve({ status: 'cancelled', message: 'Autenticación cancelada por el usuario' });
        } else {
          reject(error);
        }
      });
  });
}

// Función para cerrar sesión con Google (será llamada desde Dart)
function signOutGoogle() {
  return new Promise((resolve, reject) => {
    firebase.auth().signOut()
      .then(() => {
        console.log('Cierre de sesión exitoso');
        resolve();
      })
      .catch((error) => {
        console.error('Error al cerrar sesión:', error);
        reject(error);
      });
  });
}

// Exponer funciones al contexto global para que Flutter pueda accederlas
window.googleAuth = {
  signIn: signInWithGoogle,
  signOut: signOutGoogle,
  isInitialized: () => window.googleAuthInitialized === true
};

// Inicializar una vez que la página se ha cargado completamente
window.addEventListener('load', initGoogleAuth);
