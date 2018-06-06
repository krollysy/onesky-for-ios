//
//  SelectCell.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 15.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import UIKit

/**
 Custom cell for tableView

 - Author:
 OneSky

 */

class SelectCell: UITableViewCell {

    var languageLabel     : UILabel!
    var currentCheckpoint : UIImageView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        languageLabel = UILabel(frame: CGRect(x: 15,
                                              y: 5,
                                              width: self.frame.width - 60,
                                              height: self.frame.height - 10))
        self.contentView.addSubview(languageLabel)

        currentCheckpoint = UIImageView(frame: CGRect(x: self.frame.width - 32,
                                                      y: 5,
                                                      width: 25,
                                                      height:  25))
        currentCheckpoint.center.y = self.center.y
        currentCheckpoint.contentMode = .scaleAspectFit
        self.contentView.addSubview(currentCheckpoint)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        currentCheckpoint.image = nil
        super.prepareForReuse()
    }

}
