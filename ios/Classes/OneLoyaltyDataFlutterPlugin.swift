import Flutter
import UIKit
import oneloyalty

public class OneLoyaltyDataFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "one_loyalty_data_flutter", binaryMessenger: registrar.messenger())
    let instance = OneLoyaltyDataFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setupSDK":
        setupSDK(call, result)
    case "getListMission":
         getListMission(call, result)
    case "getUser":
         getUser(call, result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

private extension OneLoyaltyDataFlutterPlugin {
    func setupSDK(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard
            let arguments = call.arguments as? [String: Any],
            let apiKey = arguments["apiKey"] as? String,
            let clientId = arguments["clientId"] as? String,
            let apiTokenKey = arguments["apiTokenKey"] as? String,
            let apiClientIdKey = arguments["apiClientIdKey"] as? String
        else {
            result(FlutterError(code: "SDK Setup error", message: "invalid input", details: nil))
                return
        }

        let config: Config = .init(
            apiKey: apiKey,
            clientId: clientId,
            apiClientIdKey: apiTokenKey,
            defaultConfig: nil,
            requestTimeout: 10000,
            certificatePinning: []
        )

        let buildNumber: String = ""//Bundle.main.get("CFBundleVersion") ?? ""
        let versionNumber: String = ""//Bundle.main.get("CFBundleShortVersionString") ?? ""
        let appName: String = ""//Bundle.main.get("CFBundleDisplayName") ?? Bundle.main.get(kCFBundleNameKey as String) ?? "iOS Loyalty SDK Sample"

        let appContext: AppContext = .init(
            appInformation: .init(
                build: buildNumber,
                bundleId: Bundle.main.bundleIdentifier ?? "",
                name: appName,
                version: versionNumber
            ),
            sdk: .init(
                name: "",
                version: ""
            ),
            LoyaltyDevice: .init(
                id: UIDevice.current.identifierForVendor!.uuidString,
                name: UIDevice.current.name,
                model: UIDevice.current.model,
                timezone: TimeZone.current.identifier,
                language: Locale.currentLanguageCode,
                os: UIDevice.current.systemName,
                osVersion: UIDevice.current.systemVersion,
                type: .phone,
                width: "\(UIScreen.main.bounds.width)",
                height: "\(UIScreen.main.bounds.height)"
            )
        )

        OneLoyalty.shared.setup(
            config: config,
            appContext: appContext,
            keychainServiceName: "io.teragroup.loyaltyExample",
            keychainAccessGroup: nil,
            platform: .ios
        ) { _, error in
            if let error {
                result(FlutterError(code: "SDK Setup error", message: error.localizedDescription, details: nil))
            } else {
                result(true)
            }
        }
    }

    func getListMission(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneLoyalty.shared.loyaltyService.getListMission { missions, error in
            if let error {
                result(FlutterError(code: "get missions error", message: error.localizedDescription, details: nil))
            } else {
                let data: [Mission] = missions ?? []
                let json = Mission.companion.jsonStringFrom(list: data)
                result(json)
            }
        }
    }

    func getUser(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        OneLoyalty.shared.loyaltyService.getUser { user, error in
            if let error {
                result(FlutterError(code: "get user error", message: error.localizedDescription, details: nil))
            } else if let user {
                let json = user.toJsonString()
                result(json)
            } else {
                result(FlutterError(code: "get user error", message: "user not found", details: nil))
            }
        }
    }
 }

 extension Locale {
     static var currentLanguageCode: String? {
         return Locale.current.languageId
     }

     static var deviceLocales: [Locale] {
         return UserDefaults.standard.stringArray(forKey: "AppleLanguages")?.map({ Locale(identifier: $0) }) ?? []
     }

     /// The locale of the *device* itself, not to be confused with `Locale.current` which returns the *app locale*
     /// depending on device settings
     static var currentDeviceLocale: Locale? {
         return deviceLocales.first
     }

     /// The current language of the *device* itself, which might differ form `Locale.current.languageCode`
     static var deviceLanguageCode: String? {
         return currentDeviceLocale?.languageId
     }

     var languageId: String? {
         if #available(iOS 16.0, *) {
             return language.languageCode?.identifier
         } else {
             return languageCode
         }
     }
 }

 extension Bundle {
     var appName: String { (object(forInfoDictionaryKey: "CFBundleDisplayName") as? String) ?? ((object(forInfoDictionaryKey: "CFBundleName") as? String) ?? "Onlala") }

     var isDevApp: Bool {
         bundleIdentifier?.contains(".dev") ?? false
     }

     func get<T>(_ infoKey: String) -> T? {
         return object(forInfoDictionaryKey: infoKey) as? T
     }

     func unsafeGet<T>(_ infoKey: String) -> T! {
         return object(forInfoDictionaryKey: infoKey) as? T
     }

     func unsafeGet(_ infoKey: String) -> String! {
         return (object(forInfoDictionaryKey: infoKey) as? String)?.replacingOccurrences(of: "\\", with: "")
     }
 }