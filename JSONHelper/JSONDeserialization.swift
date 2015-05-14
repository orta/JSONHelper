//
//  JSONOperator.swift
//  JSONHelper
//
//  Created by Chenyu Lan on 5/15/15.
//  Copyright (c) 2015 Chenyu Lan. All rights reserved.
//

import Foundation

/// Operator for use in deserialization operations.
infix operator <-- { associativity right precedence 150 }

/// Convert object to nil if is Null
private func convertToNilIfNull(object: JSONObject?) -> JSONObject? {
    return object is NSNull ? nil : object
}

// MARK: - Protocol

/// Use for Class, Nested Type
public protocol Deserializable {
    init(data: JSONDictionary)
}

/// Use for Primitive Type
public protocol Convertible {
    static func convert(data: JSONObject) -> Self?
}

// MARK: - Convertible Type Deserialization

public func <-- <T: Convertible>(inout property: T?, dataObject: JSONObject?) -> T? {
    if let data: JSONObject = convertToNilIfNull(dataObject), convertedValue = T.convert(data) {
        property = convertedValue
    } else {
        property = nil
    }
    return property
}

public func <-- <T: Convertible>(inout property: T, dataObject: JSONObject?) -> T {
    var newValue: T?
    newValue <-- dataObject
    if let newValue = newValue { property = newValue }
    return property
}

public func <-- <T: Convertible>(inout array: [T]?, dataObject: JSONObject?) -> [T]? {
    if let dataArray = convertToNilIfNull(dataObject) as? [JSONObject] {
        array = [T]()
        for data in dataArray {
            if let property = T.convert(data) {
                array!.append(property)
            }
        }
    } else {
        array = nil
    }
    return array
}

public func <-- <T: Convertible>(inout array: [T], dataObject: JSONObject?) -> [T] {
    var newValue: [T]?
    newValue <-- dataObject
    if let newValue = newValue { array = newValue }
    return array
}

// MARK: - Custom Type Deserialization

public func <-- <T: Deserializable>(inout instance: T?, dataObject: JSONObject?) -> T? {
    if let data = convertToNilIfNull(dataObject) as? JSONDictionary {
        instance = T(data: data)
    } else {
        instance = nil
    }
    return instance
}

public func <-- <T: Deserializable>(inout instance: T, dataObject: JSONObject?) -> T {
    var newValue: T?
    newValue <-- dataObject
    if let newValue = newValue { instance = newValue }
    return instance
}

public func <-- <T: Deserializable>(inout array: [T]?, dataObject: JSONObject?) -> [T]? {
    if let dataArray = convertToNilIfNull(dataObject) as? [JSONDictionary] {
        array = [T]()
        for data in dataArray {
            array!.append(T(data: data))
        }
    } else {
        array = nil
    }
    return array
}

public func <-- <T: Deserializable>(inout array: [T], dataObject: JSONObject?) -> [T] {
  var newArray: [T]?
  newArray <-- dataObject
  if let newArray = newArray { array = newArray }
  return array
}

// MARK: - Custom Value Converter

public func <-- <T>(inout property: T?, bundle:(dataObject: JSONObject?, converter: (JSONObject) -> T?)) -> T? {
    if let data: JSONObject = convertToNilIfNull(bundle.dataObject), convertedValue = bundle.converter(data) {
        property = convertedValue
    }
    return property
}

public func <-- <T>(inout property: T, bundle:(dataObject: JSONObject?, converter: (JSONObject) -> T?)) -> T {
    var newValue: T?
    newValue <-- bundle
    if let newValue = newValue { property = newValue }
    return property
}

// MARK: - Custom Map Deserialiazation

public func <-- <T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T]?, dataObject: JSONObject?) -> [U: T]? {
    if let dataMap = convertToNilIfNull(dataObject) as? [String: JSONObject] {
        map = [U: T]()
        for (key, data) in dataMap {
            if let convertedKey = U.convert(key), convertedValue = T.convert(data) {
                map![convertedKey] = convertedValue
            }
        }
    } else {
        map = nil
    }
    return map
}

public func <-- <T, U where T: Convertible, U: Convertible, U: Hashable>(inout map: [U: T], dataObject: JSONObject?) -> [U: T] {
    var newValue: [U: T]?
    newValue <-- dataObject
    if let newValue = newValue { map = newValue }
    return map
}

public func <-- <T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T]?, dataObject: JSONObject?) -> [U: T]? {
    if let dataMap = convertToNilIfNull(dataObject) as? [String: JSONDictionary] {
        map = [U: T]()
        for (key, data) in dataMap {
            if let convertedKey = U.convert(key) {
                map![convertedKey] = T(data: data)
            }
        }
    } else {
        map = nil
    }
    return map
}

public func <-- <T, U where T: Deserializable, U: Convertible, U: Hashable>(inout map: [U: T], dataObject: JSONObject?) -> [U: T] {
    var newValue: [U: T]?
    newValue <-- dataObject
    if let newValue = newValue { map = newValue }
    return map
}

// MARK: Raw Value Representable (Enum) Deserialization

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout property: T?, value: AnyObject?) -> T? {
    var newEnumValue: T?
    var newRawEnumValue: T.RawValue?
    newRawEnumValue <-- value
    if let unwrappedNewRawEnumValue = newRawEnumValue {
        if let enumValue = T(rawValue: unwrappedNewRawEnumValue) {
            newEnumValue = enumValue
        }
    }
    property = newEnumValue
    return property
}

public func <-- <T: RawRepresentable where T.RawValue: Convertible>(inout property: T, value: AnyObject?) -> T {
    var newValue: T?
    newValue <-- value
    if let newValue = newValue { property = newValue }
    return property
}


