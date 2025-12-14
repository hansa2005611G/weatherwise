plugins {
    id("com. android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.weatherwise"
    compileSdk = 34  // ✅ Update this

    compileOptions {
        // ✅ ADD THESE LINES
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    defaultConfig {
        applicationId = "com.example.weatherwise"
        minSdk = 21
        targetSdk = 34  // ✅ Update this
        versionCode = 1
        versionName = "1.0.0"
        
        // ✅ ADD THIS LINE
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
   
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs: 2.0.4")
}