// session_fix.js - Script para asegurar persistencia de sesión en Chrome Debug
// Este script debe ser incluido antes de Firebase Auth

// Función para asegurar que la sesión se mantiene en Chrome
(function() {
  console.log('✨ Inicializando session_fix.js para Chrome Debug');
  
  // Sobreescribir localStorage para mantener la autenticación persistente
  const originalSetItem = localStorage.setItem;
  const originalRemoveItem = localStorage.removeItem;
  
  // Capturar las claves importantes de autenticación
  const AUTH_KEYS = [];
  
  // Reemplazar setItem para capturar las claves de autenticación
  localStorage.setItem = function(key, value) {
    if (key && key.includes('firebase:authUser:')) {
      console.log('🔐 Detectada clave de autenticación Firebase: ' + key);
      
      // Guardar el valor para recuperarlo en caso de recarga
      localStorage.setItem('_auth_backup_' + key, value);
      
      // Forzar persistencia para prevenir problemas con Chrome
      localStorage.setItem('firebase:forceRefresh', 'false');
      
      // Agregar a la lista de claves importantes
      if (!AUTH_KEYS.includes(key)) {
        AUTH_KEYS.push(key);
      }
    }
    
    return originalSetItem.call(this, key, value);
  };
  
  // Sobreescribir removeItem para prevenir borrado de datos de autenticación durante recargas
  localStorage.removeItem = function(key) {
    if (key && key.includes('firebase:authUser:')) {
      console.log('🚨 Intento de eliminar clave de autenticación: ' + key);
      
      // No eliminar durante sesión de debug - solo marcar para eliminación
      localStorage.setItem('_pending_remove_' + key, 'true');
      return;
    }
    
    return originalRemoveItem.call(this, key);
  };
  
  // Restaurar datos de autenticación después de recargas
  window.addEventListener('load', function() {
    setTimeout(function() {
      // Buscar claves de respaldo
      for (let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        if (key && key.startsWith('_auth_backup_firebase:authUser:')) {
          const originalKey = key.replace('_auth_backup_', '');
          
          // Si la clave original no existe, restaurarla
          if (!localStorage.getItem(originalKey)) {
            console.log('🔄 Restaurando datos de autenticación para: ' + originalKey);
            localStorage.setItem(originalKey, localStorage.getItem(key));
            localStorage.setItem('firebase:forceRefresh', 'false');
          }
        }
      }
    }, 100);
  });
  
  // Ejecutar después de que Firebase Auth esté disponible
  window.addEventListener('DOMContentLoaded', function() {
    // Esperar a que Firebase Auth esté disponible
    const waitForFirebase = setInterval(function() {
      if (typeof firebase !== 'undefined' && firebase.auth) {
        clearInterval(waitForFirebase);
        console.log('✅ Firebase Auth detectado, aplicando correcciones adicionales');
        
        // Forzar modo de persistencia LOCAL
        firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL)
          .then(() => {
            console.log('🔒 Persistencia LOCAL configurada correctamente');
          })
          .catch((error) => {
            console.error('❌ Error configurando persistencia:', error);
          });
      }
    }, 100);
  });
  
  console.log('✅ session_fix.js inicializado correctamente');
})();
