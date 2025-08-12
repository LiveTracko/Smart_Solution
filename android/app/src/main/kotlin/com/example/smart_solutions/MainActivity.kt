package com.example.smart_solutions

import android.Manifest
import android.database.Cursor
import android.provider.CallLog
import android.content.Intent
import android.content.Context
import android.content.IntentFilter
import android.net.Uri
import android.os.Bundle
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.*

class MainActivity : FlutterActivity() {
    private val CALL_CHANNEL = "direct_call" 
    private val LOG_CHANNEL = "com.smartsolutions/call_log"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CALL_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "makeDirectCall") {
                val phoneNumber = call.argument<String>("phoneNumber")
                if (phoneNumber != null) {
                    makeDirectCall(phoneNumber)
                    result.success("Call Started")
                } else {
                    result.error("INVALID_NUMBER", "Phone number is required", null)
                }
            } else {
                result.notImplemented()
            }
        }

        
        // Method channel for fetching call duration
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOG_CHANNEL)
            .setMethodCallHandler { call, result ->
            try{
                if (call.method == "getLastCallDuration") {
                       CoroutineScope(Dispatchers.IO).launch {
                    delay(3000L) // 3 seconds delay

                    val duration = getLastCallDuration()
                    result.success(duration)
                       }
                } else {
                    result.notImplemented()
                }
            } catch (e: Exception) {
              Log.e("CallLog", "Error in getLastCallDuration: ${e.message}", e)
              result.error("UNAVAILABLE", "Call log error: ${e.message}", null)
    }
            }
    }


    private fun makeDirectCall(phoneNumber: String) {
        val intent = Intent(Intent.ACTION_CALL).apply {
            data = Uri.parse("tel:$phoneNumber")
        }

        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
            startActivity(intent)
        } else {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CALL_PHONE), 1)
        }
    }


    // Handle permission request result properly
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 1 && grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
            // Permission granted - you can now trigger the call if necessary
        }
    
    }



    private fun getLastCallDuration(): Int {
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.READ_CALL_LOG
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return -1
        }

        val cursor: Cursor? = contentResolver.query(
            CallLog.Calls.CONTENT_URI,
            null,
            null,
            null,
            "${CallLog.Calls.DATE} DESC"
        )

        cursor?.use {
            if (it.moveToFirst()) {
                val durationIndex = it.getColumnIndex(CallLog.Calls.DURATION)
                return it.getInt(durationIndex)
            }
        }
        return 0
    }

}