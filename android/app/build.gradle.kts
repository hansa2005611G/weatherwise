plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.weatherwise"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.weatherwise"
        minSdk = flutter.minSdkVersion
        targetSdk = 36

        versionCode = 1
        versionName = "1.0"

        multiDexEnabled = true
    }

    compileOptions {
        // ✅ REQUIRED for flutter_local_notifications
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    sourceSets["main"].java.srcDir("src/main/kotlin")

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }

        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Material Components (required for theme)
    implementation("com.google.android.material:material:1.11.0")

    // ✅ REQUIRED for Java 8+ APIs used by plugins
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
