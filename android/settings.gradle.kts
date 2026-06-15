pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

include(":app")

// GLOBAL LIFECYCLE FORCED OVERRIDE (AGP 9.0+)
// Yeh block ensure karega ki agora_rtc_engine jab create ho, toh uska compileSdk direct 36 set ho jaye
/*
gradle.settingsEvaluated {
    gradle.beforeProject {
        plugins.withId("com.android.library") {
            extensions.configure(com.android.build.api.dsl.LibraryExtension::class.java) {
                compileSdk = 36
            }
        }
    }
}*/
