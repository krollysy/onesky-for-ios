//
//  Endpoints.swift
//  OneSky
//
//  Created by Daniil Vorobyev on 10.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

/// Endpoints for app
///
class Endpoints {

    /// BaseURL

    static let baseURL = "https://app-api.oneskyhq-stag.com/v1/"//"https://app-api-mock.oneskyhq-dev.com/v1/"

    /// Get enable locale of an app
    
    static let enableLocale = "apps/${appId}"

    /// User preferences URL

    static let usersPreference = "apps/${appId}/users/${userId}"

    /// Translate dynamically texts URL

    static let translateTexts = "apps/${appId}/translations"

    /// Translate statically texts URL

    static let translatyTextsStatically = "apps/${appId}/string-files"

}
