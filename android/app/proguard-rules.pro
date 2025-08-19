# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep your application classes
-keep class com.example.smarttimer.** { *; }

# Keep Gson stuff
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

# Keep audio session stuff
-keep class com.ryanheise.audioservice.** { *; }
-keep class com.ryanheise.just_audio.** { *; }

# Keep provider stuff
-keep class * extends androidx.lifecycle.ViewModel
-keep class * extends androidx.lifecycle.LiveData
-keep class * extends androidx.lifecycle.MutableLiveData 