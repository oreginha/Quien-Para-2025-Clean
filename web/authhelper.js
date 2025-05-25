// Función para garantizar la persistencia entre recargas (especial para Chrome debug)
function guaranteeAuthPersistence() {
  if (!auth) {
    initAuth();
    return; // La inicialización ya maneja la persistencia
  }
  
  console.log('Garantizando persistencia robusta en Firebase Auth');
  
  // Forzar persistencia LOCAL (más robusta)
  let persistencePromise;
  
  if (window.firebaseAuth && window.firebaseAuth.browserLocalPersistence) {
    // Versión moderna de Firebase
    const authModule = window.firebaseAuth;
    persistencePromise = authModule.setPersistence(auth, authModule.browserLocalPersistence);
  } else if (window.firebase && window.firebase.auth) {
    // Versión compat de Firebase
    persistencePromise = auth.setPersistence(firebase.auth.Auth.Persistence.LOCAL);
  } else {
    persistencePromise = Promise.resolve(); // Fallback si no hay método de persistencia
  }
  
  persistencePromise.then(() => {
      // Almacenar datos del usuario actual si existe
      const currentUser = auth.currentUser;
      if (currentUser) {
        const userData = {
          uid: currentUser.uid,
          email: currentUser.email,
          displayName: currentUser.displayName,
          photoURL: currentUser.photoURL,
          emailVerified: currentUser.emailVerified,
          timestamp: new Date().getTime()
        };
        
        // Guardar una copia en localStorage
        localStorage.setItem('chrome_debug_auth_user', JSON.stringify(userData));
        console.log('Datos de autenticación preservados manualmente:', currentUser.email);
        
        // Forzar que Firebase reconozca el token
        let authUserKey = null;
        for (let i = 0; i < localStorage.length; i++) {
          const key = localStorage.key(i);
          if (key && key.includes('firebase:authUser:')) {
            authUserKey = key;
            break;
          }
        }
        
        if (authUserKey) {
          // Establecer las banderas de control de Firebase Auth
          localStorage.setItem('firebase:forceRefresh', 'false');
          localStorage.setItem('firebase:auth:forceRefresh', 'false');
          
          // Guardar token en copia de seguridad
          const authData = localStorage.getItem(authUserKey);
          if (authData) {
            localStorage.setItem('backup_auth_token', authData);
          }
        }
      } else {
        console.log('No hay usuario autenticado para preservar');
        
        // Intentar restaurar una sesión previa
        try {
          const savedUser = localStorage.getItem('chrome_debug_auth_user');
          if (savedUser) {
            const userData = JSON.parse(savedUser);
            console.log('Intentando restaurar sesión anterior de:', userData.email);
            
            // Buscar token guardado
            let authUserKey = null;
            for (let i = 0; i < localStorage.length; i++) {
              const key = localStorage.key(i);
              if (key && key.includes('firebase:authUser:')) {
                authUserKey = key;
                break;
              }
            }
            
            if (!authUserKey && localStorage.getItem('backup_auth_token')) {
              // Recrear la clave de autenticación
              const apiKey = firebase.app().options.apiKey;
              const newAuthKey = `firebase:authUser:${apiKey}:[DEFAULT]`;
              localStorage.setItem(newAuthKey, localStorage.getItem('backup_auth_token'));
              console.log('Sesión restaurada de backup');
            }
          }
        } catch (e) {
          console.error('Error restaurando sesión:', e);
        }
      }
    })
    .catch((error) => {
      console.error('Error configurando persistencia robusta:', error);
    });
}// authhelper.js - Script para manejar la autenticación web con Firebase
// Este script soluciona los problemas de CORS y StorageRelay URI

// Variable global para almacenar la referencia a la instancia de Firebase Auth
let auth;

