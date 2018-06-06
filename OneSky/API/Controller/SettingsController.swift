
//
//  SettingsController.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 15.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import UIKit

/**
 View controller for realization of language screen.
 Contains label, tableView with available locales and button for setting
 You can use it to select locale for user or anonymous
 Haven't got customization, only one type of screen

 - Author:
 OneSky

 - Important:
 If you want use only API, look OneSkySource class.
 */

final public class SettingsController: UIViewController {

    // - MARK: Varaibles
    fileprivate var dataManager: SettingsControllerDataManager? = SettingsControllerDataManager()

    /// One Sky delegate

    weak var delegate           : OneSkyManager?

    fileprivate var infoLabel   : UILabel!
    fileprivate var saveButton  : UIButton!
    fileprivate var tableView   : UITableView!

    var currentLocale: Locales?

    private var labelHeight     : CGFloat = 60.0
    private var userId: Int?

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    // - MARK: Functions

    /// Configure with localizations

    func configure(with locales: Localization, delegate: OneSkyManager?) {
        setupUI()
        self.delegate = delegate
        self.delegate?.delegate = self
        dataManager?.configure(tableView, localization: locales)
    }

    /// Configure with localizations and user preferencess

    func configure(with locales: Localization, and userPrefs: UserSettings, delegate: OneSkyManager?, id: Int) {
        setupUI()
        self.delegate = delegate
        self.delegate?.delegate = self
        self.userId = id
        dataManager?.configure(tableView,
                               localization: locales,
                               userSettings: userPrefs)
    }

    /// Implement setup user interface

    fileprivate func setupUI() {
        setupInfoLabel()
        setupSaveButton()
        configureTableView()
    }

    /// Implement setup info label

    func setupInfoLabel() {
        let frame = CGRect(origin: CGPoint(x: 30, y: 20),
                           size: CGSize(width: self.view.frame.width - 60,
                                        height: labelHeight))
        infoLabel = UILabel(frame: frame)
        infoLabel.backgroundColor = .white
        infoLabel.numberOfLines = 0
        infoLabel.text = "You'll have the option to translate stories into this language."
        self.view.addSubview(infoLabel)
    }

    /// Implement setup save button

    func setupSaveButton() {
        let controllerHeight = self.view.frame.height
        let frame = CGRect(origin: CGPoint(x: 30,
                                           y: controllerHeight - 10 - labelHeight),
                           size: CGSize(width: self.view.frame.width - 60,
                                        height: labelHeight))
        saveButton = UIButton(frame: frame)
        saveButton.backgroundColor = .white
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.borderWidth = 1.0
        saveButton.layer.cornerRadius = 7.0
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.setTitle("save_locale_settings".localLocalized, for: .normal)
        saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)

        self.view.addSubview(saveButton)
    }

    /// Configure tableView

    func configureTableView() {
        let controllerHeight = self.view.frame.height
        let frame = CGRect(origin: CGPoint(x: 0,
                                           y: labelHeight + 35),
                           size: CGSize(width: self.view.frame.width,
                                        height: controllerHeight - 60 - 2 * labelHeight))
        tableView = UITableView(frame: frame)
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)

    }

    /// Trigger of save button

    @objc func handleSaveButton() {
        dataManager?.requestCurrentUserPrefs { [weak self] preference, userCurrent in
            guard let `self` = self else { return }
            if let prefs = preference,
                let sorted = preference?.app?.user?.preferences?.filter({ $0.type == "display-language" }).first,
                let values = sorted.values,
                let id = self.userId {
                
                self.delegate?.sendUserSettings(with: id,
                                                name: prefs.app?.user?.name,
                                                email: prefs.app?.user?.email,
                                                values: values)

                } /* sorted.values?.filter({ $0 == id }) == nil */
                self.currentLocale = userCurrent
                guard let locale = userCurrent, let id = locale.id else { return }
                self.delegate?.translate(localeId: id)
        }
    }

}

// - MARK: OneSkyDelegate
//

extension SettingsController: OneSkyDelegate {

    public func didTranslateText(with languageId: String) {
        let persistance = PersistanceService()
        persistance.currentUserSettings = currentLocale
        saveButton.setTitle("save_locale_settings".localLocalized, for: .normal)
        let alert = UIAlertController(title: "", message: "Locale was successfully selected!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great!", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
