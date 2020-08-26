//
//  Environment.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica. All rights reserved.
//

import Foundation
import UIKit

public enum EnvironmentType: String, CaseIterable {
    case prod
    case staging
    case dev
}

// List of keys that can be used to override settings in a project using multiple environments
private enum EnvironmentKeys: String {
    case serverBaseUrlString = "envServerBaseUrlString"
    case networkLoggingEnabled = "envNetworkLoggingEnabled"
    case debugLoggingEnabled = "envDebugLoggingEnabled"
}

// Stores defaults for different environments
private struct EnvironmentDefaults {
    let serverBaseUrlString: String
    let networkLoggingEnabled: Bool
    let debugLoggingEnabled: Bool
    let allowableOverrides: [EnvironmentKeys]

    static func defaults(forEnvironmentType environmentType: EnvironmentType) -> EnvironmentDefaults {
        switch environmentType {
        case .prod:
            return EnvironmentDefaults.prod
        case .staging:
            return EnvironmentDefaults.staging
        case .dev:
            return EnvironmentDefaults.dev
        }
    }

    static let prod = EnvironmentDefaults(
        serverBaseUrlString: "https://rss.itunes.apple.com/",
        networkLoggingEnabled: false,
        debugLoggingEnabled: false,
        allowableOverrides: [.networkLoggingEnabled, .debugLoggingEnabled]
    )

    static let staging = EnvironmentDefaults(
        serverBaseUrlString: "https://rss.itunes.apple.com/",
        networkLoggingEnabled: false,
        debugLoggingEnabled: false,
        allowableOverrides: [.networkLoggingEnabled, .debugLoggingEnabled]
    )

    static let dev = EnvironmentDefaults(
        serverBaseUrlString: "https://rss.itunes.apple.com/",
        networkLoggingEnabled: true,
        debugLoggingEnabled: true,
        allowableOverrides: [.serverBaseUrlString, .networkLoggingEnabled, .debugLoggingEnabled]
    )

}

// Wrapper to get settings and allow for overrides
class Environment: NSObject {

    static let current = Environment()

    public let environmentType: EnvironmentType = {
        #if ENV_DEV
        let defaultEnv: EnvironmentType = .dev
        return defaultEnv
        #else
        return .prod
        #endif
    }()

    public static func setEnvironmentType(to environmentType: EnvironmentType) {
        #if ENV_DEV
        UserDefaults.standard.set(environmentType.rawValue, forKey: kUserDefaultEnvironment)
        exit(0)
        #endif
    }

    lazy private var defaults: EnvironmentDefaults = {
        EnvironmentDefaults.defaults(forEnvironmentType: self.environmentType)
    }()

    var serverBaseUrlString: String {
        return override(key: .serverBaseUrlString) ?? defaults.serverBaseUrlString
    }

    var networkLoggingEnabled: Bool {
        return override(key: .networkLoggingEnabled) ?? defaults.networkLoggingEnabled
    }

    var debugLoggingEnabled: Bool {
        return override(key: .debugLoggingEnabled) ?? defaults.debugLoggingEnabled
    }

    private func override<T>(key: EnvironmentKeys) -> T? {

        guard defaults.allowableOverrides.contains(key) else {
            return nil
        }

        return UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
}
