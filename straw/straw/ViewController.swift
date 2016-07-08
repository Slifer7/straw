//
//  ViewController.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: model
    var fromDay = -1
    var fromMonth = -1
    var fromYear = -1
    var toDay = -1
    var toMonth = -1
    var toYear = -1
    
    
    @IBAction func btnStatistics_Click(sender: UIButton) {
        let today = UIAlertAction(title: "Today", style: .Default){
            UIAlertAction in
            
            // data setup
            self.fromDay =  CurrentDate.Day()
            self.toDay = self.fromDay
            self.fromMonth = CurrentDate.Month()
            self.toMonth = self.fromMonth
            self.fromYear = CurrentDate.Year()
            self.toYear = self.fromYear
            
            self.performSegueWithIdentifier("SegueStatistics", sender: self)
        }
        
        let byWeek = UIAlertAction(title: "By week", style: .Default){
            UIAlertAction in
        }
        
        let byMonth = UIAlertAction(title: "By month", style: .Default){
            UIAlertAction in
        }
        
        let byYear = UIAlertAction(title: "By year", style: .Default){
            UIAlertAction in
        }
        
        MessageBox.Show(self, title: "Type of statistics", message: "Choose one", actions: [today, byWeek, byMonth, byYear])
    }
    
    // Pass data to another controller before segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? StatisticsController
        
        if segue.identifier == "SegueStatistics" {
            destination?.fromDay = fromDay
            destination?.fromMonth = fromMonth
            destination?.fromYear = fromYear
            destination?.toDay = fromDay
            destination?.toMonth = toMonth
            destination?.toYear = toYear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
}