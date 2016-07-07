//
//  NSDate.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//
import Foundation

extension NSDate
{
    func Day() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Day, fromDate: self)
        let day = components.day
        
        return day
    }
    
    
    func Month() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Month, fromDate: self)
        let month = components.month
        
        return month
    }
    
    func Year() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Year, fromDate: self)
        let year = components.year
        
        return year
    }
    
    func Hour() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        
        return hour
    }
    
    
    func Minute() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        
        return minute
    }
    
    func Second() -> Int {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.Second, fromDate: self)
        let second = components.second
        
        return second
    }
    
    func ToShortTimeString() -> String
    {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString = formatter.stringFromDate(self)
        
        return timeString
    }
}

class CurrentDate {
    func Day() -> Int {
        return NSDate().Day()
    }
    
    func Month() -> Int {
        return NSDate().Month()
    }
    
    func Year() -> Int {
        return NSDate().Year()
    }
    
    func ShortTimeString() -> String {
        let hour = NSDate().Hour()
        let minute = NSDate().Minute()
        let second = NSDate().Second()
        
        return "\(hour):\(minute):\(second)"
    }
    
}