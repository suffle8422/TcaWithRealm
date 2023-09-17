//
//  UserRepository.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import Foundation
import Combine
import RealmSwift

final class UserRepository {
    static let shared = UserRepository()
    var publisher: RealmPublishers.Value<Results<User>> {
        let realm = try! Realm()
        let results = realm.objects(User.self)
        return results.collectionPublisher
    }
    
    func findAll(realm: Realm = try! Realm()) -> Results<User> {
        let object = realm.objects(User.self)
        return object
    }
    
    func create(user: User, realm: Realm = try! Realm()) {
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            debugPrint(error)
        }
    }
}
