//
//  UserModel.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import Foundation
import RealmSwift

class User: Object, ObjectKeyIdentifiable {
    @Persisted var id: String = ""
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String, age: Int) {
        self.init()
        self.id = UUID().uuidString
        self.name = name
        self.age = age
    }
}
