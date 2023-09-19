//
//  UserListStore.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import Foundation
import RealmSwift
import Combine
import ComposableArchitecture

struct UserListStore: Reducer {
    struct State: Equatable {
        var users: [User] = []
    }
    
    enum Action {
        case setup
        case addButtonTapped
        case updateUsers([User])
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .updateUsers(users):
                state.users = users

            case .setup:
                return .publisher {
                    userClient.publisher.replaceError(with: .init(results: nil)).map { users in
                        return .updateUsers(users.makeArray())
                    }
                }
                
            case .addButtonTapped:
                return .run { send in
                    await userClient.create((name: "New User", age: 10))
                }
            }
            return .none
        }
    }
}
