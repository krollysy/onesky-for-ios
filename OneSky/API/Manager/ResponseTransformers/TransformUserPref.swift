//
//  TransformUserPref.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 14.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import Siesta

struct ResponseUserPreferences: ResponseTransformer {

    /// Need to decode object

    let decoder = BasicDecoder()

    /// Custom function which try to cast response data to 'UserSettings' type

    func process(_ response: Response) -> Response {
        switch response {
        case .success(var entity):
            do {
                let data = entity.content as? Data
                let decodable = try decoder.configuratorDecoder.decode(UserSettings.self,
                                                                       from:  data ?? Data())
                entity.content = decodable
                return logTransformation(.success(entity))
            } catch let error {
                debugPrint("error in responsing application UserSettings: \(error)")
                return logTransformation(.failure(RequestError.init(response: nil,
                                                                    content: nil,
                                                                    cause: nil)))
            }

        case .failure:
            return response
        }
    }

}
