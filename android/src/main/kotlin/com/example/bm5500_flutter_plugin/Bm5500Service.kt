package com.example.bm5500_flutter_plugin

import android.content.Context
import android.util.Log
import cn.com.aratek.fp.Bione
import cn.com.aratek.fp.FingerprintScanner
import cn.com.aratek.fp.FingerprintImage
import android.util.Base64
import android.annotation.SuppressLint
import kotlinx.coroutines.*

@SuppressLint("SdCardPath", "HandlerLeak")
class FingerprintService {

    fun init(context: Context): FingerprintScanner {
        Log.d("Debug", "Initializing Fingerprint scanner")
        return FingerprintScanner.getInstance(context)
    }

    fun openDevice(context: Context, mScanner: FingerprintScanner): String {
        try {
            var message = "done"
            if (mScanner.powerOn() != FingerprintScanner.RESULT_OK) {
                Log.d("Debug", "Fingerprint device power on failed")
                message = "Fingerprint device power on failed"
            }
            if (mScanner.open() != FingerprintScanner.RESULT_OK) {
                message = "Fingerprint device failed to open"
                Log.d("Debug", "Fingerprint device failed to open")
            } else {
                if (Bione.initialize(context, "/sdcard/fp.db") == Bione.RESULT_OK) {
                    message = "Bione initialize"
                    Log.d("Debug", "Bione initialize")
                } else {
                    message = "Bione failed"
                    Log.d("Debug", "Bione failed")
                }
            }
            return message
        } catch (e: Exception) {
            Log.d("Debug", "Oops!, Unable to initialized the fingerprint sdk!")
            return "Oops!, Unable to initialized the fingerprint sdk!"
        }
    }


    fun closeDevice(mScanner: FingerprintScanner): String {
        var res = "Unknown"
        try {
            if (mScanner.close() != FingerprintScanner.RESULT_OK) {
                Log.i("ERROR", "Fingerprint device close failed")
                res = "Fingerprint device close failed"
            } else {
                res = "Fingerprint device close success"
                Log.i("SUCCESS", "Fingerprint device close success")
            }
            if (mScanner.powerOff() != FingerprintScanner.RESULT_OK) {
                res = "fingerprint device power off failed"
                Log.i("ERROR", "fingerprint device power off failed")
            }
            if (Bione.exit() != Bione.RESULT_OK) {
                res = "algorithm_cleanup_failed"
                Log.i("ERROR", "algorithm_cleanup_failed")
            }

        } catch (e: Exception) {
            res = "Oops! Something goes wrong, try again."
            Log.i("ERROR", "Oops! Something goes wrong, try again.")
        }
        return res
    }


    fun captureAndExtractFingerprint(context: Context, mScanner: FingerprintScanner): String {

        try {
            val res = Bione.initialize(context, "/sdcard/fp.db")
            if (res != Bione.RESULT_OK) {
                Log.d("Debug", "Bione not initialized")
                return "Bione not initialized"
            }
            val prepareScanner = mScanner.prepare()
            if (prepareScanner != Bione.RESULT_OK) {
                Log.d("Debug", "Scanner Not initialized")
                return "Scanner Not initialized"
            }
            var fingerprintImage: FingerprintImage?
            var featTemp: ByteArray?
            while (true) {
                val res = mScanner.capture()
                if (res?.data != null) {
                    val quality = Bione.getFingerprintQuality(res.data as FingerprintImage)
                    if (quality > 70) {
                        fingerprintImage = res.data as FingerprintImage
                        break
                    }
                }
            }
            mScanner.finish()
            //delay(2000)
            val result = Bione.extractFeature(fingerprintImage)
            if (result.error != Bione.RESULT_OK) {
                Log.d("Debug","Failed to extract fingerprint template")
                return "Failed to extract fingerprint template"
            }
            featTemp = result.data as ByteArray
            return Base64.encodeToString(featTemp, Base64.DEFAULT)

        } catch (e: Exception) {
            Log.d("Debug",e.toString())
            return e.toString()
        }
    }
}


