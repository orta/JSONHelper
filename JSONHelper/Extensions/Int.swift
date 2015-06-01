//
//  Int.swift
//  JSONHelper
//
//  Created by Baris Sencan on 6/1/15.
//  Copyright (c) 2015 Baris Sencan. All rights reserved.
//

import Foundation

extension Int: Convertible {

  public static func convertFromValue(value: AnyObject?) -> Int? {
    if let value: AnyObject = value {
      if let intValue = value as? Int {
        return intValue
      } else if let stringValue = value as? String {
        return stringValue.toInt()
      }
    }
    return nil
  }
}