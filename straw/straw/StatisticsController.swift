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
    var fromDay = -1
    var fromMonth = -1
    var fromYear = -1
    var toDay = -1
    var toMonth = -1
    var toYear = -1
    var contractors = [Contractor]()
    var workers = [[Worker]]()
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = DB.DoStatistics(fromDay, frommonth: fromMonth, fromyear: fromYear, today: toDay, tomonth: toMonth, toyear: toYear)
        contractors = data.Contractors
        workers = data.Workers
        
        if fromDay == toDay && fromMonth == toMonth && fromYear == toYear {
            lblCondition.text = "Statistics for today, \(fromDay)/\(fromMonth)/\(fromYear)"
//        } else if fromDay == toDay && fromMonth == toMonth {
//            lblCondition.text = "Statistics for year \(fromYear)"
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