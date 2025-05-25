package com.example.planing

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.embedding.android.FlutterFragmentActivity
import androidx.activity.ComponentActivity

class MainActivity: FlutterFragmentActivity() {
    private val TAG = "MainActivity"
    
    // Registro para el lanzador de solicitud de permisos
    private lateinit var requestPermissionLauncher: ActivityResultLauncher<String>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Inicializar el lanzador de solicitud de permisos
        requestPermissionLauncher = registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { isGranted: Boolean ->
            if (isGranted) {
                // Permiso concedido
                Log.d(TAG, "Permiso de notificaciones concedido")
                getFirebaseToken()
            } else {
                // Permiso denegado
                Log.d(TAG, "Permiso de notificaciones denegado")
            }
        }
        
        // Inicializar el lanzador de actividad
        someActivityResultLauncher = registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()
        ) { result: androidx.activity.result.ActivityResult ->
            // Handle the result here
        }
        
        // Solicitar permisos de notificación al iniciar la actividad
        askNotificationPermission()
    }

    private fun askNotificationPermission() {
        // Solo necesario para API nivel >= 33 (TIRAMISU)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) ==
                PackageManager.PERMISSION_GRANTED
            ) {
                // FCM SDK puede enviar notificaciones
                Log.d(TAG, "Ya tiene permiso de notificaciones")
                getFirebaseToken()
            } else if (shouldShowRequestPermissionRationale(Manifest.permission.POST_NOTIFICATIONS)) {
                // Mostrar explicación de por qué se necesita el permiso
                Log.d(TAG, "Mostrando explicación para permiso de notificaciones")
                // Aquí podrías mostrar un diálogo explicativo
                requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            } else {
                // Solicitar permiso directamente
                Log.d(TAG, "Solicitando permiso de notificaciones directamente")
                requestPermissionLauncher.launch(Manifest.permission.POST_NOTIFICATIONS)
            }
        } else {
            // Para versiones anteriores a Android 13, no se necesita permiso explícito
            getFirebaseToken()
        }
    }
    
    private fun requestNotificationPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ActivityCompat.requestPermissions(
                this,
                arrayOf<String>(Manifest.permission.POST_NOTIFICATIONS),
                0
            )
        }
    }

    private fun getFirebaseToken() {
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (!task.isSuccessful) {
                Log.w(TAG, "Error al obtener token FCM", task.exception)
                return@addOnCompleteListener
            }

            // Obtener nuevo token FCM
            val token = task.result
            Log.d(TAG, "FCM Token: $token")
        }
    }
    
    // Declaración del lanzador de actividad
    private lateinit var someActivityResultLauncher: ActivityResultLauncher<android.content.Intent>
}