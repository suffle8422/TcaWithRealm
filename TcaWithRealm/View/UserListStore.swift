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
        var cancellable: AnyCancellable? = nil
    }
    
    enum Action {
        case setup
        case addButtonTapped
        case setCancelabel(Cancellable)
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setup:
                // ユーザー一覧のの購読
                let cancellable = userClient.subject.receive(on: DispatchQueue.main).sink(receiveCompletion: { _ in
                }, receiveValue: { users in
                    debugPrint("hoge", users.count)
                })
                return .run { send in
                    await send(.setCancelabel(cancellable))
                }
                
            case let .setCancelabel(cancellable):
                state.cancellable = cancellable as? AnyCancellable
                return .none
                
            case .addButtonTapped:
                return .run { send in
                    let user = User(name: "追加ユーザー", age: 10)
                    await userClient.create(user)
                }
            }
        }
    }
}
