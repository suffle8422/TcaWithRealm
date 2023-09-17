//
//  RealmManager.swift
//  TcaWithRealm
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    var realm: Realm
    
    private init() {
        realm = try! Realm()
    }
    
    class func transact(operation: @escaping () -> Void) {
        do {
            try shared.realm.write {
                operation()
            }
        } catch {
            debugPrint(error)
        }
    }
    
    ///sharedをテスト用のrealmオブジェクトに差し替える
    class func inject(_ realm: Realm) {
        shared.realm = realm
    }
}
