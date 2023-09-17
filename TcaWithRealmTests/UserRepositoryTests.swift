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
    let realmForTest = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
    
    override func tearDown() {
        do {
            try realmForTest.write {
                realmForTest.deleteAll()
            }
        } catch {
            XCTFail()
        }
        super.tearDown()
    }
    
    func testFindAll() {
        let users = UserRepository.shared.findAll(realm: realmForTest)
        XCTAssertEqual(users.count, 0)
        
        let user = User(name: "aaa", age: 10)
        do {
            try realmForTest.write {
                self.realmForTest.add(user)
            }
        } catch {
            XCTFail()
        }
        XCTAssertEqual(users.count, 1)
    }
    
    func testCreate() {
        let users = realmForTest.objects(User.self)
        XCTAssertEqual(users.count, 0)
        
        let user = User(name: "aaa", age: 10)
        UserRepository.shared.create(user: user, realm: realmForTest)
        
        XCTAssertEqual(users.count, 1)
    }
}
