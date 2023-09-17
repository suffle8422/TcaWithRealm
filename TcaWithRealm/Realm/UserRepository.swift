//
//  UserRepository.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import Foundation
import RealmSwift

struct UserRepository {
    let publisher = RealmManager.shared.realm.objects(User.self).collectionPublisher
    
    private static let realm = RealmManager.shared.realm
    
    static func findAll() -> Results<User> {
        let object = realm.objects(User.self)
        return object
    }
    
    static func create(user: User) {
        RealmManager.transact {
            realm.add(user)
        }
    }
}
