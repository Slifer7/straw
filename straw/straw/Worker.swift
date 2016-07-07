//
//  Worker.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

class Worker{
    var Workerid: Int64 = -1
    var WorkerName = ""
    var ContractorID:Int64 = -1
    
    var Day = -1
    var Month = -1
    var Year = -1
    
    var Status = "" // "", Taken, Finished
    var BoxNumber = -1
    var BoxType = "" // 250g 500g or 1kg
    
    var LastActionTime = "" // Lưu lại lần thao tác cuối cùng
    
    init(id: Int64, name: String, cid: Int64){
        Workerid = id
        WorkerName = name
        ContractorID = cid
    }
}