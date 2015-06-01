//
//  JSONHelper.swift
//
//  Created by Baris Sencan on 28/08/2014.
//  Copyright 2014 Baris Sencan
//
//  Distributed under the permissive zlib license
//  Get the latest version from here:
//
//  https://github.com/isair/JSONHelper
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

import Foundation

/// A type of dictionary that only uses strings for keys and can contain any
/// type of object as a value.
public typealias JSONDictionary = [String: AnyObject]

/// TODOC
public protocol Convertible {

  /// TODOC
  static func convertFromValue(value: Any?) -> Self?
}

/// Returns nil if given object is of type NSNull.
///
/// :param: object Object to convert.
///
/// :returns: nil if object is of type NSNull, else returns the object itself.
public func convertToNilIfNull(value: Any?) -> Any? {
  if value is NSNull {
    return nil
  }
  return value
}

/// TODOC
public protocol Deserializable {
  init(jsonDictionary: JSONDictionary)
}

/// TODOC
public protocol Serializable {
  func toJSONDictionary() -> JSONDictionary
}

/// Operator for use in right hand side to left hand side conversion and deserialization.
infix operator <-- { associativity right precedence 150 }

public func <-- <C: Convertible>(inout lhs: C?, rhs: Any?) -> C? {
  lhs = C.convertFromValue(convertToNilIfNull(rhs))
  return lhs
}

public func <-- <C: Convertible>(inout lhs: C, rhs: Any?) -> C {
  var newValue: C?
  newValue <-- rhs
  if let newValue = newValue {
    lhs = newValue
  }
  return lhs
}

public func <-- <D: Deserializable>(inout lhs: D?, rhs: Any?) -> D? {
  if let jsonDictionary = convertToNilIfNull(rhs) as? JSONDictionary {
    lhs = D(jsonDictionary: jsonDictionary)
  } else {
    lhs = nil
  }
  return lhs
}

public func <-- <D: Deserializable>(inout lhs: D, rhs: Any?) -> D {
  var newValue: D?
  newValue <-- rhs
  if let newValue = newValue {
    lhs = newValue
  }
  return lhs
}

/// Operator for use in left hand side to right hand side conversion and serialization.
infix operator --> { associativity left precedence 150 }

public func --> <C: Convertible>(lhs: AnyObject?, inout rhs: C?) -> C? {
  return rhs <-- lhs
}

public func --> <C: Convertible>(lhs: AnyObject?, inout rhs: C) -> C {
  return rhs <-- lhs
}

// TODO: Serialization
