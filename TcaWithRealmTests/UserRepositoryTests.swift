//
//  UserRepositoryTests.swift
//  TcaWithRealmTests
//
//  Created by Ibuki Ohnishi on 2023/09/17.
//

import XCTest
import RealmSwift
@testable import TcaWithRealm

class UserRepositoryTests: XCTestCase {
    var realm: Realm!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = Realm.Configuration(inMemoryIdentifier: "test")
        realm = try Realm(configuration: configuration)
        RealmManager.inject(realm)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        RealmManager.transact {
            RealmManager.shared.realm.deleteAll()
        }
    }
    
    
    func testFindAll() {
        let realm = RealmManager.shared.realm
        guard let results = UserRepository.shared.findAll().results else {
            XCTFail()
            return
        }
        XCTAssertEqual(results.count, 0)
        
        let user = User(name: "aaa", age: 10)
        do {
            try realm.write {
                realm.add(user)
            }
        } catch {
            XCTFail()
        }
        XCTAssertEqual(results.count, 1)
    }
    
    func testCreate() {
        let realm = RealmManager.shared.realm
        let users = realm.objects(User.self)
        XCTAssertEqual(users.count, 0)
        Task { @MainActor in
            try! await UserRepository.shared.create(name: "aaa", age: 10)
            XCTAssertEqual(users.count, 1)
        }
    }
}
