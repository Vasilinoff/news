//
//  Decoder.swift
//  News
//
//  Created by Ponomarev Vasiliy on 20/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//

import Foundation

struct JSONCodingKeys: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

extension KeyedDecodingContainer {
    subscript<T: Decodable>(key: KeyedDecodingContainer.Key) -> T? {
        return try? decode(T.self, forKey: key)
    }

    func getFor<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    func getFor<T: Decodable>(_ key: KeyedDecodingContainer.Key, default: T)  -> T {
        let val:T? =  try? decode(T.self, forKey: key)

        if let val = val {  return val }
        return `default`
    }

    func getFor(_ key: KeyedDecodingContainer.Key) throws -> NSDecimalNumber {
        return try decode(NSDecimalNumber.self, forKey: key)
    }

    func getFor(_ key: KeyedDecodingContainer.Key) throws -> [String: Any] {
        return try decode([String: Any].self, forKey: key)
    }

    func getFor(_ key: KeyedDecodingContainer.Key, default: NSDecimalNumber) -> NSDecimalNumber {

        if let res = try? decode(NSDecimalNumber.self, forKey: key) {
            return res
        } else {
            return `default`
        }
    }

    func getOptional(for key: KeyedDecodingContainer.Key) -> NSDecimalNumber? {

        if let res = try? decode(NSDecimalNumber.self, forKey: key) {
            return res
        } else {
            return nil
        }
    }

    func decode(_ type: NSDecimalNumber.Type, forKey key: KeyedDecodingContainer.Key) throws -> NSDecimalNumber {

        if let asDecimal:Decimal = try? self.getFor(key) {
            return NSDecimalNumber(decimal: asDecimal)
        }

        let asString:String = try self.getFor(key)
        return NSDecimalNumber(string: asString)
    }

    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }

    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }

    func decodeDate(_ key: KeyedDecodingContainer.Key) throws -> Date {

        let asString:String = try self.getFor(key)
        guard let time = dateFromJSONString(asString)  else { throw NetworkError.encodingFailed }
        return time
    }

    func dateFromJSONString(_ json: String?, noTime: Bool = false) -> Date? {
        guard let json = json else { return nil }

        return noTime
            ? DateFormatterBuilder.yyyy_MM_dd.date(from: json)
            : DateFormatterBuilder.isoFull.date(from: json)
    }
}

extension UnkeyedDecodingContainer {

    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {

        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}
