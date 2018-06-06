//
//  OneSky.swift
//  OneSky
//
//  Created by Daniil Vorobyev on 10.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import Siesta
import UIKit

/**
 Main manager for fetching app configure
 Here we have part of networking

 - Author:
 OneSky
 */

final public class OneSkySource: NSObject {

    /// Delegate

    public weak var delegate: OneSkyDelegate?

    /// Provider

    var provider: OneSkyProvider!

    /// Return current user language code

    public var currentLanguageCode: String? {
        get {
            return Locale.current.languageCode
        }
    }

    /// Get current User locale

    public var currentLocale: Locales? {
        get {
            return persistance.currentUserSettings
        }
    }

    /// Settings ViewController for presenting our custom controller

    var settingsController: SettingsController!

    /// Account ViewController for presenting our custom controller

    var accountController: AccountViewController!

    /// localization handle

    var localizationHandle: LocalizationHandler?

    /// user settings handle

    var userSettingsHandle: UserSettingsHandler?

    /// Our main service

    let service = OneSkyAPI()

    /// Ably socket service

    var ably: Ably = Ably()

    /// Persistance service

    let persistance = PersistanceService()

    // - MARK: init

    public override init() {
        super.init()
        ably = Ably()
        ably.connect()
        provider = OneSkyProvider(with: service)
    }

}

// -MARK: OneSkyManager
//

extension OneSkySource: OneSkyManager {

    /// Delegate method for user preferences

    public func getUserPreferences(with userId: Int) {
        service.userID = userId
        provider.userPreferences(with: userId).removeObservers(ownedBy: self)
        provider.userPreferences(with: userId).addObserver(self)
        provider.userPreferences(with: userId).load()
    }

    /// Delegate method for getting Available locales

    public func getAvailableLocales() {

        /// Check internet connection
        guard Reachability.isConnectedToNetwork() else {
            guard let localization = LocalizationManager.shared.checkLocalizationState() else { return }
            self.receiving(localization: localization)
            return
        }
        provider.appConfiguration().removeObservers(ownedBy: self)
        provider.appConfiguration()
            .withParam("platformId", "ios")
            .request(.get)
            .onSuccess { [weak self] entity in
                guard let `self` = self else { return }
                let data = entity.content as? Data
                do {
                    let decodable = try BasicDecoder().configuratorDecoder.decode(Localization.self,
                                                                                  from:  data ?? Data())
                    self.receiving(localization: decodable)
                } catch let error {
                    debugPrint("error on decode Localization: \(error)")
                }
            }
            .onFailure { [weak self] failure in
                guard let `self` = self,
                        let localization = LocalizationManager.shared.checkLocalizationState() else { return }
                self.receiving(localization: localization)
            }
    }

    /// Send request to post user settings

    public func sendUserSettings(with userId: Int, name: String?, email: String?, values: [String]) {
        service.userID = userId
        guard let paramsDict = RequestBuilder
            .buildUserParameters(name, email: email, values: values) else { return }
        provider.userPreferences(with: userId).removeObservers(ownedBy: self)
        provider.userPreferences(with: userId).request(.post,
                                                       json: paramsDict).onSuccess { response in
                                                        self.delegate?.didUploadUserPreference(with: userId)
        }
    }

    /// Use it for translation your text
    /// Dynamic text!

    public func translate(sourceLanguageKey: String,
                          targetLanguageId: String,
                          localizableFileName: String) {
        guard let localizationValues = LocalizationManager.shared
            .read(from: localizableFileName,
                  sourceLanguage: sourceLanguageKey) else { return }
        let buildParameter = RequestBuilder.buildParameters(with: localizationValues,
                                                            sourceLanguage: sourceLanguageKey,
                                                            targetLanguage: targetLanguageId)
        provider.translateDynamicTexts().request(.post,
                                                 json: buildParameter).onSuccess { [weak self] response in
                                                    guard let `self` = self else { return }
        }
    }

    /// Use it for translation your text
    /// Static text!

