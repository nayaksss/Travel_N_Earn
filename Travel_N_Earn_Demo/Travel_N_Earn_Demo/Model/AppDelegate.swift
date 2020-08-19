//
//  AppDelegate.swift
//  Travel_N_Earn_Demo
//
//  Created by Vinayak Balaji Tuptewar on 30/05/20.
//  Copyright © 2020 Vinayak Balaji Tuptewar. All rights reserved.
//

import UIKit
import SQLite3
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        createPlistDatabaseForLoginSignup()
        createSqliteDatabaseForProject()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        return true
    }
    
    
    

    //MARK: create plist database for login/signup
    func createPlistDatabaseForLoginSignup(){
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbpath = url.appendingPathComponent("LoginSignup.plist")
        print(dbpath)
        let filemanager = FileManager()
        
        if filemanager.fileExists(atPath: dbpath.path){
            print("Plist database already present.")
        }else{
//            filemanager.createFile(atPath: dbpath.path, contents: nil, attributes: nil)
            var dic = NSMutableDictionary.init(contentsOfFile: dbpath.path)
            if dic == nil{
                dic = NSMutableDictionary()
//                print("dic is nil")
            }
            dic?.write(to: dbpath, atomically: true)
            print("Plist database created.")
        }
        
    }
    
    
    
    
    //MARK: sqlite database for project
    func createSqliteDatabaseForProject(){
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let dbpath = url.appendingPathComponent("TravelN.sqlite")
        print(dbpath)
        let filemanager = FileManager()
        var ptr:OpaquePointer?
        
        if filemanager.fileExists(atPath: dbpath.path){
            print("Sqlite database already present")
        }else{
            if sqlite3_open(dbpath.path, &ptr) == SQLITE_OK{
                let query = "create table data(username varchar(50) primary key,traveller varchar(50),mobile varchar(20),boardingcountry varchar(50),landingcountry varchar(50),boardingdate varchar(50),landingdate varchar(50),weight double,address varchar(50))"
                if sqlite3_exec(ptr, query, nil, nil, nil)==SQLITE_OK{
                    print("table created successfully")
                    print(query)
                }else{
                    print("fail to create table")
                }
            }else{
                print("Fail open database")
            }
        }
    }
    
}

