<h1 align="center">
    One Loyalty Data Flutter
</h1>

<p align="center">A Sample flutter plugin to use LoyaltySDK</p>

<p align="center">
    <a href="https://github.com/Tera-Group/One-Loyalty-Data-Android/packages/2327215">
        <img src="https://img.shields.io/badge/package-0.1.5-blue?logo=github" alt="Latest github package version." />
    </a>
<p align="center">

<h3 align="center">
  <a href="https://tera-group.github.io/One-Loyalty-Data-flutter/index.html">Document</a>
</h3>

## Contents

- [Note](#note)
- [Getting Started](#getting-started)
- [Initial SDK](#initial-sdk)
- [Common Functions](#common-functions)
- [Loyalty Functions](#loyalty-functions)

### Note

- It is necessary to call `setToken` (accessToken) every time acquire token.
- Call `registerProfile` after login or whenever the profile changes.
- Call `clearToken` after logout.
- You can `registerAuthenticatorListener` to `setToken` again.

---

### Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

#### Setup for Android dependencies

1. Create a file with name `credentials.properties` in root project folder.
2. Contact DevOps to get credentials information below

```
publishActor=####
publishTokenGitHub=####
```

**Note:** if use directly android sdk without plugin you need import android sdk on gradle

```
 maven {
    url "https://maven.pkg.github.com/Tera-Group/One-Loyalty-Data-Android"
    credentials {
        username = credentialProps["publishActor"]
        password = credentialProps["publishTokenGitHub"]
    }
}
```

```
dependencies {
    ...
    implementation "io.teragroup:oneloyalty-android:0.1.0"
}
```

#### Setup for iOS dependencies

1. Run `./scripts/get_ios_framework.sh`
2. Edit `load xcframework from tag/branch` - script to fetch expected version

---

## Common Functions

### Initial SDK

Before using the SDK, setup it with your application-specific configuration.

#### iOS

```swift
let config: Config = .init(
    apiKey: "Your api key",
    clientId: "Your client id",
    apiClientIdKey: "Your app client key",
    defaultConfig: nil,
    requestTimeout: 10_000,
    certificatePinning: []
)

let appContext: AppContext = .init(
    appInformation: .init(
        build: "App build number",
        bundleId: "app bundle",
        name: "App Name",
        version: "App version"
    ),
    device: .init(
        id: "a UUID that may be used to uniquely identify the device",
        name: "device name",
        model: "device model",
        timezone: "device time zone",
        language: "device language",
        os: "OS name",
        osVersion: "OS version",
        type: "device type",
        width: "device screen width",
        height: "device screen width"
    ),
    sdk: nil // LoyaltySDK version info - optional
)

OneLoyalty.shared.setup(
    config: config,
    appContext: appContext,
    keychainServiceName: "your keychain service name", // optional
    keychainAccessGroup: "your keychain access group", // optional
    platform: .ios
) { result, error in }
```

#### Android

```kotlin
val config = Config(
    apiKey = "Your api key",
    clientId = "Your client id",
    apiClientIdKey = "Your app client key",
    defaultConfig = nil,
    requestTimeout = 10_000
)

val appContext = AppContext(
    app = AppInformation(
        build = "App build number",
        bundleId = "app bundle",
        name = "App Name",
        version = "App version"
    ),
    device = LoyaltyDevice(
        id = "a UUID that may be used to uniquely identify the device",
        name = "device name",
        model = "device model",
        timezone = "device time zone",
        language = "device language",
        os = "OS name",
        osVersion = "OS version",
        type = "device type",
        width = "device screen width",
        height = "device screen width"
    ),
    sdk = null // LoyaltySDK version info - optional
)

OneLoyalty.setup(
    context =  "Context of app",
    config = config,
    appContext = appContext
)
```

### Update access token

After login we need to set access token for SDK

#### iOS

```swift
OneLoyalty.shared.setToken(token: "access token")
```

#### android

```kotlin
OneLoyalty.setToken(token = "access token")
```

---

## Loyalty Functions

### Get user loyalty

#### ios

```swift
OneLoyalty.shared.loyaltyService.getUser { user, error in }
```

#### android

```kotlin
val user = OneLoyalty.loyaltyService.getUser()
```

### [Other function](https://tera-group.github.io/One-Loyalty-Data-flutter/oneloyalty/com.teragroup.io.onappdata.services/-loyalty-service/index.html) (Use same above)

---

### [Tracking Event](https://tera-group.github.io/One-Loyalty-Data-flutter/oneloyalty/[root]/-on-tracking/index.html)

#### iOS

1. Tracking event

```swift
OnTracking.shared.trackEvent(
    name: String, // event name
    properties: [String: Any], // event name // optional
    forceCleanQueue: Bool // to send event immediately
)
```

2. Tracking view

```swift
OnTracking.shared.trackView(
    name: String, // view/screen name
    properties: [String: Any], // optional
)
```

#### android

```kotlin
OnTracking.trackEvent(
    name = "tracking name", // event name
    properties = mapOf("key" to "value"), // event name // optional
    forceCleanQueue = true // to send event immediately
)
```

2. Tracking view

```kotlin
OnTracking.trackView(
    name = "tracking name", // view/screen name
    properties = mapOf("key" to "value"), // optional
)
```
