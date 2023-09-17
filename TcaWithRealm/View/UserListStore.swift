//
//  UserListStore.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import Foundation
import RealmSwift
import ComposableArchitecture

struct UserListStore: Reducer {
    struct State: Equatable {
        var users: [User]
    }
    
    enum Action: Equatable {
        case setup
        case addButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .setup:
                return .none
            case .addButtonTapped:
                return .none
            }
        }
    }
}
