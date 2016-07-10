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
        let phoneno = Expression<String?>("phonenumber")
        
        try! db.run(contractor.create(ifNotExists: true){ t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(phoneno)
            })
        
        let worker = Table("worker")
        let contractorid = Expression<Int64>("contractorid")
        
            
        try! db.run(worker.create(ifNotExists: true){ t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(phoneno)
            t.column(contractorid)
        })
        
        let boxasg = Table("boxassignment") // current assignment
        let workerid = Expression<Int64>("workerid")
        
        let day = Expression<Int64>("day")
        let month = Expression<Int64>("month")
        let year = Expression<Int64>("year")
        
        let status = Expression<String>("status")
        
        let boxType = Expression<String>("boxtype")
        let boxNo = Expression<Int64>("boxno")
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
        
        let result = Table("taskresult") // current assignment
        
        try! db.run(result.create(ifNotExists: true){ t in
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
        let list = GetConfig()
        
        return list.count > 0
    }
    
    static func GetConfig() -> [(Inited: Bool, Pass: String)] {
        let db = GetDB()
        let table = Table("config")
        let inited = Expression<Bool>("inited")
        let pass = Expression<String>("pass")
        
        var list = [(Inited: Bool, Pass: String)] ()
        for row in try! db.prepare(table) {
            list += [( Inited: row[inited], Pass: row[pass] )]
        }
        
        return list
    }
    
    static func UpdateConfig(newPass: String){
        let db = GetDB()
        let table = Table("config")
        let pass = Expression<String>("pass")
        
        try! db.run(table.update(pass <- newPass))
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
        let phoneno = Expression<String?>("phonenumber")
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
                try! db.run(worker.insert(name <- workername, contractorid <- cid, phoneno <- ""))
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
        let phoneno = Expression<String?>("phonenumber")
        
        for row in try! db.prepare(table) {
            list += [ Contractor(id: row[id], name: row[name], phoneno: row[phoneno]) ]
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
        let phoneno = Expression<String?>("phonenumber")
        let contractorid = Expression<Int64>("contractorid")
        
        for row in try! db.prepare(table.select(id, name, phoneno).filter(contractorid == cid)) {
            let worker = Worker(id: row[id], name: row[name], cid: cid, phoneno: row[phoneno])
            
            // Lấy luôn cả thông tin assignment hiện có của worker của ngày hiện tại
            let asgInfo = self.GetAssignment(Int(worker.Workerid), day: CurrentDate.Day(), month: CurrentDate.Month(), year: CurrentDate.Year())
            worker.Day = asgInfo.Day
            worker.Month = asgInfo.Month
            worker.Year = asgInfo.Year
            worker.Status = asgInfo.Status
            worker.BoxType = asgInfo.BoxType
            worker.BoxNumber = asgInfo.BoxNumber
            worker.LastActionTime = asgInfo.LastActionTime
            
            list += [worker]
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
    
    static func GetAssignment(wid: Int, day: Int, month: Int, year: Int) -> Worker{
        let db = GetDB()
        
        let table = Table("boxassignment") // current assignment
        let workerid = Expression<Int64>("workerid")
        
        let d = Expression<Int64>("day")
        let m = Expression<Int64>("month")
        let y = Expression<Int64>("year")
        
        let status = Expression<String>("status")
        
        let boxType = Expression<String>("boxtype")
        let boxNo = Expression<Int64>("boxno")
        let lastActionTime = Expression<String>("time")
        
        let row = db.pluck(table.filter(workerid == Int64(wid) && d == Int64(day) && m == Int64(month) && y == Int64(year)))
        let worker = Worker(id: -1, name: "", cid: -1, phoneno: "")
        
        if row != nil{
            worker.Day = day
            worker.Month = month
            worker.Year = year
            worker.Status = row![status]
            worker.BoxType = row![boxType]
            worker.BoxNumber = Int(row![boxNo])
            worker.LastActionTime = row![lastActionTime]
        }
        
        return worker
    }
    
    // Lưu thông tin của worker xuống bảng phân công
    // Bảng này chỉ có giá trị của một ngày
    static func SaveWorkerAssignment(worker: Worker){
        let db = GetDB()
        
        let table = Table("boxassignment")
        let workerid = Expression<Int64>("workerid")
        
        let day = Expression<Int64>("day")
        let month = Expression<Int64>("month")
        let year = Expression<Int64>("year")
        
        let status = Expression<String>("status")
        
        let boxType = Expression<String>("boxtype")
        let boxNo = Expression<Int64>("boxno")
        let lastActionTime = Expression<String>("time")
        
        // Kiểm tra tồn tại trong bảng phân công chưa
        let result = table.filter(workerid == worker.Workerid && day == Int64(worker.Day) && month == Int64(worker.Month) && year == Int64(worker.Year))
        if try! db.run(result.update(status <- worker.Status, boxType <- worker.BoxType, boxNo <- Int64(worker.BoxNumber), lastActionTime <- worker.LastActionTime)) > 0 {
            print("updated")
        } else { // Chưa tồn tại nên phải chèn
            try! db.run(table.insert(workerid <- worker.Workerid, day <- Int64(worker.Day), month <- Int64(worker.Month), year <- Int64(worker.Year),
                status <- worker.Status, boxType <- worker.BoxType, boxNo <- Int64(worker.BoxNumber), lastActionTime <- worker.LastActionTime))
            print("Insert")
        }
    }
    
    
    // Mỗi khi công nhân finish thì chèn vào bảng này
    // Có sẵn trường id tự động tăng rồi
    static func SaveTaskDone(worker: Worker){
        let db = GetDB()
        
        let table = Table("taskresult")
        let workerid = Expression<Int64>("workerid")
        
        let day = Expression<Int64>("day")
        let month = Expression<Int64>("month")
        let year = Expression<Int64>("year")
        
        let status = Expression<String>("status")
        
        let boxType = Expression<String>("boxtype")
        let boxNo = Expression<Int64>("boxno")
        let lastActionTime = Expression<String>("time")
        
        // Chưa tồn tại nên phải chèn
        try! db.run(table.insert(workerid <- worker.Workerid, day <- Int64(worker.Day), month <- Int64(worker.Month), year <- Int64(worker.Year),
               status <- worker.Status, boxType <- worker.BoxType, boxNo <- Int64(worker.BoxNumber), lastActionTime <- worker.LastActionTime))
    }
    
    static func DeleteAssignment(worker: Worker){
        let db = GetDB()
        
        let table = Table("boxassignment")
        let workerid = Expression<Int64>("workerid")
        
        let day = Expression<Int64>("day")
        let month = Expression<Int64>("month")
        let year = Expression<Int64>("year")
        
        // Kiểm tra tồn tại trong bảng phân công chưa
        let result = table.filter(workerid == worker.Workerid && day == Int64(worker.Day) && month == Int64(worker.Month) && year == Int64(worker.Year))
        print(try! db.run(result.delete()))
    }
    
    // Đếm coi nhân viên đã làm xong bao nhiêu hộp của một ngày
    static func GetBoxCountByDay(workerid: Int, day: Int, month: Int, year: Int) ->Int{
        let db = GetDB()

        let count = db.scalar("SELECT count(*) FROM taskresult where workerid=\(workerid) and day=\(day) and month=\(month) and year=\(year)" ) as! Int64
        
        return Int(count)
    }
    
    // Thống kê theo ngày - Đếm coi nhân viên đã làm xong bao nhiêu hộp của từ ngày đến ngày
    static func GetBoxCount(workerid: Int, fromday: Int, frommonth: Int, fromyear: Int, today: Int) ->[Int]{
        let db = GetDB()
        var total = 0
        var boxTypes = ["250g", "500g", "1kg"]
        var boxCount = [0, 0, 0]
        
        for i in 0..<boxTypes.count {
            let type = boxTypes[i]
            let count = db.scalar("SELECT count(*) FROM taskresult where workerid=\(workerid) and day>=\(fromday) and month=\(frommonth) and year=\(fromyear) and day<=\(today) and boxtype='\(type)'" ) as! Int64
            boxCount[i] = Int(count)
        }
        
        total = boxCount.reduce(0, combine: +)
        boxCount += [total]
        
        return boxCount
    }
    
    
    // Thống kê theo tháng
    static func GetBoxCount(workerid: Int, frommonth: Int, fromyear: Int) -> [Int]{
        let db = GetDB()
        var total = 0
        var boxTypes = ["250g", "500g", "1kg"]
        var boxCount = [0, 0, 0]
        
        for i in 0..<boxTypes.count {
            let type = boxTypes[i]
            let count = db.scalar("SELECT count(*) FROM taskresult where workerid=\(workerid) and month=\(frommonth) and year=\(fromyear) and boxtype='\(type)'" ) as! Int64
            boxCount[i] = Int(count)
        }
        
        total = boxCount.reduce(0, combine: +)
        boxCount += [total]
        
        return boxCount
    }
    
   
    // Thống kê theo năm
    static func GetBoxCount(workerid: Int, fromyear: Int) -> [Int]{
        let db = GetDB()
        
        var total = 0
        var boxTypes = ["250g", "500g", "1kg"]
        var boxCount = [0, 0, 0]
        
        for i in 0..<boxTypes.count {
            let type = boxTypes[i]
            let count = db.scalar("SELECT count(*) FROM taskresult where workerid=\(workerid) and year=\(fromyear) and boxtype='\(type)'" ) as! Int64
            boxCount[i] = Int(count)
        }
            
        total = boxCount.reduce(0, combine: +)
        boxCount += [total]
        
        return boxCount
    }
    
    // Thực hiện thống kê toàn bộ từ ngày nào đến ngày nào trong năm
    static func DoStatistics(fromday: Int, frommonth: Int, fromyear: Int, today: Int) -> (Contractors: [Contractor], Workers: [[Worker]]){
        let contractors = self.GetContractors()
        let db = GetDB()
        
        var workers = [[Worker]]()
        for contractor in contractors {
            var list = [Worker]()
            
            let table = Table("worker")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let phoneno = Expression<String?>("phonenumber")
            let contractorid = Expression<Int64>("contractorid")
            
            for row in try! db.prepare(table.select(id, name, phoneno).filter(contractorid == contractor.ContractorID)) {
                let worker = Worker(id: row[id], name: row[name], cid: contractor.ContractorID, phoneno: row[phoneno])
                
                // Dùng chung số hộp và tổng số hộp
                let boxCount = self.GetBoxCount(Int(worker.Workerid), fromday: fromday, frommonth: frommonth, fromyear: fromyear, today: today)
                worker.BoxNumber = boxCount[3]
                let box250 = boxCount[0]
                let box500 = boxCount[1]
                let box1kg = boxCount[2]
                worker.boxCount = boxCount
                worker.BoxType = "     250g: \(box250)      ||      500g: \(box500)      ||      1kg: \(box1kg)"
                
                list += [worker]
            }
            workers += [list]
        }
        
        return (contractors, workers)
    }
    
    // Thống kê theo tháng
    static func DoStatistics(frommonth: Int, fromyear: Int) -> (Contractors: [Contractor], Workers: [[Worker]]){
        let contractors = self.GetContractors()
        let db = GetDB()
        
        var workers = [[Worker]]()
        for contractor in contractors {
            var list = [Worker]()
            
            let table = Table("worker")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let phoneno = Expression<String?>("phonenumber")
            let contractorid = Expression<Int64>("contractorid")
            
            for row in try! db.prepare(table.select(id, name, phoneno).filter(contractorid == contractor.ContractorID)) {
                let worker = Worker(id: row[id], name: row[name], cid: contractor.ContractorID, phoneno: row[phoneno])
                
                // Dùng chung số hộp và tổng số hộp
                let boxCount = self.GetBoxCount(Int(worker.Workerid), frommonth: frommonth, fromyear: fromyear)
                worker.BoxNumber = boxCount[3]
                let box250 = boxCount[0]
                let box500 = boxCount[1]
                let box1kg = boxCount[2]
                worker.boxCount = boxCount
                worker.BoxType = "     250g: \(box250)      ||      500g: \(box500)      ||      1kg: \(box1kg)"
                
                list += [worker]
            }
            workers += [list]
        }
        
        return (contractors, workers)
    }

    // Thống kê theo năm
    static func DoStatistics(fromyear: Int) -> (Contractors: [Contractor], Workers: [[Worker]]){
        let contractors = self.GetContractors()
        let db = GetDB()
        
        var workers = [[Worker]]()
        for contractor in contractors {
            var list = [Worker]()
            
            let table = Table("worker")
            let id = Expression<Int64>("id")
            let name = Expression<String>("name")
            let phoneno = Expression<String?>("phonenumber")
            let contractorid = Expression<Int64>("contractorid")
            
            for row in try! db.prepare(table.select(id, name, phoneno).filter(contractorid == contractor.ContractorID)) {
                let worker = Worker(id: row[id], name: row[name], cid: contractor.ContractorID, phoneno: row[phoneno])
                
                // Dùng chung số hộp và tổng số hộp
                let boxCount = self.GetBoxCount(Int(worker.Workerid), fromyear: fromyear)
                worker.BoxNumber = boxCount[3]
                let box250 = boxCount[0]
                let box500 = boxCount[1]
                let box1kg = boxCount[2]
                worker.BoxType = "     250g: \(box250)      ||      500g: \(box500)      ||      1kg: \(box1kg)"
                worker.boxCount = boxCount
                
                list += [worker]
            }
            workers += [list]
        }
        
        return (contractors, workers)
    }

}