// Función para inicializar Firebase Auth con persistencia forzada
function initAuth() {
  // Verificar si estamos usando la versión modular de Firebase
  if (window.firebaseAuth) {
    auth = window.firebaseAuth;
  } else if (window.firebase && window.firebase.auth) {
    auth = window.firebase.auth();
  } else {
    console.error('Firebase Auth no está disponible - asegúrate de que Firebase esté inicializado');
    return;
  }
  
  // Log de registro inicial
  console.log('Inicializando Firebase Auth con persistencia mejorada...');
  
  // Forzar persistencia LOCAL (más robusta que SESSION)
  auth.setPersistence(firebase.auth.Auth.Persistence.LOCAL)
    .then(() => {
      console.log('Firebase Auth: Persistencia local configurada correctamente');
      // Asegurar que los cambios de persistencia se apliquen correctamente
      // Esto ayuda a solucionar problemas de sesión en Chrome durante el debug
      setTimeout(() => {
        const storageManager = window.localStorage;
        if (storageManager) {
          // Comprobar sesiones existentes
          let authUserKey = null;
          for (let i = 0; i < storageManager.length; i++) {
            const key = storageManager.key(i);
            if (key && key.includes('firebase:authUser:')) {
              authUserKey = key;
              break;
            }
          }
          
          if (authUserKey) {
            console.log('Sesión existente detectada en localStorage, asegurando persistencia');
            // Forzar que Firebase reconozca el token existente
            storageManager.setItem('firebase:forceRefresh', 'false');
            
            // Verificar el estado de autenticación actual
            if (auth.currentUser) {
              console.log('Firebase Auth ya tiene usuario autenticado:', auth.currentUser.email);
            } else {
              console.log('Verificando sesión persistida...');
              // Intentar verificar el estado de autenticación nuevamente
              auth.onAuthStateChanged(function(user) {
                if (user) {
                  console.log('Sesión recuperada correctamente para:', user.email);
                } else {
                  console.log('No se pudo recuperar la sesión a pesar de tener datos en localStorage');
                }
              });
            }
          } else {
            console.log('No se encontró sesión en localStorage');
          }
        }
      }, 1000);
    })
    .catch((error) => {
      console.error('Firebase Auth: Error configurando persistencia:', error);
    });
    
  console.log('Firebase Auth inicializado');
  
  // Configurar la dirección de Storage Relay para corregir el error
  // "Storagerelay URI is not allowed for 'NATIVE_ANDROID' client type"
  const storageManager = window.sessionStorage || window.localStorage;
  if (storageManager) {
    storageManager.setItem('firebase:auth:forceRefresh', 'false');
  }
  
  // Exponer estado a la ventana para que Flutter pueda verificar la inicialización
  window.authInitialized = true;
}

// Función para iniciar autenticación con Google usando signInWithPopup para entornos web soportados
function signInWithGooglePopupDirect() {
  return new Promise((resolve, reject) => {
    if (!auth) {
      initAuth();
    }
    
    console.log('Iniciando autenticación con Google usando signInWithPopup...');
    
    let provider;
    
    try {
      // Usar la versión correcta del proveedor según la API disponible
      if (window.firebase && window.firebase.auth) {
        provider = new firebase.auth.GoogleAuthProvider();
      } else if (window.firebaseAuth) {
        // Acceder a las funciones del módulo auth moderno
        provider = new window.GoogleAuthProvider();
      } else {
        throw new Error('No se pudo encontrar el proveedor de autenticación de Google');
      }
      
      provider.addScope('email');
      provider.addScope('profile');
    } catch (error) {
      console.error('Error creando el proveedor de Google:', error);
      reject(error);
      return;
    }
    
    // Configurar explícitamente el tipo de cliente como WEB
    provider.setCustomParameters({
      'login_hint': 'user@example.com',
      'client_type': 'WEB'
    });
    
    // Usar signInWithPopup para entornos donde es soportado
    auth.signInWithPopup(provider)
      .then((result) => {
        console.log('Autenticación con Google exitosa (popup)');
        
        // Construir objeto de respuesta
        const response = {
          id: result.user.uid,
          email: result.user.email,
          name: result.user.displayName || 'Usuario Google',
          photoUrl: result.user.photoURL,
          token: result.credential?.accessToken || null,
          status: 'success'
        };
        
        resolve(response);
      })
      .catch((error) => {
        console.error('Error en autenticación con Google (popup):', error);
        
        // Detectar si el error es debido a que se cerró la ventana emergente
        if (error.code === 'auth/popup-closed-by-user' || 
            error.code === 'auth/cancelled-popup-request' ||
            error.message === 'popup_closed' ||
            error.message.includes('The popup has been closed')) {
          console.log('Ventana emergente cerrada por el usuario');
          resolve({
            status: 'cancelled',
            message: 'Inicio de sesión cancelado',
            code: 'popup_closed'
          });
        } else {
          // Para otros errores, intentar con redirección
          console.log('Error en popup, intentando con redirección...');
          signInWithGoogleRedirect()
            .then(redirectResult => resolve(redirectResult))
            .catch(redirectError => reject(redirectError));
        }
      });
  });
}

