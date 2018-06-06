//
//  RequestBuilder.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 14.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

/**
 Class - helper for building requests
 Implement building parameters for any useful request in this framework

 - Author:
 OneSky

 */

final class RequestBuilder {

    /// Build parameters for user settings

    static func buildUserParameters(_ name: String?, email: String?, values: [String]) -> [String: Any]? {
        let preferences = Preferences(type: "display-language",
                                      values: values)
        let settings = UserPreferences(email: email, name: name, preferences: [preferences])
        let user = UserSettings(app: UserData(user: settings))
        var parameter: [String: Any] = [:]
        if let name = user.app?.user?.name,
            let email = user.app?.user?.email {
            parameter["name"] = name
            parameter["email"] = email
        }

        guard let userPrefs = user.app?.user?.preferences?.first else { return nil }

        var preference: [String: Any] = [:]
        preference["type"] = userPrefs.type ?? ""

        var buildValues: [String] = []
        guard let values = userPrefs.values else { return nil }
        values.forEach { buildValues.append($0) }
        preference["values"] = buildValues

        parameter["preference"] = preference

        return parameter
    }

    /// Build parameters for translated dynamic text

    static func buildParameters(with sourceText: [String]?,
                                sourceLanguage: String,
                                targetLanguage: String) -> [String: Any] {
        var parameters: [String: Any] = [:]
        parameters["sourceLanguageId"] = sourceLanguage
        parameters["targetLanguageId"] = targetLanguage
        if let sources = sourceText {
            parameters["sourceText"] = sources
        }
        return parameters
    }

}
