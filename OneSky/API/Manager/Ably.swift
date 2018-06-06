//
//  Ably.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 25.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import Ably

/**
 Ably service manager
 Useing for receiving notifications from socket manager
 Here we can get notification which signal us about new version of application

 - Author:
 OneSky

 - Important:
 Not recomented to change this file
 */

class Ably {

    let ablyService: ARTRealtime = ARTRealtime(key: Constants.ablySecretKey)

    // - MARK: Function
    //

    /// Connect to socket service

    func connect() {

        ablyService.connection.on(.connected) { [weak self] state in
            guard let `self` = self else { return }
            debugPrint("🛠 OneSky: ABLY service connected!")
            self.setChanel()
        }

    }

    /// Initialization of current channel

    func setChanel() {
        let channel = ablyService.channels.get(Constants.appID)
        channel.subscribe("notification") { [weak self] message in
            guard let `self` = self else { return }
            debugPrint("notification received")
        }
    }

}
