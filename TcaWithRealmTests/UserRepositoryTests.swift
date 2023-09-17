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
    override func setUpWithError() throws {
        try super.setUpWithError()
        let configuration = Realm.Configuration(inMemoryIdentifier: "test")
        let realmForTest = try! Realm(configuration: configuration)
        RealmManager.inject(realmForTest)
    }
    
    override func tearDown() {
        RealmManager.transact {
            RealmManager.shared.realm.deleteAll()
        }
        super.tearDown()
    }
    
    func testFindAll() {
        let users = UserRepository.findAll()
        XCTAssertEqual(users.count, 0)
        
        let user = User(userName: "aaa", age: 10)
        RealmManager.transact {
            RealmManager.shared.realm.add(user)
        }
        XCTAssertEqual(users.count, 1)
    }
    
    func testCreate() {
        let users = RealmManager.shared.realm.objects(User.self)
        XCTAssertEqual(users.count, 0)
        
        let user = User(userName: "aaa", age: 10)
        UserRepository.create(user: user)
        
        XCTAssertEqual(users.count, 1)
    }
}
