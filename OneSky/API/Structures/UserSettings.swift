//
//  UserSettings.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 14.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

/**
 Structure for decoding user preferences
 Include preferences, type, values

 - parameters:
    - user:  Contain main data
 - Author:
    OneSky

 - Important: Contains base user configuration
 */

public struct UserSettings: Codable {
    public var app    : UserData?
}

public struct UserData: Codable {
    public var user   : UserPreferences?
}

/// Simple user preferences

public struct UserPreferences: Codable {
    public let email       : String?
    public let name        : String?
    public var preferences : [Preferences]?
}

/// Contains preferences

public struct Preferences: Codable {
    public let type    : String?
    public var values  : [String]?
}
