//
//  TransformConfiguration.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 11.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import Siesta

/**

 Needed to intercept response and probably change it or handle error
 "Mediator" between 'configureTransform' and 'resourceChanged'
 Here we should decode object with type 'Data' to object with type 'Localization'

 - Author:
 OneSky

 */

struct ResponseConfiguration: ResponseTransformer {

    /// Need to decode object

    let decoder = BasicDecoder()

    /// Custom function which try to cast response data to 'Localization' type

    func process(_ response: Response) -> Response {
        switch response {
        case .success(var entity):
            do {
                let data = entity.content as? Data
                let decodable = try decoder.configuratorDecoder.decode(Localization.self,
                                                                       from:  data ?? Data())
                entity.content = decodable
                return logTransformation(.success(entity))
            } catch let error {
                debugPrint("error in responsing application Localization: \(error)")
                return logTransformation(.failure(RequestError.init(response: nil,
                                                                    content: nil,
                                                                    cause: nil)))
            }

        case .failure:
            return response
        }
    }

}
