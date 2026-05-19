import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}


val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

val flutterVersionCode = localProperties.getProperty("flutter.versionCode") ?: "1"
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0.0"

android {
    namespace = "mobile.template"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = "21"
    }

    sourceSets {
        getByName("main").java.srcDirs("core/main/common")
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        minSdk = 28
        targetSdk = 36
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
        // Enabling multidex support.
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            // TODO: Add your own signing http for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    flavorDimensions += "flavors"
    productFlavors {
        create("free") {
            dimension = "flavors"
            resValue("string", "app_name", "Free App")
            applicationIdSuffix = ".free"
            versionNameSuffix = "-free"
        }
        create("uat") {
            dimension = "flavors"
            resValue("string", "app_name", "Uat App")
            applicationIdSuffix = ".uat"
            versionNameSuffix = "-uat"
        }
        create("prod") {
            dimension = "flavors"
            applicationId = "mobile.template"
            resValue("string", "app_name", "Prod App")
        }
    }
    
    lint {
        checkReleaseBuilds = false
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.constraintlayout:constraintlayout:2.2.1")
    implementation("com.airbnb.android:lottie:6.7.1")
}
