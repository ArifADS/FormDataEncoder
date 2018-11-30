//
//  Dictionary+FormTransformable.swift
//  FormData
//
//  Created by Arif De Sousa on 30/11/2018.
//  Copyright © 2018 arifads. All rights reserved.
//

import Foundation

extension Dictionary: FormTransformable where Key == String, Value == Any {
  public var formDict: [String : Any] { return self }
}
