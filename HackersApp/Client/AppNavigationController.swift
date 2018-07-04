//
//  AppNavigationController.swift
//  Hackers
//
//  Created by Weiran Zhang on 05/05/2018.
//  Copyright © 2018 Glass Umbrella. All rights reserved.
//

import UIKit
import OneSky

class AppNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheming()
        navigationBar.setValue(true, forKey: "hidesShadow")
    }
}

extension AppNavigationController: Themed {
    func applyTheme(_ theme: AppTheme) {        
        navigationBar.barTintColor = theme.barBackgroundColor
        navigationBar.tintColor = theme.barForegroundColor
        let titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: theme.titleTextColor
        ]
        navigationBar.titleTextAttributes = titleTextAttributes
        navigationBar.largeTitleTextAttributes = titleTextAttributes
    }
}
