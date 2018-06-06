//
//  Array+Rearrange.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 24.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation

extension Array {

    /// Calls for rearrange elements `from` and `to` in current array

    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }

}
