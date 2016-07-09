//
//  Contractor.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//
import SQLite

class Contractor {
    var ContractorID: Int64 = -1
    var ContractorName = ""
    var PhoneNumber: String?
    
    init(id: Int64, name: String, phoneno: String?){
        ContractorID = id
        ContractorName = name
        PhoneNumber = phoneno
    }
    
    static func Insert(contractor: Contractor){
        let db = DB.GetDB()
        let table = Table("contractor")
        let name = Expression<String>("name")
        let phoneno = Expression<String?>("phonenumber")
        let rowid = try! db.run(table.insert(name <- contractor.ContractorName, phoneno <- contractor.PhoneNumber))
        contractor.ContractorID = rowid
    }
    
    static func Update(contractor: Contractor){
        let db = DB.GetDB()
        let table = Table("contractor")
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        let phoneno = Expression<String?>("phonenumber")
        let c = table.filter(id == contractor.ContractorID)
        try! db.run(c.update(name <- contractor.ContractorName, phoneno <- contractor.PhoneNumber))
    }
    
    static func Delete(contractorid: Int64){
        let db = DB.GetDB()
        let table = Table("contractor")
        let id = Expression<Int64>("id")

        let c = table.filter(id == contractorid)
        try! db.run(c.delete())
    }
}