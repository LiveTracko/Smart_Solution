package com.cosmicwebsolution.smart_solutions

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
import android.annotation.SuppressLint
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
                if (call.method == "getLastCallInfo") {
                       CoroutineScope(Dispatchers.IO).launch {
                    delay(3000L) // 3 seconds delay

           
                  val info = getLastCallInfo()
                    withContext(Dispatchers.Main) {
                        result.success(info)
                    }
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


@SuppressLint("Range")
private fun getLastCallInfo(): Map<String, Any?> {
    var duration = 0
    var callType = "unknown"
    var callerName: String? = null
    var callerNumber: String? = null

    val resolver = context.contentResolver
    val projection = arrayOf(
        CallLog.Calls.TYPE,
        CallLog.Calls.DURATION,
        CallLog.Calls.CACHED_NAME,
        CallLog.Calls.NUMBER   // <-- Add this line
    )

    val cursor = resolver.query(
        CallLog.Calls.CONTENT_URI,
        projection,
        null,
        null,
        CallLog.Calls.DATE + " DESC"
    )

    cursor?.use {
        while (it.moveToNext()) {
            val type = it.getInt(it.getColumnIndexOrThrow(CallLog.Calls.TYPE))
            val callDuration = it.getInt(it.getColumnIndexOrThrow(CallLog.Calls.DURATION))
            val name = it.getString(it.getColumnIndexOrThrow(CallLog.Calls.CACHED_NAME))
            val number = it.getString(it.getColumnIndexOrThrow(CallLog.Calls.NUMBER))

            // Accept only valid incoming/outgoing calls with duration > 0
            if (type == CallLog.Calls.INCOMING_TYPE || type == CallLog.Calls.OUTGOING_TYPE)   
             {
                duration = callDuration
                callerName = name ?: ""
                callerNumber = number ?: ""

                callType = when (type) {
                    CallLog.Calls.INCOMING_TYPE -> "incoming"
                    CallLog.Calls.OUTGOING_TYPE -> "outgoing"
                    else -> "unknown"
                }
                break
            } else {
                Log.d("CallLog", "Skipped call type=$type, duration=$callDuration")
            }
        }
    }

    return mapOf(
        "duration" to duration,
        "type" to callType,
        "name" to callerName,
        "number" to callerNumber

    )
}

}