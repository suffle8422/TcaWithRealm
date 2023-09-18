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
    var create: (User) async -> Void
    var results: () async -> Results<User>
    var subject: PassthroughSubject<[User], Never>
}

extension UserClient: DependencyKey {
    static let liveValue = Self(
        create: { user in
            UserRepository.shared.create(user: user)
        },
        results: {
            return UserRepository.shared.findAll()
        },
        subject: UserRepository.shared.userSubject
    )
}

extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}
