//
//  SettingsControllerDataManager.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 15.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import UIKit

/**
 Settings controller data manager
 Implement UITableViewDataSource and UITableViewDelegate methods

 - Author:
 OneSky
 */

final class SettingsControllerDataManager: NSObject {

    fileprivate var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(SelectCell.self,
                               forCellReuseIdentifier: Constants.selectCellIdentifier)

            tableView.reloadData()
        }
    }

    /// Persistance Service

    fileprivate let persistance         = PersistanceService()

    /// Current localization configurators

    fileprivate var localization        : Localization!

    /// Current user Preference. Actually need to check is it logined user or not

    fileprivate var userPreference      : UserSettings?

    /// Current user locale from 'userLocales'

    fileprivate var userCurrent         : Locales?

    /// User's locales

    fileprivate var userLocales         : [Locales] = []

    /// Configure with tableView and localization

    func configure(_ tableView: UITableView, localization: Localization) {
        self.localization = localization
        if let def = localization.app?.selectors?.first?.defaultValue,
            let keys = localization.app?.selectors?.first?.locales {
            if let current = persistance.currentUserSettings {
                self.userCurrent = current
            } else if let locale = keys.filter({ $0?.id == def }).first {
                self.userCurrent = locale
            }
            keys.forEach { key in
                guard let unwrappedKey = key else { return }
                userLocales.append(unwrappedKey)
            }
        }
        self.tableView = tableView
    }

    /// Configure with tableView and localization

    func configure(_ tableView: UITableView, localization: Localization, userSettings: UserSettings) {
        self.localization = localization
        self.userPreference = userSettings

        /// fetching user location
        if let keys = userSettings.app?.user?.preferences?.first?.values,
            let locales = localization.app?.selectors?.first?.locales {
            guard let unwrappedLocales = locales.filter({ $0 != nil }) as? [Locales] else { return }
            for (index, key) in keys.enumerated() {
                if let locale = unwrappedLocales.filter({ ($0.id ?? "") == key }).first {
                    if index == 0 { userCurrent = locale } // first element is current
                    userLocales.append(locale)
                }
            }
        }
        self.tableView = tableView
    }

    /// Request current user preferences

    func requestCurrentUserPrefs(complition: @escaping UserSettingsOptionalHandler) {
        if let findIndex: Int = userPreference?.app?.user?.preferences?.first?.values?.index(where: { $0 == userCurrent?.id }) {
            /// force unwrap coz i know that freferences have at least one element
            userPreference?.app?.user?.preferences![0].values?.rearrange(from: findIndex, to: 0)
            complition(userPreference, userCurrent)
        }
        complition(nil, userCurrent)
    }

}

// - MARK: UITableViewDataSource

extension SettingsControllerDataManager: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userLocales.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.selectCellIdentifier,
                                                       for: indexPath) as? SelectCell else { return UITableViewCell() }
        guard let def = userCurrent,
            let defId = def.id,
            let name = userLocales[indexPath.row].displayName,
            let short = userLocales[indexPath.row].id else { return UITableViewCell() }
        let model = SelectCellViewModel(language: name,
                                        isCurrent: short == defId)
        model.configure(cell: cell)
        return cell
    }

}

// - MARK: UITableViewDelegate

extension SettingsControllerDataManager: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.userCurrent = userLocales[indexPath.row]
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

}
