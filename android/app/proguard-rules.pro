-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-keepattributes *Annotation*

-dontwarn org.slf4j.**
-keep class org.slf4j.** { *; }

-dontwarn com.razorpay.**
-keep class com.razorpay.** {*;}

-optimizations !method/inlining/*

-keepclasseswithmembers class * {
  public void onPayment*(...);
}

-keep class androidx.lifecycle.** { *; }

-dontwarn com.cardinalcommerce.dependencies.internal.minidev.asm.**
-keep class com.cardinalcommerce.dependencies.internal.minidev.asm.** {*;}

-dontwarn com.stripe.android.pushProvisioning.**