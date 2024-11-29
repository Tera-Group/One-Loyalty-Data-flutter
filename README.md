# one_loyalty_data_flutter

A Sample flutter plugin to use LoyaltySDK

---

# API Swagger

TBD

---

# Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/to/develop-plugins),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

# Setup for Android dependencies

1. Create a file with name `credentials.properties` in root project folder.
2. Contact DevOps to get credentials information below

```
repoName=xxxx
publishActor=xxxx
publishTokenGitHub=xxxx
gitlabProjectId=xxxx
publishTokenName=xxxx
publishToken=xxxx
```

##Setup for iOS dependencies

1. Run `./scripts/get_ios_framework.sh`
2. Edit `load xcframework from tag/branch` - script to fetch expected version

---

# Initial/Setup SDK

Before using the SDK, setup it with your application-specific configuration.

### iOS

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

### Android

```
...
```

---

# Update access token

After login we need to set access token for SDK

### iOS

```swift
OneLoyalty.shared.setToken(token: "access token")
```

### android

`...`

---

# Functions

## Get user loyalty

### ios

```swift
OneLoyalty.shared.loyaltyService.getUser { user, error in }
```

### android

```adnroid
...
```

---

# Tracking Event

### iOS

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

### android

```
...
```

---
