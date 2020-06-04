package com.bottlepay.flutter_libphonenumber

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.google.i18n.phonenumbers.NumberParseException
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.PhoneNumberUtil.PhoneNumberType
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.util.*


/** FlutterLibphonenumberPlugin */
public class FlutterLibphonenumberPlugin : FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_libphonenumber")
    channel.setMethodCallHandler(this);
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_libphonenumber")
      channel.setMethodCallHandler(FlutterLibphonenumberPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "get_all_supported_regions" -> {
        getAllSupportedRegions(result)
      }
      "parse" -> {
        parse(call, result)
      }
      "format" -> {
        format(call, result)
      } else -> {
      result.notImplemented()
    }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  // Send a result back to dart over the method channel
  private fun <T> sendDartResult(resultName: String, resultData: T) {
    channel.invokeMethod(resultName, mapOf(Pair("result", resultData)))
  }

  // Parse a given phone number and region to get metadata back about it
  private fun parse(call: MethodCall, result: Result) {
    val region = call.argument<String>("region")
    val phone = call.argument<String>("phone")

    if (phone == null || phone.isEmpty()) {
      result.error("InvalidParameters", "Invalid 'phone' parameter.", null)
    } else {
      val util = PhoneNumberUtil.getInstance()
      val res: HashMap<String, String>? = parseStringAndRegion(phone, region, util)
      if (res != null) {
        result.success(res)
      } else {
        result.error("InvalidNumber", "Number $phone is invalid", null)
      }
    }
  }

  // Gathers all of the supported regions on another thread and sends them back to Dart when ready
  private fun getAllSupportedRegions(result: Result) {
    Thread(Runnable {
      val regionsMap = mutableMapOf<String, MutableMap<String, String>>()
      for (region in PhoneNumberUtil.getInstance().supportedRegions) {
        val itemMap = mutableMapOf<String, String>()
        // Save the phone code
        val phoneCode = PhoneNumberUtil.getInstance().getCountryCodeForRegion(region).toString()
        itemMap["phoneCode"] = phoneCode

        // Get a formatted example number
        val exampleNumber = PhoneNumberUtil.getInstance().getExampleNumber(region)
        val formattedExampleNumber = PhoneNumberUtil.getInstance().format(exampleNumber, PhoneNumberUtil.PhoneNumberFormat.NATIONAL)
        itemMap["phoneMask"] = "+${phoneCode} ${formattedExampleNumber.toString()}".replace(Regex("""[\d]"""), "0")

        // Save this map into the return map
        regionsMap[region] = itemMap
      }
      Handler(Looper.getMainLooper()).post(Runnable {
        result.success(regionsMap)
      })
    }).start()
  }

  private fun parseStringAndRegion(string: String, region: String?,
                                   util: PhoneNumberUtil): HashMap<String, String>? {
    return try {
      val phoneNumber = util.parse(string, region)
      if (!util.isValidNumber(phoneNumber)) {
        null
      } else object : HashMap<String, String>() {
        init {
          val type = util.getNumberType(phoneNumber)
          put("type", numberTypeToString(type))
          put("e164", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.E164))
          put("international",
                  util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL))
          put("national", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.NATIONAL))
          put("country_code", phoneNumber.countryCode.toString())
          put("national_number", phoneNumber.nationalNumber.toString())
        }
      }

      // Try to parse the string to a phone number for a given region.

      // If the parsing is successful, we return a map containing :
      // - the number in the E164 format
      // - the number in the international format
      // - the number formatted as a national number and without the international prefix
      // - the type of number (might not be 100% accurate)
    } catch (e: NumberParseException) {
      null
    }
  }

  private fun format(call: MethodCall, result: Result) {
    val region = call.argument<String>("region")
    val number = call.argument<String>("string")
    if (number == null) {
      result.error("InvalidParameters", "Invalid 'string' parameter.", null)
      return
    }
    try {
      val util = PhoneNumberUtil.getInstance()
      val formatter = util.getAsYouTypeFormatter(region)
      var formatted = ""
      formatter.clear()
      for (character in number.toCharArray()) {
        formatted = formatter.inputDigit(character)
      }
      val res = HashMap<String, String>()
      res["formatted"] = formatted
      result.success(res)
    } catch (exception: Exception) {
      result.error("InvalidNumber", "Number $number is invalid", null)
    }
  }

  private fun numberTypeToString(type: PhoneNumberType): String {
    return when (type) {
      PhoneNumberType.FIXED_LINE -> "fixedLine"
      PhoneNumberType.MOBILE -> "mobile"
      PhoneNumberType.FIXED_LINE_OR_MOBILE -> "fixedOrMobile"
      PhoneNumberType.TOLL_FREE -> "tollFree"
      PhoneNumberType.PREMIUM_RATE -> "premiumRate"
      PhoneNumberType.SHARED_COST -> "sharedCost"
      PhoneNumberType.VOIP -> "voip"
      PhoneNumberType.PERSONAL_NUMBER -> "personalNumber"
      PhoneNumberType.PAGER -> "pager"
      PhoneNumberType.UAN -> "uan"
      PhoneNumberType.VOICEMAIL -> "voicemail"
      PhoneNumberType.UNKNOWN -> "unknown"
      else -> "notParsed"
    }
  }
}

