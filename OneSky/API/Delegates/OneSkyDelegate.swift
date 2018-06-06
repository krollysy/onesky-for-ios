//
//  OneSkyDelegate.swift
//  OneSky
//
//  Created by Daniil Vorobyev on 10.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import UIKit

/**
 OneSky delegate. Returns parsed data from server

 - Author:
 OneSky

 - Important:
    Should be implemented in localization class
 */

public protocol OneSkyDelegate: class {
    
    /// Return enabled locales from server

    func didReceive(locales enabledLocales: Localization)

    /// Return current user settings

    func didReceive(userSettings settings: UserSettings)

    /// Return success POST response about sending user preferences

    func didUploadUserPreference(with id: Int)

    /// Return success translated text action

    func didTranslateText(with languageId: String)

}

/// Make it optional

extension OneSkyDelegate {

    public func didReceive(locales enabledLocales: Localization) {}

    public func didReceive(userSettings settings: UserSettings) {}

    public func didUploadUserPreference(with id: Int) {}

    public func didTranslateText(with languageId: String) {}

}

/**
 Main manager protocol

 - Author:
 OneSky
 */

public protocol OneSkyManager: class {

    /**
     Delegate which implements 'return' API responses.

     - Author:
     OneSky
     */
    weak var delegate: OneSkyDelegate? { get set }

    /**
     Get current language Code

     - Author:
     OneSky
     */

    var currentLanguageCode: String? { get }

    /**
     Get current User locale

     - Author:
     OneSky
     */
    var currentLocale: Locales? { get }

    /**
        Need for fetching available locales.
        Fetching locales in current application

        - Author:
            OneSky
     */

    func getAvailableLocales()

    /**
     Need for fetching user settings

     - parameters:
        - userId: user identificator

     - Author:
     OneSky
     */

    func getUserPreferences(with userId: Int)

    /**
     Need for sending user settings

     - parameters:
        - userId: user identificator
        - userSettings: 'UserPreferences' object

     - Author:
     OneSky
     */

    func sendUserSettings(with userId: Int, name: String?, email: String?, values: [String])

    /**
     Open our custom view controller with locale choice

     - parameters:
        - viewController: your viewController FROM which new controler will be open
        - style: opening style: 'push' or 'present'

     - Author:
     OneSky
     */

    func open(from viewController: UIViewController, style: OpenStyle)

    /**
     Open our custom view controller with locale choice using user id

     - parameters:
        - viewController: your viewController FROM which new controler will be open
        - style: opening style: 'push' or 'present'

     - Author:
     OneSky
     */

    func open(from viewController: UIViewController, style: OpenStyle, userId: Int)

    /**
     Open our custom view controller with locale choice using user id

     - parameters:
        - viewController: your viewController FROM which new controler will be open
        - style: opening style: 'push' or 'present'

     - Author:
     OneSky

     - Important: Call it to Open Settings controller without account controller
     */

    func openSettings(from viewController: UIViewController, style: OpenStyle)

    /**
     Open our custom view controller with locale choice using user id

     - parameters:
        - viewController: your viewController FROM which new controler will be open
        - style: opening style: 'push' or 'present'
        - userId: User ID

     - Author:
     OneSky

     - Important: Call it to Open Settings controller without account controller
     */

    func openSettings(from viewController: UIViewController, style: OpenStyle, userId: Int)

    /**
     Use this for translation text. Just call it with parameters and it will translate the text.

     - parameters:
        - sourceLanguageKey: Your BASE language id, language, which have your base localizable.strings
        - targetLanguageId: Language which you want to translate
        - localizableFileName: Your localizable file name

     - Author:
     OneSky

     - Important: Translate dynamic text!
     */

    func translate(sourceLanguageKey: String, targetLanguageId: String, localizableFileName: String)

    /**
     Use this for translation text. Just call it with parameters and it will translate the text.

     - parameters:
        - localeId: Language you want to translate ('ru' = Russian, 'en' = English)

     - Author:
     OneSky

     - Important: Translate static text!
     */

    func translate(localeId: String)

}
