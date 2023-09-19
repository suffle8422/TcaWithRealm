//
//  UserRepository.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import Foundation
import Combine
import RealmSwift

struct ResultsWrapper <Element: RealmCollectionValue> {
    let results: Results<Element>?
    var isError: Bool { return results == nil }
    func makeArray() -> [Element] {
        guard let results else { return [] }
        return Array(results)
    }
}

final class UserRepository {
    static let shared = UserRepository()
    
    var userSubject = PassthroughSubject<[User], Never>()
    
    // MARK: -
    
    func findAll() -> ResultsWrapper<User> {
        let object = RealmManager.shared.realm.objects(User.self)
        return .init(results: object)
    }
    
    func publisher() -> AnyPublisher<ResultsWrapper<User>, Error> {
        return findAll().results!.collectionPublisher.freeze()
            .map { ResultsWrapper(results: $0) }
            .eraseToAnyPublisher()
    }
    
    func create(name: String, age: Int) async throws {
        let realm = RealmManager.shared.realm
        try! await realm.asyncWrite({
            realm.add(User(name: name, age: age))
        })
    }
}

