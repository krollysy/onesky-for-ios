//
//  OneSkyApi.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 11.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import Siesta

/**
 OneSky API Manager.
 Implement service, where we can customize our request settings

 - Author:
 OneSky
 */

final class OneSkyAPI: Service {

    /// User id for user preferences
    internal var userID: Int? {
        didSet {
            if oldValue != userID {
                setupUserPreferences()
            }
        }
    }

    /// - MARK: Init

    init() {
        super.init(baseURL: Endpoints.baseURL)

        LogCategory.enabled = [.network, .observers]

        self.configure("**") { configurator in
            configurator.expirationTime = 5
            configurator.retryTime = 5
        }

        setupConfigures()
    }

    /// Setup response configures

    private func setupConfigures() {
        setupEnablesLocale()
    }

    /// Setup response of application configuration

    private func setupEnablesLocale() {
        self.configure(Endpoints
            .enableLocale
            .replacingOccurrences(of: "${appId}",
                                  with: Constants.appID)) {
                                    $0.headers["sdkVersion"] = "1.0"
                                    $0.pipeline[.parsing].removeTransformers()
        }
    }

    /// Setup response of user preferences

    private func setupUserPreferences() {
        guard let userId = userID else { return }
        self.configure(Endpoints
            .usersPreference
            .replacingOccurrences(of: "${appId}",
                                  with: Constants.appID)
            .replacingOccurrences(of: "${userId}",
                                  with: "\(userId)"), requestMethods: [.get]) {
                                    $0.pipeline.removeAllCaches()
                                    $0.pipeline[.parsing].removeTransformers()
                                    $0.pipeline[.model].add(ResponseUserPreferences())
        }
    }

}

