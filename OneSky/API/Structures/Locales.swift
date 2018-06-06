//
//  Locales.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 11.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

/**
 Structure for decoding available locales
 Include locale, default value, theme, type

 - parameters:
    - app: Have main data
 - Author:
    OneSky

 - Important: Contains base configure
 */

public struct Localization: Codable {
    public let app:    Selector?
}

public struct Selector: Codable {
    public let selectors   : [Selectors]?
}

/// Selectors which contain main data

public struct Selectors: Codable {
    public let type                        : String?
    public let htmlTag                     : String?
    public let theme                       : String?
    public let options                     : [String]?
    public let defaultValue                : String?
    public let isWebTransitionReloadPage   : Bool?
    public let respectOrder                : [String]?
    public let webTransitionMappings       : [TransitionMappings]?
    public let locales                     : [Locales?]?
}

/// Transition mappings

public struct TransitionMappings: Codable {
    public let localeId    : String?
    public let location    : String?
}

/// Struct which contains languages

public struct Locales: Codable {
    public let id                      : String?
    public let displayName             : String?
    public let platformLocale          : String?
    public let additionalProperties    : [AdditionalProperties]?
}

/// Additional properties

public struct AdditionalProperties: Codable {
    public let key     : String?
    public let value   : String?
}

