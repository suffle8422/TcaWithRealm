//
//  TcaWithRealmApp.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import SwiftUI
import ComposableArchitecture

@main
struct TcaWithRealmApp: App {
    static let store = Store(initialState: UserListStore.State()) {
        UserListStore()
    }
    
    var body: some Scene {
        WindowGroup {
            UserList(store: TcaWithRealmApp.store)
        }
    }
}
