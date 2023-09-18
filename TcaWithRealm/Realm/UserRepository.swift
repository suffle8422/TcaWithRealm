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
    
    private var token: NotificationToken?
    var userSubject = PassthroughSubject<[User], Never>()
    
    init() {
        let realm = try! Realm()
        let  results = realm.objects(User.self)
        
        token = results.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial(let results):
                self.userSubject.send(Array(results))
            case .update(let results, _, _, _):
                self.userSubject.send(Array(results))
            case .error(let error):
                debugPrint(error)
            }
        }
    }
    
    // MARK: -
    
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