// Función para iniciar autenticación con Google usando signInWithRedirect (más compatible)
function signInWithGoogleRedirect() {
  return new Promise((resolve, reject) => {
    if (!auth) {
      initAuth();
    }
    
    console.log('Iniciando autenticación con Google a través de redirección...');
    
    const provider = new firebase.auth.GoogleAuthProvider();
    provider.addScope('email');
    provider.addScope('profile');
    
    // Configurar explícitamente el tipo de cliente como WEB
    provider.setCustomParameters({
      'login_hint': 'user@example.com',
      'client_type': 'WEB',
      'prompt': 'select_account'
    });
    
    // Usar signInWithRedirect para mayor compatibilidad
    auth.signInWithRedirect(provider)
      .then(() => {
        console.log('Redirección a Google completada. Esperando resultado...');
        resolve({ status: 'redirect_initiated' });
      })
      .catch((error) => {
        console.error('Error iniciando redirección a Google:', error);
        
        // Incluso con redirección pueden ocurrir errores de cancelación
        if (error.code === 'auth/cancelled-popup-request' ||
            error.code === 'auth/redirect-cancelled-by-user') {
          console.log('Redirección cancelada por el usuario');
          resolve({
            status: 'cancelled',
            message: 'Inicio de sesión cancelado',
            code: 'redirect_cancelled'
          });
        } else {
          reject({
            error: error.message,
            code: error.code,
            status: 'error'
          });
        }
      });
  });
}

// Función principal para iniciar sesión con Google (llamada desde Flutter)
// Intenta primero con signInWithPopup y si falla, usa signInWithRedirect
function signInWithGooglePopup() {
  return new Promise((resolve, reject) => {
    // Intentar primero con popup
    signInWithGooglePopupDirect()
      .then(result => {
        // Si es un inicio de redirección o un éxito, retornamos el resultado
        resolve(result);
      })
      .catch(error => {
        // Si hay un error en el popup, rechazar la promesa
        reject(error);
      });
  });
}

// Función para verificar el resultado de la redirección (llamada después de la redirección)
function getAuthRedirectResult() {
  return new Promise((resolve, reject) => {
    if (!auth) {
      initAuth();
    }
    
    console.log('Verificando resultado de redirección...');
    
    auth.getRedirectResult()
      .then((result) => {
        if (result.user) {
          console.log('Autenticación con Google exitosa:', result.user.displayName);
          
          // Construir objeto de respuesta con datos del usuario
          const response = {
            id: result.user.uid,
            email: result.user.email,
            name: result.user.displayName || 'Usuario Google',
            photoUrl: result.user.photoURL,
            token: result.credential?.accessToken || null,
            status: 'success'
          };
          
          resolve(response);
        } else {
          console.log('No hay resultado de redirección o el usuario canceló');
          resolve({ status: 'no_result' });
        }
      })
      .catch((error) => {
        console.error('Error obteniendo resultado de redirección:', error);
        reject({
          error: error.message,
          code: error.code,
          status: 'error'
        });
      });
  });
}

// Función para verificar el estado actual de autenticación
function checkAuthState() {
  return new Promise((resolve) => {
    if (!auth) {
      initAuth();
    }
    
    // Llamar a nuestra función de persistencia mejorada
    guaranteeAuthPersistence();
    
    // Comprobar primero si hay un usuario en memoria
    const currentUser = auth.currentUser;
    
    if (currentUser) {
      // Ya tenemos usuario autenticado en memoria
      resolve({
        id: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName || 'Usuario Google',
        photoUrl: currentUser.photoURL,
        status: 'authenticated'
      });
      return;
    }
    
    // Si no hay usuario en memoria, verificar localStorage
    // Primer intento: verificar el token normal de Firebase Auth
    let authUserKey = null;
    for (let i = 0; i < localStorage.length; i++) {
      const key = localStorage.key(i);
      if (key && key.includes('firebase:authUser:')) {
        authUserKey = key;
        break;
      }
    }
    
    if (authUserKey) {
      // Hay datos de usuario en localStorage
      try {
        const userData = JSON.parse(localStorage.getItem(authUserKey));
        if (userData && userData.uid) {
          console.log('Recuperando sesión desde localStorage para:', userData.email);
          
          // Intentar comprobar si el token sigue siendo válido
          try {
            // Verificar si podemos obtener un token del usuario
            if (userData.stsTokenManager && userData.stsTokenManager.accessToken) {
              console.log('Token de autenticación encontrado y parece válido');
            }
            
            // Reforzar persistencia
            localStorage.setItem('firebase:forceRefresh', 'false');
            localStorage.setItem('backup_auth_token', localStorage.getItem(authUserKey));
            
            resolve({
              id: userData.uid,
              email: userData.email,
              name: userData.displayName || 'Usuario Google',
              photoUrl: userData.photoURL,
              status: 'authenticated'
            });
            return;
          } catch (e) {
            console.error('Error verificando token:', e);
          }
        }
      } catch (e) {
        console.error('Error parseando datos de usuario en localStorage:', e);
      }
    }
    
    // Segundo intento: verificar nuestro backup manual
    try {
      const savedUser = localStorage.getItem('chrome_debug_auth_user');
      if (savedUser) {
        const userData = JSON.parse(savedUser);
        if (userData && userData.uid) {
          console.log('Recuperando sesión desde backup manual para:', userData.email);
          
          // Intentar restaurar la autenticación desde el backup
          if (localStorage.getItem('backup_auth_token')) {
            const apiKey = firebase.app().options.apiKey;
            const newAuthKey = `firebase:authUser:${apiKey}:[DEFAULT]`;
            localStorage.setItem(newAuthKey, localStorage.getItem('backup_auth_token'));
            console.log('Token restaurado desde backup');
          }
          
          resolve({
            id: userData.uid,
            email: userData.email,
            name: userData.displayName || 'Usuario Google',
            photoUrl: userData.photoURL,
            status: 'authenticated'
          });
          return;
        }
      }
    } catch (e) {
      console.error('Error recuperando sesión desde backup manual:', e);
    }
    
    // Si no hay datos en localStorage o no se pudo recuperar, marcar como no autenticado
    resolve({ status: 'unauthenticated' });
  });
}

