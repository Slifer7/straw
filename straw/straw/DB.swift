//
//  DB.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import SQLite

class DB {
    // Để dành phòng khi làm vụ share
    static func GetPath() -> String{
        let path = NSSearchPathForDirectoriesInDomains(
            .ApplicationSupportDirectory, .UserDomainMask, true
            ).first! + NSBundle.mainBundle().bundleIdentifier!
        
        // create parent directory iff it doesn’t exist
        try! NSFileManager.defaultManager().createDirectoryAtPath(
            path, withIntermediateDirectories: true, attributes: nil
        )
        
        return path
    }
    
    static func GetDB() -> Connection {
        self.CreateDbIfNeeded()
        let path = self.GetPath()
        let db = try! Connection("\(path)/db.sqlite3")
        
        return db
    }

    // Kiểm tra chương trình đã chạy lần nào chưa để khởi tạo trước danh sách
    static func CreateDbIfNeeded(){
        let path = self.GetPath()
        let db = try! Connection("\(path)/db.sqlite3")
        
        let config = Table("config")
        let id = Expression<Int64>("id")
        let inited = Expression<Bool>("inited")
        let pass = Expression<String>("pass")
        
        try! db.run(config.create(ifNotExists: true){ t in
            t.column(id, primaryKey: true)
            t.column(inited)
            t.column(pass)
            })
        
        let contractor = Table("contractor")
        let name = Expression<String>("name")
        
        try! db.run(contractor.create(ifNotExists: true){ t in
            t.column(id, primaryKey: true)
            t.column(name)
            })
        
        let worker = Table("worker")
        let contractorid = Expression<Int64>("contractorid")
        
        try! db.run(worker.create(ifNotExists: true){ t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(contractorid)
            })
        
        let boxasg = Table("boxassignment")
        let workerid = Expression<Int64>("workerid")
        
        let day = Expression<Int64>("day")
        let month = Expression<Int64>("month")
        let year = Expression<Int64>("year")
        
        let status = Expression<String>("status")
        
        let boxType = Expression<String>("boxtype")
        let boxNo = Expression<String>("boxno")
        let lastActionTime = Expression<String>("time")
        
        try! db.run(boxasg.create(ifNotExists: true){ t in
            t.column(id, primaryKey: true)
            t.column(workerid)
            t.column(day)
            t.column(month)
            t.column(year)
            t.column(status)
            t.column(boxType)
            t.column(boxNo)
            t.column(lastActionTime)
        })
    }
    
    // Kiểm tra chương trình đã chạy lên lần đầu chưa, nếu chưa thì tạo csdl và khởi tạo dữ liệu ban đầu
    static func CheckInit() -> Bool{
        var list = [(ID: Int, Inited: Bool, Pass: String)]()
        
        let table = Table("config")
        let id = Expression<Int64>("id")
        let inited = Expression<Bool>("inited")
        let pass = Expression<String>("pass")
        
        let db = GetDB()
        for row in try! db.prepare(table) {
            list += [ (Int(row[id]), row[inited], row[pass]) ]
        }
        
        return list.count > 0
    }
    
    // Khởi tạo một số giá trị ban đầu, một số là code cứng
    static func Init(){
        let db = GetDB()
        
        // Tạo bảng cấu hình
        let table = Table("config")
        let inited = Expression<Bool>("inited") // Đã khởi tạo hay chưa
        let pass = Expression<String>("pass")   // Mật khẩu dùng thống kê theo tuần, tháng và năm.
        
        try! db.run(table.insert(inited <- true, pass <- "123456"))
        
        // Tạo bảng contractor
        let contractor = Table("contractor")
        let name = Expression<String>("name")
        
        let contractors = ["Contractor 1", "Contractor 2", "Contractor 3", "Contractor 4"]
        var contractorids = [Int64]()
        
        for item in contractors{
            let rowid = try! db.run(contractor.insert(name <- item))
            contractorids += [rowid]
        }
        
        // Tạo bảng công nhân
        let worker = Table("worker")
        let contractorid = Expression<Int64>("contractorid")
        var groups = [
            ["Bobby", "Valen", "Bruno", "Alice", "Sky", "Colin", "Jay", "Harry", "Lucy", "William",
                "Gail", "Henry", "Tony", "Jessi", "Colbie", "Dan", "Yuan", "Chi", "Jenna", "Hoya", "Chloe", "Mao", "Peng", "Nikkie",
                "Angel", "Rex", "Rumi", "Roy", "Pong", "Dixon", "Jill", "Ling", "Daisuke", "Ming", "Duffy", "Tasha", "Bombi", "Nell",
                "Kai", "Ivy", "Joanne", "Zoe", "Denise", "Yuklan", "Teddy"],
            ["Aanika", "Komal"],
            ["Hien", "Anh", "Tram", "Hanh", "Dung", "Diem", "Thanh", "Linh", "Han"],
            ["Nan", "Kay", "Kerry", "Alex", "Danny", "Stacey"]]
        
        for i in 0..<contractorids.count{
            let cid = contractorids[i]
            for workername in groups[i]{
                try! db.run(worker.insert(name <- workername, contractorid <- cid))
            }
        }
    }
    
    // Lấy toàn bộ các contractor
    static func GetContractors()-> [Contractor]{
        var list = [Contractor]()
        
        let db = GetDB()
        let table = Table("contractor")
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        
        for row in try! db.prepare(table) {
            list += [ Contractor(id: row[id], name: row[name]) ]
        }
        
        return list
    }
    
    // Lấy danh sách các nhân viên của một contractor
    static func GetWorkerOfContractor(cid: Int64) -> [Worker]{
        var list = [Worker]()
        
        let db = GetDB()
        let table = Table("worker")
        let id = Expression<Int64>("id")
        let name = Expression<String>("name")
        let contractorid = Expression<Int64>("contractorid")
        
        for row in try! db.prepare(table.select(id, name).filter(contractorid == cid)) {
            list += [ Worker(id: row[id], name: row[name], cid: cid) ]
        }
        
        return list
    }
    
    // Lấy toàn bộ danh sách nhân viên gom nhóm theo contractor
    static func GetWorkersGroupByContractor() -> (Contractors: [Contractor], Workers: [[Worker]]){
        let contractors = self.GetContractors()
        var workers = [[Worker]]()
        for contractor in contractors {
            let list = GetWorkerOfContractor(contractor.ContractorID)
            workers += [list]
        }
        
        return (contractors, workers)
    }
}
