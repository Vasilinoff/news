//
//  DateFormatterBuilder.swift
//  BrokerAppCore
//
//  Created by Andrey Raevnev on 13/02/2019.
//  Copyright © 2019 BCS. All rights reserved.
//

import Foundation

extension Locale {
    static var `default`: Locale {
        return Locale(identifier: "en_US_POSIX")
    }

    static var ru: Locale {
        return Locale(identifier: "ru_RU")
    }
}

extension Date {
    enum Formats: String {
        case HHmm           = "HH:mm"
        case HHmmss         = "HH:mm:ss"

        case ddMM           = "dd.MM"
        case ddMMyy         = "dd.MM.yy"
        case ddMMyyyy       = "dd.MM.yyyy"
        case ddMMyyyyг      = "dd.MM.yyyyг."
        case ddMMyyyyHHmm   = "dd.MM.yyyy (HH:mmмск)"
        case ddMMyyyyHHmmss = "dd.MM.yyyy HH:mm:ss"

        case dMMM           = "d MMM"
        case dMMMyyyy       = "d MMM, yyyy"

        case ddMMMM         = "dd MMMM"
        case ddMMMMyyyy     = "dd MMMM yyyy"
        case dMMMM          = "d MMMM"
        case dMMMMyyyy      = "d MMMM, yyyy"

        case dd             = "dd"
        case MMM            = "MMM"
        case yyyy           = "yyyy"
        case LLLL           = "LLLL"

        case yyyyMMdd       = "yyyyMMdd"
        case yyyy_MM_dd     = "yyyy-MM-dd"

        case iso8601        = "yyyy-MM-dd'T'HH:mm:ss"
        case iso8601ZZZ     = "yyyy-MM-dd'T'HH:mm:ssZZZ"
        case isoFull        = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        case relative       = "relative"
    }
}

struct DateFormatterBuilder {
    
    static let HHmm       = dateFormatter(.HHmm)
    static let HHmmss     = dateFormatter(.HHmmss)
    static let ddMM       = dateFormatter(.ddMM)
    static let ddMMyy     = dateFormatter(.ddMMyy)
    static let ddMMyyyy   = dateFormatter(.ddMMyyyy)
    static let dMMM       = dateFormatter(.dMMM)
    static let dMMMyyyy   = dateFormatter(.dMMMyyyy)
    static let ddMMMM     = dateFormatter(.ddMMMM)
    static let ddMMMMyyyy = dateFormatter(.ddMMMMyyyy)
    static let dMMMM      = dateFormatter(.dMMMM)
    static let yyyyMMdd   = dateFormatter(.yyyyMMdd)
    static let yyyy_MM_dd = dateFormatter(.yyyy_MM_dd)
    static let isoFull    = dateFormatter(.isoFull)
    
    /**
     Создает форматтер для дат с заданными настройками.
     
     - parameter dateFormat: Строковый формат даты.
     - parameter timeZone: Часовой пояс.
     - parameter locale: Локаль.
     
     - returns: Форматтер DateFormatter.
     */
    static func dateFormatter(_ dateFormat: String, timeZone: TimeZone = TimeZone.autoupdatingCurrent, locale: Locale = Locale.current as Locale) -> DateFormatter {
        let formatter = DateFormatter()
        
        formatter.locale     = locale
        formatter.timeZone   = timeZone
        formatter.dateFormat = dateFormat
        
        return formatter
    }
    
    /**
     Создает форматтер для дат с заданными настройками.
     
     - parameter dateFormat: Строковый формат даты из заданного набора.
     - parameter timeZone: Часовой пояс.
     - parameter locale: Локаль.
     
     - returns: Форматтер DateFormatter.
     */
    static func dateFormatter(_ dateFormat: Date.Formats, timeZone: TimeZone = TimeZone.autoupdatingCurrent, locale: Locale = Locale.default) -> DateFormatter {
        switch dateFormat {
        case .dMMM, .dMMMyyyy, .ddMMMM, .ddMMMMyyyy, .dMMMM:
            return dateFormatter(dateFormat.rawValue, timeZone: timeZone, locale: Locale.current)
        default:
            return dateFormatter(dateFormat.rawValue, timeZone: timeZone, locale: locale)
        }
    }
    
    /**
     Парсит дату в формате ISO8601 и возвращает количество каждой части даты.
     
     - parameter iso8601IntervalParse: Дата в формате ISO8601.
     
     - returns: Части даты: количество лет, месяцев, дней и т.д.
     */
    static func iso8601IntervalParse(_ isoInterval: String?) -> (years: Int, months: Int, days: Int, hours: Int, minutes: Int, seconds: Int) {
        var years = 0, months = 0, days = 0, hours = 0, minutes = 0, seconds = 0
        
        guard let interval = isoInterval else {
            return (years: years, months: months, days: days, hours: hours, minutes: minutes, seconds: seconds)
        }
        
        var stringValue = ""
        var value       = 0
        
        for char in interval {
            if char == "P" || char == "T" {
                continue;
            }
            
            switch(String(char)) {
            case "Y": years   = value
            case "M": months  = value
            case "D": days    = value
            case "H": hours   = value
            case "m": minutes = value
            case "S": seconds = value
            default:
                guard let _ = Int(String(char)) else { continue }
                
                stringValue += String(char)
                if let v = Int(stringValue) {
                    value = v
                }
            }
        }
        
        return (years: years, months: months, days: days, hours: hours, minutes: minutes, seconds: seconds)
    }
    
    static func dMMMMHHmmString(from date: Date) -> String {
        return "\(DateFormatterBuilder.dMMMM.string(from: date)), \(DateFormatterBuilder.HHmm.string(from: date))"
    }
    
    static func ddMMyyyyHHmmString(from date: Date) -> String {
        return "\(DateFormatterBuilder.ddMMyyyy.string(from: date)), \(DateFormatterBuilder.HHmm.string(from: date))"
    }
}
