//
//  FormFile.swift
//  FormData
//
//  Created by Arif De Sousa on 30/11/2018.
//  Copyright © 2018 arifads. All rights reserved.
//

import Foundation

public struct FormFile: Codable {
  let name: String
  let data: Data
  let type: String
  let fileName: String
  
  public init(name: String, data: Data, type: String, fileName: String){
    self.name = name
    self.data = data
    self.type = type
    self.fileName = fileName
  }
  
  public func formString() -> Data {
    var body = ""
    body += "Content-Disposition:form-data; name=\"\(name)\""
    body += "; filename=\"\(fileName)\"\r\n"
    body += "Content-Type: \(type)\r\n\r\n"
    return body.data(using: .utf8)! + data + "\r\n".data(using: .utf8)!
  }
}
