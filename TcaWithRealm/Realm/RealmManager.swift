//
//  RealmManager.swift
//  TcaWithRealm
//
//  Created by ionishi on 2023/09/19.
//

import Foundation
import RealmSwift

final class RealmManager {
    static let shared = RealmManager()
    var realm: Realm
    
    fileprivate init() {
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
    
    class func deleteAll<T: Object>(_ object: Results<T>) {
        do {
            try shared.realm.write {
                shared.realm.delete(object)
            }
        } catch {
            debugPrint(error)
        }
    }
    
    class func getById<T: Object>(_ object: Results<T>, id: String, idColumnName: String) -> T?{
        let predicate = NSPredicate(format: "\(idColumnName) == %@", id)
        return object.filter(predicate).first ?? nil
    }
    
    ///sharedをテスト用のrealmオブジェクトに差し替える
    class func inject(_ realm: Realm) {
        shared.realm = realm
    }
}
