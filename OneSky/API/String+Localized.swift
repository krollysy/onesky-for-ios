//
//  String+Localized.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 18.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

public extension String {

    /// Our custom localized file

    var localized: String {
        let persistance = PersistanceService()
        if let _ = persistance.currentUserSettings?.id {} else {
            let local = Locale.current.languageCode ?? ""
            persistance.currentUserSettings = Locales(id: local,
                                                      displayName: "",
                                                      platformLocale: "",
                                                      additionalProperties: nil)
        }

        let lang = persistance.currentUserSettings?.id
        guard let langId = lang else { return "" }
        do {
            guard let _ = try LocalizationManager.shared.bundle(with: langId) else { return NSLocalizedString(self, comment: "") }
            let newBundle = Bundle(url: LocalizationManager.shared.bundlePath.appendingPathComponent("\(langId).lproj"))
            guard let bundle = newBundle else { return  "" }
            let localized = NSLocalizedString(self, tableName: LocalizationManager.tableName, bundle: bundle, comment: "")
            if localized.isEmpty {
                return NSLocalizedString(self, comment: "")
            }
            return localized
        } catch let error {
            debugPrint(error)
        }
        return NSLocalizedString(self, comment: "")
    }

}

extension String {

    var localLocalized: String {
        let persistance = PersistanceService()
        if let _ = persistance.currentUserSettings?.id {} else {
            let local = Locale.current.languageCode ?? ""
            persistance.currentUserSettings = Locales(id: local,
                                                      displayName: "",
                                                      platformLocale: "",
                                                      additionalProperties: nil)
        }

        let lang = persistance.currentUserSettings?.id
        guard let langId = lang else { return "" }
        return PrivateLocalization.translate(type: LocalizationType(rawValue: langId) ?? .en,
                                             key: LocalizationKey(rawValue: self) ?? .languageDisplayed) ?? ""
    }

}
