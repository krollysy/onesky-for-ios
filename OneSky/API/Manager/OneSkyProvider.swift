//
//  OneSkyProvider.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 24.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import Siesta
import UIKit

/**
 OneSky Provider.
 A class is a provider that implements directly OneSkySource methods.
 Main OneSkySource helper.

 - Author:
 OneSky
 */

final class OneSkyProvider {

    /// Siesta Service
    
    var service = OneSkyAPI()
    
    // - MARK: Init

    init(with service: OneSkyAPI) { self.service = service }

    // -MARK: Functions

    /// Make request for fetching current application configuration

    func appConfiguration() -> Resource {
        return service.resource(Endpoints
            .enableLocale
            .replacingOccurrences(of: "${appId}",
                                  with: Constants.appID))

    }

    /// Make request for fetching user preferences

    func userPreferences(with userId: Int) -> Resource {
        return service.resource(Endpoints
            .usersPreference
            .replacingOccurrences(of: "${appId}",
                                  with: Constants.appID)
            .replacingOccurrences(of: "${userId}",
                                  with: "\(userId)"))
    }

    /// Make request for translating dynamic text

    func translateDynamicTexts() -> Resource {
        return service.resource(Endpoints
            .translateTexts
            .replacingOccurrences(of: "${appId}",
                                  with: Constants.appID))
    }

    /// Make request for translating static text

    func translateStaticTexts() -> Resource {
        return service.resource(Endpoints
            .translatyTextsStatically
            .replacingOccurrences(of: "${appId}",
                                  with: Constants.appID))
    }
    
}

