//
//  UserClient.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import Foundation
import RealmSwift
import Combine
import ComposableArchitecture

struct UserClient {
    typealias UserParamerter = (name: String, age: Int)
    var create: (UserParamerter) async -> Void
    var results: () async -> ResultsWrapper<User>
    var publisher: AnyPublisher<ResultsWrapper<User>, Error>
}

extension UserClient: DependencyKey {
    static let liveValue = Self(
        create: { user in
            try! await UserRepository.shared.create(name: user.name, age: user.age)
        },
        results: {
            return UserRepository.shared.findAll()
        },
        publisher: {
            return UserRepository.shared.publisher()
        }()
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