    public func translate(localeId: String) {

        /// Check internet connection
        guard Reachability.isConnectedToNetwork() else {
            guard let translated = LocalizationManager.shared.checkTranslations(with: localeId) else { return }
            self.receiving(translatedString: translated, languageId: localeId)
            return
        }

        provider.translateStaticTexts()
            .withParam("languageId", localeId)
            .withParam("fileFormat", "ios-strings")
            .request(.get)
            .onSuccess { [weak self] entity in
                guard let `self` = self else { return }
                if let string = entity.content as? String {
                    self.receiving(translatedString: string, languageId: localeId)
                }
            }
            .onFailure { [weak self] failure in
                guard let `self` = self,
                        let translated = LocalizationManager.shared.checkTranslations(with: localeId) else { return }
                self.receiving(translatedString: translated, languageId: localeId)
            }
    }

    /// Delegate method for openning view controller without user id

    public func open(from viewController: UIViewController, style: OpenStyle) {
        accountController = AccountViewController()
        accountController.delegate = self
        accountController.presentStyle = style
        self.present(fromVC: viewController, toVC: accountController, style: style)
    }

    /// Delegate method for openning view controller with user id

    public func open(from viewController: UIViewController, style: OpenStyle, userId: Int) {
        accountController = AccountViewController()
        accountController.delegate = self
        accountController.presentStyle = style
        accountController.userId = userId
        self.present(fromVC: viewController, toVC: accountController, style: style)
    }

}

// - MARK: Presentation File
//

extension OneSkySource {

    /// Push controller class

    func present(fromVC: UIViewController, toVC: UIViewController, style: OpenStyle) {
        switch style {
        case .push:
            fromVC.navigationController?.pushViewController(toVC,
                                                            animated: true)
        case .present:
            fromVC.present(toVC,
                           animated: true,
                           completion: nil)
        }
    }

    /// Function receiving localization data

    func receiving(localization: Localization) {
        self.persistance.currentConfiguration = localization
        self.delegate?.didReceive(locales: localization)
        self.localizationHandle?(localization)
        self.localizationHandle = nil
    }

    /// Function receiving translation data

    func receiving(translatedString: String, languageId: String) {
        let locale = Locales(id: languageId,
                              displayName: nil,
                              platformLocale: nil,
                              additionalProperties: nil)
        if let utf = (translatedString.cString(using: .utf8)),
            let decodable = String(utf8String: utf) {
            LocalizationManager.shared.setup(with: decodable, locale: locale) { [weak self] in
                guard let `self` = self, let id = locale.id else { return }
                self.delegate?.didTranslateText(with: id)
            }
        }
    }

}

// - MARK: Extension for help functions
//

extension OneSkySource {

    /// Delegate method for openning view controller without user id

    public func openSettings(from viewController: UIViewController, style: OpenStyle) {
        requestLocalization { [weak self] localization in
            guard let `self` = self else { return }
            self.settingsController = SettingsController()
            self.settingsController?.configure(with: localization, delegate: self)
            self.present(fromVC: viewController, toVC: self.settingsController, style: style)
        }
    }

    /// Delegate method for openning view controller with user id

    public func openSettings(from viewController: UIViewController, style: OpenStyle, userId: Int) {
        requestUserSettings(id: userId) { [weak self] userSettings in
            guard let `self` = self else { return }
            self.requestLocalization { [weak self] localization in
                guard let `self` = self else { return }
                self.settingsController = SettingsController()
                self.settingsController?.configure(with: localization,
                                                   and: userSettings,
                                                   delegate: self,
                                                   id: userId)
                self.present(fromVC: viewController, toVC: self.settingsController, style: style)
            }
        }
    }

    /// Completion handler for receiving localization

    func requestLocalization(completion: @escaping LocalizationHandler) {
        localizationHandle = completion
        self.getAvailableLocales()
    }

    /// Completion handler for receiving user settings

    func requestUserSettings(id: Int, completion: @escaping UserSettingsHandler) {
        userSettingsHandle = completion
        self.getUserPreferences(with: id)
    }

}

// -MARK: ResourceObserver delegate
//

extension OneSkySource: ResourceObserver {

    /// Resource observer protocol function
    /// Called when receive notification from API Service

    public func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        if let userPrefs: UserSettings = resource.typedContent() {
            /// This should fix trouble with siesta observers
            if userPrefs.app?.user == nil {
                guard case .newData = event else { return }
            }
            self.delegate?.didReceive(userSettings: userPrefs)
            userSettingsHandle?(userPrefs)
            userSettingsHandle = nil
        }
    }

}
