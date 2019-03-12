//
//  FormData.swift
//  FormData
//
//  Created by Arif De Sousa on 30/11/2018.
//  Copyright © 2018 arifads. All rights reserved.
//

import Foundation

public class FormDataEncoder {
  
  let boundary: String
  
  public init(boundary: String) {
    self.boundary = boundary
  }
  
  public func encode(_ object: Encodable) throws -> Data {
    let encoder = _FormDataEncoder()
    try object.encode(to: encoder)
    let datas = encoder.datas
    return FormDataEncoder.create(boundary: boundary, datas: datas)
  }
  
  private static func create(boundary: String, datas: [Data]) -> Data {
    let fields = datas.reduce(Data()) { $0 + "--\(boundary)\r\n".data(using: .utf8)! + $1 }
    return  fields + "--\(boundary)--\r\n".data(using: .utf8)!
  }
}

private class _FormDataEncoder: Encoder {
  public var codingPath: [CodingKey] { return [] }
  public var userInfo: [CodingUserInfoKey : Any] { return [:] }
  var datas = [Data]()
  
  func encode(_ value: Encodable, key: String) throws {
    switch value {
    case let file as FormFile: self.datas.append(encodeFile(name: key, file: file))
    default: self.datas.append(encodeField(name: key, value: value))
    }
  }
  
  func encodeField(name: String, value: Any) -> Data {
    var body = ""
    body += "Content-Disposition:form-data; name=\"\(name)\""
    body += "\r\n\r\n\(value)\n"
    return body.data(using: .utf8)!
  }
  
  func encodeFile(name: String, file: FormFile) -> Data {
    var body = ""
    body += "Content-Disposition:form-data; name=\"\(name)\""
    body += "; filename=\"\(file.fileName)\"\r\n"
    body += "Content-Type: \(file.type)\r\n\r\n"
    return body.data(using: .utf8)! + file.data + "\r\n".data(using: .utf8)!
  }
  
  public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
    return KeyedEncodingContainer(KeyedContainer<Key>(encoder: self))
  }
  
  public func unkeyedContainer() -> UnkeyedEncodingContainer {
    return UnkeyedContanier(encoder: self)
  }
  
  public func singleValueContainer() -> SingleValueEncodingContainer {
    return UnkeyedContanier(encoder: self)
  }
}

private struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
  var codingPath: [CodingKey] { return [] }
  var encoder: _FormDataEncoder
  
  mutating func encodeNil(forKey key: Key) throws {}
  
  
  mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
    try encoder.encode(value, key: key.stringValue)
  }
  
  func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
    return encoder.container(keyedBy: keyType)
  }
  
  func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
    return encoder.unkeyedContainer()
  }
  
  func superEncoder() -> Encoder {
    return encoder
  }
  
  func superEncoder(forKey key: Key) -> Encoder {
    return encoder
  }
}

private struct UnkeyedContanier: UnkeyedEncodingContainer, SingleValueEncodingContainer {
  var encoder: _FormDataEncoder
  
  var codingPath: [CodingKey] { return [] }
  
  var count: Int { return 0 }
  
  func encode<T>(_ value: T) throws where T : Encodable {
    try encoder.encode(value, key: "")
  }
  
  func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
    return encoder.container(keyedBy: keyType)
  }
  
  func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
    return self
  }
  
  func superEncoder() -> Encoder {
    return encoder
  }
  
  func encodeNil() throws {}
  
}
