//
//  SettingsViewController.swift
//  Hackers
//
//  Created by Weiran Zhang on 05/05/2018.
//  Copyright © 2018 Glass Umbrella. All rights reserved.
//

import UIKit
import OneSky

class SettingsViewController: UIViewController {

    enum ButtonState: String {
        case login   = "Login"
        case logout  = "Logout"
    }

    fileprivate var isOpened: Bool = false

    fileprivate var currentState: ButtonState = .login
    fileprivate var oneSky: OneSkyManager = OneSkySource()

    var lag = true

    @IBOutlet weak var accountID: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        oneSky.delegate = self
//        oneSky.initializeSocket()
        loginButton.addTarget(self,
                              action: #selector(loginButtonPressed),
                              for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isOpened = false
    }

    @IBAction func localizationPressed(_ sender: Any) {
        switch currentState {
        case .logout:
            guard let id = Int(accountID.text!) else { return }
            oneSky.getUserPreferences(with: id)
        case .login:
            isOpened = true
            oneSky.open(from: self, style: .push)
        }
    }

    @IBAction func didPressDone(_ sender: Any) {
        dismiss(animated: true)
    }

    @objc func loginButtonPressed() {
        switch currentState {
        case .login:
            currentState = .logout
        case .logout:
            currentState = .login
        }
        loginButton.setTitle(currentState.rawValue, for: .normal)
    }
    
}

extension SettingsViewController: OneSkyDelegate {

    func didUploadUserPreference(with id: Int) {
        guard let id = Int(accountID.text!) else { return }
        isOpened = true
        oneSky.open(from: self, style: .push, userId: id)
    }

    func didReceive(locales enabledLocales: Localization) {

    }

    func didReceive(userSettings settings: UserSettings) {
        guard !isOpened else { return }
        if settings.app?.user == nil {
            debugPrint("emptyUser!")
            let locale = oneSky.currentLocale
            guard let unwrapped = locale,
                 let id = Int(accountID.text!) else { return }
            oneSky.sendUserSettings(with: id,
                                    name: name.text,
                                    email: email.text,
                                    values: [unwrapped.id ?? ""])

        } else {
            guard let id = Int(accountID.text!) else { return }
            isOpened = true
            oneSky.open(from: self, style: .push, userId: id)
        }
    }

}
