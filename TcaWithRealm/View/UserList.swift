//
//  UserList.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import SwiftUI
import ComposableArchitecture

struct UserList: View {
    let store: StoreOf<UserListStore>
    
    var body: some View {
        NavigationStack {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                List(viewStore.state.users) { user in
                    VStack(alignment: .leading) {
                        Text("name: \(user.name)")
                        Text("age: \(user.age)")
                    }
                }
                .navigationTitle("ユーザーリスト")
                .toolbar {
                    ToolbarItem {
                        Button {
                            viewStore.send(.addButtonTapped)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .task {
                    viewStore.send(.setup)
                }
            }
        }
    }
}

#Preview {
    UserList(
        store: Store(
            initialState: UserListStore.State(users: [
                User(name: "aaa", age: 10),
                User(name: "bbb", age: 20),
                User(name: "ccc", age: 30),
            ])
        ) {
            UserListStore()
                ._printChanges()
        }
    )
}
