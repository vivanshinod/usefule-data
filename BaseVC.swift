//
//  BaseVC.swift
//  RarePlayer
//
//  Created by Nikhil Jobanputra.
//  Copyright © 2021 Bluepixel. All rights reserved.
//

import UIKit

var userDefault = UserDefaults.standard

class BaseVC: UIViewController  {
    
    static let sharedInstance = BaseVC()
    
    let dateFormatter = DateFormatter()
    
    //------------------------------------------------------
    //             MARK: - View Life Cycle -
    //------------------------------------------------------
    override func viewDidLoad(){
        
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool){
        
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool){
        
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool){
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning(){
        
        super.didReceiveMemoryWarning()
    }

    // ----------------------------------------------------------
    //                MARK: - Function -
    // ----------------------------------------------------------
    func getBuildVersion() -> String {
        
        let getVersion       = "CFBundleVersion"
        let getVersionString = "CFBundleShortVersionString"

        if let version = Bundle.main.infoDictionary?[getVersion]{
            
            if let shortVersion = Bundle.main.infoDictionary?[getVersionString]{
                
                return "\(shortVersion).\(version)"
            }
        }
        return "1.0"
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        
        return img.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
    }
    
    //MARK: - UserDefault Operation -
    func saveIntoUserDefault(value: String, key: DefaultKey){
        
        userDefault.setValue(value, forKey: key.rawValue)
        userDefault.synchronize()
    }
    
    func saveIntoUserDefaultBool(value: Bool, key: DefaultKey){
        
        userDefault.set(value, forKey: key.rawValue)
        userDefault.synchronize()
    }
    
    func saveIntoUserDefaultInt(value: Int, key: DefaultKey){
        
        userDefault.setValue(value, forKey: key.rawValue)
        userDefault.synchronize()
    }
    
    func saveIntoUserDefaultAny(value: Any, key: DefaultKey){
        
        userDefault.setValue(value, forKey: key.rawValue)
        userDefault.synchronize()
    }
    
    func removeUserDefault(key: DefaultKey){
        
        userDefault.removeObject(forKey: key.rawValue)
        userDefault.synchronize()
    }
    
    func getUserDefaultStringFromKey(_ key : DefaultKey) -> String{
        
        var value : String = String()
        if  (userDefault.value(forKey: key.rawValue) != nil){
            
            value = userDefault.string(forKey: key.rawValue) ?? ""
            return value
        }
        return value
    }
    
    func getUserDefaultBoolFromKey(_ key : String) -> Bool {
        
        var value : Bool = Bool()
        if (userDefault.value(forKey: key) != nil){
            
            value = userDefault.bool(forKey: key)
            return value
        }
        return value
    }
    
    func getUserDefaultAnyFromKey(_ key : String) -> Any?{
        
        if (userDefault.value(forKey: key) != nil){
            
            return userDefault.object(forKey: key)
        }
        return nil
    }
    
    func isExistUserDefaultKey(_ key : String) -> Bool{
        
        if (userDefault.value(forKey: key) != nil){
            
            return true;
        }
        return false;
    }
    
    
    func checkStringExist(_ string : String?) -> String{
        
        if string != nil{
            return string!
        }
        return ""
    }
    
    //MARK: - Date Converter -
    
    func currentDateTime(withFormate: String = "yyyy-MM-dd hh:mm:ss") -> String{
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withFormate
        return dateFormatter.string(from: date)
    }
    
    func convertStringToDate(stringDate: String, dateformat: String) -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformat
        
        let convertDate = dateFormatter.date(from: stringDate)
        return convertDate
    }
    
    func convertStringToStringDate(stringDate: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss", toFormate: String = "yyyy-MM-dd HH:mm:ss") -> String? {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let date = dateFormatter.date(from: stringDate) {
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = toFormate
            
                return dateFormatter.string(from: date)
            }
            return nil
        }
    
    func convertDateToString(inputDate: Date, dateformat: String = "MM/dd/yyyy") -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateformat

        let myString = formatter.string(from: inputDate) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        return formatter.string(from: yourDate!)
    }
    
    func convertDateToDate(currentDate: Date, dateformat: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateformat
        dateFormatter.timeZone = .current
        let convertDate = dateFormatter.string(from: currentDate)
        return dateFormatter.date(from: convertDate)!
    }
    
    func dateLocalToUTC(dateStr: String , fromFormate: String = "yyyy-MM-dd HH:mm:ss", toFormate: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormate
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = toFormate
        
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func dateUtcToLocal(dateStr: String, dateFormate: String = "yyyy-MM-dd HH:mm:ss", toFormate: String = "yyyy-MM-dd HH:mm:ss") -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = toFormate
        
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func timeAgoDisplay(strDate: String, ofFormat: String = "yyyy-MM-dd HH:mm:ss", toFormat: String = "MMMM dd, yyyy") -> String {
        
        let date: Date = convertStringToDate(stringDate: strDate, dateformat: ofFormat) ?? Date()

        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!

        if minuteAgo < date {
            return "Just now"//"\(diff) sec ago"
            
        } else if hourAgo < date {
            let diff = Calendar.current.dateComponents([.minute], from: date, to: Date()).minute ?? 0
            return diff < 2 ? "\(diff) minute ago" : "\(diff) minutes ago"
            
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
            
        } else if dayAgo < date {
            let diff = Calendar.current.dateComponents([.hour], from: date, to: Date()).hour ?? 0
            return diff < 2 ? "\(diff) hour ago" : "\(diff) hours ago"// "\(diff) hrs ago"
            
        } else {
            return date.toString(format: toFormat)
        }
    }
    
}
