//
//  FormField.swift
//  FormData
//
//  Created by Arif De Sousa on 30/11/2018.
//  Copyright © 2018 arifads. All rights reserved.
//

import Foundation

public struct FormField: Formable {
  let name: String
  let value: String
  
  public init(name: String, value: String) {
    self.name = name
    self.value = value
  }
  
  public func formString() -> Data {
    var body = ""
    body += "Content-Disposition:form-data; name=\"\(name)\""
    body += "\r\n\r\n\(value)\n"
    return body.data(using: .utf8)!
  }
}
