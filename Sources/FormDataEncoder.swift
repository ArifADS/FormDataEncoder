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
    let datas = encoder.objs.flatMap { createFormable(key: $0.key, value: $0.value) }
    return create(datas: datas)
  }
  
  public func encode(_ object: [String: Any]) throws -> Data {
    let datas = object.flatMap { createFormable(key: $0.key, value: $0.value) }
    return create(datas: datas)
  }
  
  private func create(datas: [Data]) -> Data {
    let fields = datas.reduce(Data()) { $0 + "--\(boundary)\r\n".data(using: .utf8)! + $1 }
    return  fields + "--\(boundary)--\r\n".data(using: .utf8)!
  }
  
  private func createFormable(key: String, value: Any) -> [Data] {
    switch value {
    case let field as FormFile: return [encodeFile(name: key, file: field)]
    case let values as [Any]: return values.flatMap { createFormable(key: key + "[]", value: $0) }
    default: return [encodeField(name: key, value: value)]
    }
  }
  
  private func encodeField(name: String, value: Any) -> Data {
    return """
    Content-Disposition: form-data; name=\"\(name)\"
    
    \(value)
    
    """
    .replacingOccurrences(of: "\n", with: "\r\n")
    .data(using: .utf8)!
  }
  
  private func encodeFile(name: String, file: FormFile) -> Data {
    return """
    Content-Disposition: form-data; name="\(name)"; filename="\(file.fileName)"
    Content-Type: \(file.type)
    
    
    """
    .replacingOccurrences(of: "\n", with: "\r\n")
    .data(using: .utf8)!
    + file.data + "\r\n".data(using: .utf8)!
  }
}

private class _FormDataEncoder: Encoder {
  public var codingPath = [CodingKey]()
  public var userInfo = [CodingUserInfoKey : Any]()
  var objs = [(key: String, value: Any)]()
  
  func encode(_ value: Encodable, key: CodingKey) throws {
    let key = key.stringValue
    
    if let i = objs.firstIndex(where: { $0.key == key }) {
      objs[i] = (key, value)
    } else {
      objs.append((key, value))
    }
  }
  
  public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
    return KeyedEncodingContainer(KeyedContainer<Key>(encoder: self, codingPath: codingPath))
  }
  
  public func unkeyedContainer() -> UnkeyedEncodingContainer {
    return UnkeyedContanier(encoder: self, codingPath: codingPath)
  }
  
  public func singleValueContainer() -> SingleValueEncodingContainer {
    return SingleContainer(encoder: self, codingPath: codingPath)
  }
}

private struct KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
  let encoder: _FormDataEncoder
  let codingPath: [CodingKey]
  
  mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
    encoder.codingPath.append(key)
    if value is FormFile || value is [Encodable] {
      try encoder.encode(value, key: key)
    } else {
      try value.encode(to: encoder)
    }
  }
  
  
  func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
    encoder.codingPath.append(key)
    return encoder.container(keyedBy: keyType)
  }
  
  func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
    encoder.codingPath.append(key)
    return encoder.unkeyedContainer()
  }
  
  func superEncoder() -> Encoder { encoder }
  func superEncoder(forKey key: Key) -> Encoder { encoder }
  mutating func encodeNil(forKey key: Key) throws { }
}

private struct UnkeyedContanier: UnkeyedEncodingContainer {
  let encoder: _FormDataEncoder
  let codingPath: [CodingKey]
  var count: Int = 0
  
  mutating func encode<T>(_ value: T) throws where T : Encodable {
    if value is FormFile {
      try encoder.encode(value, key: codingPath.last!)
    } else {
      try value.encode(to: encoder)
    }
  }
  
  func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
    return encoder.container(keyedBy: keyType)
  }
  
  func nestedUnkeyedContainer() -> UnkeyedEncodingContainer { self }
  func superEncoder() -> Encoder { encoder }
  mutating func encodeNil() throws { }
}


private struct SingleContainer: SingleValueEncodingContainer {
  let encoder: _FormDataEncoder
  let codingPath: [CodingKey]
  
  func encoding(_ value: Encodable) throws {
    let key = codingPath.last!
    try encoder.encode(value, key: key)
  }
  
  mutating func encode<T>(_ value: T) throws where T : Encodable {
    if value is FormFile {
      try encoding(value)
    } else {
      try value.encode(to: encoder)
    }
  }
  mutating func encode(_ value: Bool) throws { try encoding(value) }
  mutating func encode(_ value: String) throws { try encoding(value) }
  mutating func encode(_ value: Double) throws { try encoding(value) }
  mutating func encode(_ value: Float) throws { try encoding(value) }
  mutating func encode(_ value: Int) throws { try encoding(value) }
  mutating func encode(_ value: Int8) throws { try encoding(value) }
  mutating func encode(_ value: Int16) throws { try encoding(value) }
  mutating func encode(_ value: Int32) throws { try encoding(value) }
  mutating func encode(_ value: Int64) throws { try encoding(value) }
  mutating func encode(_ value: UInt) throws { try encoding(value) }
  mutating func encode(_ value: UInt8) throws { try encoding(value) }
  mutating func encode(_ value: UInt16) throws { try encoding(value) }
  mutating func encode(_ value: UInt32) throws { try encoding(value) }
  mutating func encode(_ value: UInt64) throws { try encoding(value) }
  mutating func encodeNil() throws { }
}
