//
//  RandomJsonListBO.swift
//  CavistaCodeChallenge
//
//  Created by Payal Wankhede on 9/19/20.
//  Copyright © 2020 Payal Wankhede. All rights reserved.
//

import Foundation
import RealmSwift

class ListJsonBO: Object, Codable {
    
    @objc dynamic var data: String?
    @objc dynamic var date: String?
    @objc dynamic var id: String?
    @objc dynamic var type: String?
    
    //Primary key for updating data
    override static func primaryKey() -> String? {
        return "id"
    }
}
