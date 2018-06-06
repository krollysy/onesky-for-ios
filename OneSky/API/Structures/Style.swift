//
//  Style.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 15.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

/**
 Enum for open controller style

 - Author:
 OneSky

 */


public enum OpenStyle {

    /// push controller style

    case push

    /// present controller style

    case present
    
}


/// custom typealias

typealias LocalizationHandler   = ((Localization) -> Void)

typealias UserSettingsHandler   = ((UserSettings) -> Void)

typealias UserSettingsOptionalHandler = ((UserSettings?, Locales?) -> Void)

typealias LanguageKey = String

typealias Language = Dictionary<String, String>

typealias Translations = Dictionary<LanguageKey, Language>
