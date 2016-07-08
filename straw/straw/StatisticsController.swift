//
//  StatisticsController.swift
//  straw
//
//  Created by quang on 7/8/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class StatisticsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: UI elements
    @IBOutlet weak var tblWorkers: UITableView!
    @IBOutlet weak var lblCondition: UILabel!
    
    // MARK: model
    var choice = ""
    var fromDay = -1
    var fromMonth = -1
    var fromYear = -1
    var toDay = -1

    var contractors = [Contractor]()
    var workers = [[Worker]]()
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if choice == "today" {
            lblCondition.text = "Statistics for today, \(fromDay)/\(fromMonth)/\(fromYear)"
            let data = DB.DoStatistics(fromDay, frommonth: fromMonth, fromyear: fromYear, today: toDay)
            contractors = data.Contractors
            workers = data.Workers
        } else if choice == "week"{
            lblCondition.text = "Statistics for week from \(fromDay) to \(toDay) of \(fromMonth)/\(fromYear)"
            let data = DB.DoStatistics(fromDay, frommonth: fromMonth, fromyear: fromYear, today: toDay)
            contractors = data.Contractors
            workers = data.Workers
            
        } else if choice == "month"{
            lblCondition.text = "Statistics for month \(fromMonth)/\(fromYear)"
            let data = DB.DoStatistics(fromMonth, fromyear: fromYear)
            contractors = data.Contractors
            workers = data.Workers
        } else if choice == "year"{
            lblCondition.text = "Statistics for year \(fromYear)"
            let data = DB.DoStatistics(fromYear)
            contractors = data.Contractors
            workers = data.Workers
        }        
    }
    
    // MARK: Table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return contractors.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return workers[section].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contractors[section].ContractorName
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblWorkers.dequeueReusableCellWithIdentifier("StatisticsCellID", forIndexPath: indexPath) as! StatisticsCell
        let worker = workers[indexPath.section][indexPath.row]
        cell.lblWorkerName.text = worker.WorkerName
        cell.lblInfo.text = "Total box: \(worker.BoxNumber). \(worker.BoxType)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}