//
//  Tests.swift
//  Tests
//
//  Created by Arif De Sousa on 12/03/2019.
//  Copyright © 2019 arifads. All rights reserved.
//

import XCTest
import FormData

struct UserForm: Codable {
  let id: String
  let market: String
  let avatar = FormFile(data: "hola".data(using: .utf8)!, type: "image/jpeg", fileName: "avatar.jpg")
}

class Tests: XCTestCase {
  let boundary = "QWERTY123"
  let form = UserForm(id: "123", market: "Carrefour")
  
  func testSeparation() {
    let encoder = FormDataEncoder(boundary: boundary)
    let data = try! encoder.encode(form)
    let str = String(data: data, encoding: .utf8)!
    let split = str.components(separatedBy: "--" + boundary).dropFirst()
    XCTAssertEqual(split.count, 4)
  }
  
  func testBoundaryStart() {
    let encoder = FormDataEncoder(boundary: boundary)
    let data = try! encoder.encode(form)
    let str = String(data: data, encoding: .utf8)!
    XCTAssert(str.starts(with: "--" + boundary), "No Comienza con boundary")
  }
  
  func testDataSize() {
    let encoder = FormDataEncoder(boundary: boundary)
    let data = try! encoder.encode(form)
    let str = String(data: data, encoding: .utf8)!
    print(str)
    XCTAssertEqual(data.count, 263)
  }
}
