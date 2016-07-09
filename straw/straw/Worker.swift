//
//  Worker.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//
import SQLite

class Worker{
    var Workerid: Int64 = -1
    var WorkerName = ""
    var ContractorID:Int64 = -1
    var PhoneNumber: String?
    
    var Day = -1
    var Month = -1
    var Year = -1
    
    var Status = "" // "", Taken, Finished
    var BoxNumber = -1
    var BoxType = "" // 250g 500g or 1kg
    
    var LastActionTime = "" // Lưu lại lần thao tác cuối cùng
    
    init(id: Int64, name: String, cid: Int64, phoneno: String?){
        Workerid = id
        WorkerName = name
        ContractorID = cid
        PhoneNumber = phoneno
    }
    
    static func GetWorkersGroupByContractor() -> (Contractors: [Contractor], Workers: [[Worker]]){
        let contractors = DB.GetContractors()
        var workers = [[Worker]]()
        for contractor in contractors {
            let list = GetWorkerOfContractor(contractor.ContractorID)
            workers += [list]
        }
        
        return (contractors, workers)
    }
    
    static func GetWorkerOfContractor(cid: Int64) -> [Worker]{
        var list = [Worker]()
        
        let db = DB.GetDB()
        let table = Table("worker")
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        let phoneno = Expression<String?>("phonenumber")
        let contractorid = Expression<Int64>("contractorid")
        
        for row in try! db.prepare(table.select(id, name, phoneno).filter(contractorid == cid)) {
            let worker = Worker(id: row[id], name: row[name], cid: cid, phoneno: row[phoneno])
            list += [worker]
        }
        
        return list
    }
    
    static func Update(wid: Int64, name: String, cid: Int64, phone: String?){
        let db = DB.GetDB()
        let table = Table("worker")
        let id = Expression<Int64>("id")
        let wname = Expression<String>("name")
        let phoneno = Expression<String?>("phonenumber")
        let contractorid = Expression<Int64>("contractorid")
        
        let w = table.filter(id == wid)
        try! db.run(w.update(wname <- name, contractorid <- cid, phoneno <- phone))
    }
    
    static func Insert(worker: Worker){
        let db = DB.GetDB()
        let table = Table("worker")
        let wname = Expression<String>("name")
        let phoneno = Expression<String?>("phonenumber")
        let contractorid = Expression<Int64>("contractorid")
 
        let rowid = try! db.run(table.insert(wname <- worker.WorkerName, contractorid <- worker.ContractorID, phoneno <- worker.PhoneNumber))
        worker.Workerid = rowid
    }
    
    static func Delete(wid: Int64){
        let db = DB.GetDB()
        let table = Table("worker")
        let id = Expression<Int64>("id")
        
        let w = table.filter(id == wid)
        try! db.run(w.delete())
    }
}