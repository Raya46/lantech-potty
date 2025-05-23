# Aturan umum Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Aturan untuk menjaga nama method native (JNI) jika ada
-keepclasseswithmembernames class * {
    native <methods>;
}

# Aturan untuk menjaga anotasi, yang mungkin digunakan oleh beberapa library
-keepattributes *Annotation*,Signature,Exceptions

# Aturan untuk just_audio (ExoPlayer) - ini bersifat umum dan mungkin perlu disesuaikan
# Berdasarkan praktik umum untuk ExoPlayer
-keep class com.google.android.exoplayer2.** { *; }
-keep interface com.google.android.exoplayer2.** { *; }

# Menjaga kelas-kelas dari just_audio
-keep class com.ryanheise.just_audio.** { *; }
-keep interface com.ryanheise.just_audio.** { *; }

# Jika Anda menggunakan fitur StreamAudioSource atau LockCachingAudioSource dari just_audio,
# yang menggunakan proxy localhost, pastikan kelas terkait tidak diobfuskasi jika ada masalah.
# Aturan yang lebih spesifik mungkin diperlukan jika ini penyebabnya.

# Untuk debugging, Anda bisa menambahkan ini untuk mendapatkan stack trace yang lebih baik
# Namun, hapus atau komentari untuk rilis final jika ukuran menjadi perhatian.
# -keepattributes SourceFile,LineNumberTable 

# Aturan dari missing_rules.txt untuk Play Core Library
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task 