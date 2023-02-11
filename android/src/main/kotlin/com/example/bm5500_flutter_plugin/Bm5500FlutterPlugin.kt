package com.example.bm5500_flutter_plugin

import androidx.annotation.NonNull
import com.example.bm5500_flutter_plugin.FingerprintService
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity
import android.content.Context
import cn.com.aratek.fp.FingerprintScanner
import kotlinx.coroutines.*

/** Bm5500FlutterPlugin */
class Bm5500FlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity
  private lateinit var mScanner: FingerprintScanner
  private val fingerprintService = FingerprintService()
  private val _mainScope = CoroutineScope(Dispatchers.Main)

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "bm5500_flutter_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext

  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity;
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "bm5500_flutter_plugin")
      channel.setMethodCallHandler(Bm5500FlutterPlugin())

    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    _mainScope.launch {
      when (call.method) {
        "openDevice" -> {
          try {
            mScanner = fingerprintService.init(context)
            val res = withContext(Dispatchers.IO) {
              fingerprintService.openDevice(context, mScanner)
            }
            result.success(res)
          }catch (e: Exception){
            result.success("Oops! an error occurs")
          }
        }
        "closeDevice" -> {
            val res = withContext(Dispatchers.IO) {
              fingerprintService.closeDevice(mScanner)
            }
            result.success(res)
        }
        "captureFingerprint" -> {
            val res = withContext(Dispatchers.IO) {
              fingerprintService.captureAndExtractFingerprint(context, mScanner)
            }
           result.success(res)
        }
        else -> {
          result.notImplemented()
        }
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

