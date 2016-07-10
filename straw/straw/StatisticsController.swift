//
//  StatisticsController.swift
//  straw
//
//  Created by quang on 7/8/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit
import MessageUI
import Foundation

class StatisticsController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
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
        
        let btnExport =  UIBarButtonItem(title: "Export", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(btnExport_Tapped))
        self.navigationItem.setRightBarButtonItems([btnExport], animated: true)
        let backButton = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backButton_Tapped))
        self.navigationItem.setLeftBarButtonItem(backButton, animated: true)
        
    }
    
    func backButton_Tapped() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func btnExport_Tapped() {
        var filename = ""
        if choice == "today" {
            filename = "Statistics_\(fromYear)\(fromMonth)\(fromDay).csv"
            
        } else if choice == "week"{
            filename = "Statistics_\(fromYear)\(fromMonth)\(fromDay)_\(toDay).csv"
        } else if choice == "month"{
            filename = "Statistics_\(fromYear)\(fromMonth).csv"
        } else if choice == "year"{
            filename = "Statistics_\(fromYear).csv"
        }
        
        let header = "Contractor name,Worker name,Worker phone,Total,250g,500g,1kg"
        var data = header + "\r\n"
        
        for i in 0..<contractors.count{
            let contractor = contractors[i]
            for j in 0..<workers[i].count {
                let worker = workers[i][j]
                let line = "\(contractor.ContractorName),\(worker.WorkerName),\(worker.PhoneNumber!),\(worker.boxCount[3]),\(worker.boxCount[0]),\(worker.boxCount[1]),\(worker.boxCount[2])\r\n"
                data += line
            }
        }
        
        // Export data to file
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(filename)
            do {
                try data.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
                
                let sendMail = UIAlertAction(title: "Send mail", style: .Default){
                    UIAlertAction in
                    self.SendMail(NSData(contentsOfURL: path)!, filename: filename)
                }
                
                let ok =  UIAlertAction(title: "OK", style: .Default){
                    UIAlertAction in
                    // Currently do nothing
                }
                
                MessageBox.Show(self, title: "Done", message: "Export successfully to \(filename)!", actions: [sendMail, ok])
            }
            catch {}
        }
        
        
    }
    
    func SendMail(path: NSData, filename: String){
        let mailComposeViewController = configuredMailComposeViewController(path, filename: filename)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            MessageBox.Show(self, title: "Error", message: "Cannot send email")
        }
    }
    
    func configuredMailComposeViewController(path: NSData, filename: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["sample@gmail.com"])
        mailComposerVC.setSubject("Statistics")
        mailComposerVC.setMessageBody("Please check attachment for detailed statistics.", isHTML: false)
        
        mailComposerVC.addAttachmentData(path, mimeType: "text/plain", fileName: filename)
        
        
        return mailComposerVC
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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