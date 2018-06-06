//
//  SelectCellViewModel.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 15.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import UIKit

/**
 Custom cell view model

 - Author:
 OneSky

 */

class SelectCellViewModel {

    fileprivate var language: String!
    fileprivate var isCurrent: Bool!

    init(language: String, isCurrent: Bool) {
        self.language = language
        self.isCurrent = isCurrent
    }

    /// Configure cell

    func configure(cell: SelectCell) {
        cell.languageLabel.text = language
        cell.currentCheckpoint.contentMode = .scaleAspectFit
        var currentImage: UIImage?
        let podBundle = Bundle(for: SelectCellViewModel.self)
        if let url = podBundle.url(forResource: "Resources", withExtension: "bundle") {
            let mykitBundle = Bundle(url: url)
            let retrievedImage = UIImage(named: "checkmark", in: mykitBundle, compatibleWith: nil)
            currentImage = retrievedImage
        }

        /// For non framework testing
        if let img = UIImage(named: "checkmark", in: .main, compatibleWith: nil) {
            currentImage = img
        }
        
        cell.currentCheckpoint.image = isCurrent ? currentImage : nil
    }

}