// Función para cerrar sesión
function signOut() {
  return new Promise((resolve, reject) => {
    if (!auth) {
      initAuth();
    }
    
    // Primero, intentemos preservar los datos (solo en modo debug)
    try {
      const currentUser = auth.currentUser;
      if (currentUser) {
        // Guardar una copia de la información del usuario antes de cerrar sesión
        const userData = {
          uid: currentUser.uid,
          email: currentUser.email,
          displayName: currentUser.displayName,
          photoURL: currentUser.photoURL,
          timestamp: new Date().getTime()
        };
        
        // Preservar para modo debug
        localStorage.setItem('chrome_debug_last_user', JSON.stringify(userData));
        console.log('Datos de usuario preservados para debug');
      }
    } catch (e) {
      console.warn('Error preservando datos de usuario para debug:', e);
    }
    
    auth.signOut()
      .then(() => {
        console.log('Cierre de sesión exitoso');
        
        // En modo debug, no eliminar completamente los tokens
        if (window.location.hostname === 'localhost' || 
            window.location.hostname === '127.0.0.1') {
          // No eliminar el token de backup para permitir recuperación
          console.log('Modo debug: Preservando tokens de backup');
        } else {
          // Modo producción: limpiar completamente
          localStorage.removeItem('backup_auth_token');
          localStorage.removeItem('chrome_debug_auth_user');
          localStorage.removeItem('chrome_debug_last_user');
        }
        
        resolve({ status: 'success' });
      })
      .catch((error) => {
        console.error('Error al cerrar sesión:', error);
        reject({
          error: error.message,
          status: 'error'
        });
      });
  });
}

// Inicializar Auth cuando se carga la página
document.addEventListener('DOMContentLoaded', () => {
  initAuth();
  
  // Aplicar el sistema de persistencia mejorado después de unos segundos
  setTimeout(guaranteeAuthPersistence, 1000);
});

// Verificar automáticamente el estado de autenticación al iniciar la aplicación
// Esto ayuda a resolver el problema de tener que iniciar sesión cada vez que se inicia la app en debug
setTimeout(() => {
  checkAuthState().then(state => {
    console.log('Estado de autenticación inicial: ', state.status);
    window.authInitialState = state;
    
    // Si ya hay un usuario autenticado, reforzar la persistencia
    if (state.status === 'authenticated') {
      setTimeout(guaranteeAuthPersistence, 500);
    }
  });
}, 800);

// Exponer funciones al contexto global para que Flutter pueda accederlas
window.authWeb = {
  signInWithGoogle: signInWithGooglePopup,
  getRedirectResult: getAuthRedirectResult,
  checkAuthState: checkAuthState,
  signOut: signOut,
  isInitialized: () => window.authInitialized === true,
  getInitialState: () => {
    // Verificar si ya tenemos un estado inicial
    if (window.authInitialState) {
      return window.authInitialState;
    }
    
    // Intentar recuperar desde localStorage si no hay estado inicial
    try {
      const savedUser = localStorage.getItem('chrome_debug_auth_user');
      if (savedUser) {
        const userData = JSON.parse(savedUser);
        return {
          id: userData.uid,
          email: userData.email,
          name: userData.displayName || 'Usuario Google',
          photoUrl: userData.photoURL,
          status: 'authenticated'
        };
      }
    } catch (e) {
      console.error('Error al recuperar estado desde backup:', e);
    }
    
    // Si no hay información, retornar no autenticado
    return { status: 'unauthenticated' };
  },
  guaranteePersistence: guaranteeAuthPersistence
};

console.log('AuthHelper para web inicializado correctamente');
