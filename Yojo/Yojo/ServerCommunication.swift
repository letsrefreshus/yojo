//
//  ServerCommunication.swift
//  Yojo
//
//  Created by Animish Gadve on 1/21/16.
//  Copyright © 2016 OMFG Studios. All rights reserved.
//

import Foundation
import Alamofire


class ServerCommunication: NSObject {
    
    let serverURL = "http://10.0.0.191"
    
    func getDataFromServer(completion:(responseData:NSData)->Void) {
        Alamofire.request(.GET, serverURL).responseJSON() {
            response in
                completion(responseData: response.data!)
        }
    }
}