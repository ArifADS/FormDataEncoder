//
//  FormFile.swift
//  FormData
//
//  Created by Arif De Sousa on 30/11/2018.
//  Copyright © 2018 arifads. All rights reserved.
//

import Foundation

public struct FormFile: Codable {
  let data: Data
  let type: String
  let fileName: String
  
  public init(data: Data, type: String, fileName: String){
    self.data = data
    self.type = type
    self.fileName = fileName
  }
}
