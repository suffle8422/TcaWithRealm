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
        var count: Int = 0
        var cancellable: AnyCancellable? = nil
    }
    
    enum Action {
        case setup
        case updateCount(Int)
        case addButtonTapped
        case setCancelabel(Cancellable)
    }
    
    @Dependency(\.userClient) var userClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setup:
                // カウントの購読
                let cancellable = userClient.getPublisher().receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: { _ in
                    }, receiveValue: { results in
                        debugPrint("hoge")
                    })
                return .run { send in
                    // 初期値設定
                    let results = userClient.results
                    let count = await results().count
                    await send(.updateCount(count))
                    await send(.setCancelabel(cancellable))
                }
                
            case let .setCancelabel(cancellable):
                state.cancellable = cancellable as? AnyCancellable
                return .none
                
            case let .updateCount(count):
                state.count = count
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
