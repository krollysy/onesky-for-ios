//
//  PersistanceService.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 11.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

/**
 
 Persistance Service, here we store important data
 For example, it contains current user configuration
 
 - Author:
 OneSky
 
 */

class PersistanceService: NSObject {
    
    /// Main user defaults
    
    private let defaults: UserDefaults
    
    /// Main decoder
    
    private let decoder = BasicDecoder().configuratorDecoder
    
    override init() {
        self.defaults = UserDefaults.standard
    }
    
    /**
     
     Current application configurations
     Here we store data after fetching and saving
     
     - Author:
     OneSky
     
     */
    
    var currentConfiguration: Localization? {
        get {
            if let data = defaults.data(forKey: Constants.currentConfigurationID),
                let localization = try? decoder.decode(Localization.self,
                                                       from: data) {
                return localization
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                defaults.set(encoded, forKey: Constants.currentConfigurationID)
            } else {
                defaults.set(nil, forKey: Constants.currentConfigurationID)
            }
            defaults.synchronize()
        }
    }
    
    /**
     
     Current user configuration
     Here we store data of current LOGGINED user after fetching and saving
     
     - Author:
     OneSky
     
     */
    
    var currentUserSettings: Locales? {
        get {
            if let data = defaults.data(forKey: Constants.currentUserSettingsID),
                let locales = try? decoder.decode(Locales.self,
                                                  from: data) {
                return locales
            }
            return nil
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                defaults.set(encoded, forKey: Constants.currentUserSettingsID)
            } else {
                defaults.set(nil, forKey: Constants.currentUserSettingsID)
            }
            defaults.synchronize()
        }
    }

    /**

     Save current translated languages
     Saved languages have localization files

     - Author:
     OneSky

     */

    var translations: Translations? {
        get {
            if let data = defaults.value(forKey: Constants.localizedID) as? Translations {
                return data
            }
            return nil
        }
        set {
            defaults.set(newValue, forKey: Constants.localizedID)
            defaults.synchronize()
        }
    }
    
}
