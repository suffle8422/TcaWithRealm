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
        case test([User])
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .test(users): 
                state.users = users

            case .setup:
                // ユーザー一覧のの購読
//                let cancellable = userClient.publisher.receive(on: DispatchQueue.main).sink(receiveValue: { users in
//                    debugPrint("hoge", users.count)
//                })

                return .publisher {
                    userClient.publisher.replaceError(with: .init(results: nil)).map { users in
                        return .test(users.makeArray())
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
