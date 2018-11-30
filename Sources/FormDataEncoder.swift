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
  
  public func encode(_ object: FormTransformable) throws -> Data {
    let forms: [Formable] = object.formDict.flatMap { createFormable(key: $0.key, value: $0.value) }
    return FormDataEncoder.create(boundary: boundary, params: forms)
  }
  
  private func createFormable(key: String, value: Any) -> [Formable] {
    switch value {
    case let field as Formable: return [field]
    case let data as Data: return [FormFile(name: key, data: data, type: "image/jpeg", fileName: key + ".jpg")]
    case let values as [Any]: return values.flatMap { createFormable(key: key + "[]", value: $0) }
    default: return [FormField(name: key, value: (value as AnyObject).description ?? "")]
    }
  }
  
  private static func create(boundary: String, params: [Formable]) -> Data {
    let fields = params.reduce(Data()) { $0 + "--\(boundary)\r\n".data(using: .utf8)! + $1.formString() }
    return  fields + "--\(boundary)--\r\n".data(using: .utf8)!
  }
}
