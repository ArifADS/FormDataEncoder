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

struct Incident: Codable {
  let incidents: [Int]
  let inside: [Incident]
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
    XCTAssertEqual(data.count, 268)
  }
  
  func testFormFile() throws {
    let encoder = FormDataEncoder(boundary: boundary)
    let data = try String(data: encoder.encode(form), encoding: .utf8)!
    let testData =
    """
    --QWERTY123\r\n\
    Content-Disposition: form-data; name="id"\r\n\
    \r\n\
    123\r\n\
    --QWERTY123\r\n\
    Content-Disposition: form-data; name="market"\r\n\
    \r\n\
    Carrefour\r\n\
    --QWERTY123\r\n\
    Content-Disposition: form-data; name="avatar"; filename="avatar.jpg"\r\n\
    Content-Type: image/jpeg\r\n\
    \r\n\
    hola\r\n\
    --QWERTY123--\r\n
    """
    XCTAssertEqual(data, testData)
  }
  
  func testFormDataEncoder() throws {
    struct Foo: Encodable {
      var string: String
      var int: Int
      var double: Double
      var array: [Int]
      var bool: Bool
    }
    let encoder = FormDataEncoder(boundary: "hello")
    let a = Foo(string: "a", int: 42, double: 3.14, array: [1, 2, 3], bool: true)
    let data = try String(data: encoder.encode(a), encoding: .utf8)!
    let testData =
    """
    --hello\r\n\
    Content-Disposition: form-data; name="string"\r\n\
    \r\n\
    a\r\n\
    --hello\r\n\
    Content-Disposition: form-data; name="int"\r\n\
    \r\n\
    42\r\n\
    --hello\r\n\
    Content-Disposition: form-data; name="double"\r\n\
    \r\n\
    3.14\r\n\
    --hello\r\n\
    Content-Disposition: form-data; name="array[]"\r\n\
    \r\n\
    1\r\n\
    --hello\r\n\
    Content-Disposition: form-data; name="array[]"\r\n\
    \r\n\
    2\r\n\
    --hello\r\n\
    Content-Disposition: form-data; name="array[]"\r\n\
    \r\n\
    3\r\n\
    --hello\r\n\
    Content-Disposition: form-data; name="bool"\r\n\
    \r\n\
    true\r\n\
    --hello--\r\n
    """
    XCTAssertEqual(data, testData)
  }
}
