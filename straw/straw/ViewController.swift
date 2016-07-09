//
//  ViewController.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: UI elements
    
    @IBOutlet weak var conditionBox: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var txtDay: UITextField!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var txtYear: UITextField!
    @IBOutlet weak var lblInstruction: UILabel!
    
    
    // MARK: model
    var fromDay = -1
    var fromMonth = -1
    var fromYear = -1
    var toDay = -1
    var choice = ""
    
    // MARK: Statistics condition
    @IBAction func btnCancel_Click(sender: UIButton) {
        hideBoxSelection()
    }
    
    @IBAction func btnOK_Click(sender: UIButton) {
        if choice == "week" {
            if (txtDay.text?.characters.count == 0 ||
                txtMonth.text?.characters.count == 0 ||
                txtYear.text?.characters.count == 0)
            {
                MessageBox.Show(self, title: "Error", message: "Need to enter information!")
            } else {
                self.fromDay = Int(txtDay.text!)!
                self.fromMonth = Int(txtMonth.text!)!
                self.fromYear = Int(txtYear.text!)!
                self.toDay = self.fromDay + 6

                
                hideBoxSelection()
                self.performSegueWithIdentifier("SegueShowPassword", sender: self)
            }
            
        } else if choice == "month"{
            if (txtMonth.text?.characters.count == 0 ||
                txtYear.text?.characters.count == 0)
            {
                MessageBox.Show(self, title: "Error", message: "Need to enter month & year!")
            } else {
                fromMonth = Int(txtMonth.text!)!
                fromYear = Int(txtYear.text!)!
                
                hideBoxSelection()
                self.performSegueWithIdentifier("SegueShowPassword", sender: self)
            }
        } else if choice == "year" {
            if (txtYear.text?.characters.count == 0)
            {
                MessageBox.Show(self, title: "Error", message: "Need to enter year!")
            } else {
                fromYear = Int(txtYear.text!)!
                hideBoxSelection()
                self.performSegueWithIdentifier("SegueShowPassword", sender: self)
            }
        }
    }
    
    func animateBoxSelection(from: CGFloat, to: CGFloat){
        self.conditionBox.alpha = from
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.conditionBox.alpha = to
            }, completion: nil)
        
    }
    
    func setupConditionBox(){
        let radius = 5
        conditionBox.layer.cornerRadius = CGFloat(radius)
        conditionBox.layer.borderWidth = 1
        conditionBox.layer.borderColor = UIColor.blueColor().CGColor
        conditionBox.alpha = 0
    }
    
    func showBoxSelection() {
        animateBoxSelection(0, to: 1)
    }
    
    func hideBoxSelection() {
        animateBoxSelection(1, to: 0)
    }
    
    // MARK: Choice Managements
    @IBAction func btnStatistics_Click(sender: UIButton) {
        let today = UIAlertAction(title: "Today", style: .Default){
            UIAlertAction in
            
            // data setup
            self.choice = "today"
            self.fromDay =  CurrentDate.Day()
            self.toDay = self.fromDay
            self.fromMonth = CurrentDate.Month()
            self.fromYear = CurrentDate.Year()
            
            self.performSegueWithIdentifier("SegueShowPassword", sender: self)
        }
        
        let byWeek = UIAlertAction(title: "By week", style: .Default){
            UIAlertAction in
            self.choice = "week"
            
            self.lblTitle.text = "Specify monday of week"
            self.lblInstruction.text = "Data will start from monday to sunday"
            
            self.txtDay.text = ""
            self.txtDay.hidden = false
            self.lblDay.hidden = false
            
            self.txtMonth.enabled = true
            self.txtMonth.text = "\(CurrentDate.Month())"
            self.txtYear.text = "\(CurrentDate.Year())"
            
            
            self.showBoxSelection()
        }
        
        let byMonth = UIAlertAction(title: "By month", style: .Default){
            UIAlertAction in
            
            self.choice = "month"
            
            self.lblTitle.text = "Specify month"
            self.lblInstruction.text = "Data will be in this month"
            
            self.txtDay.text = ""
            self.txtDay.hidden = true
            self.lblDay.hidden = true
            self.txtMonth.hidden = false
            self.lblMonth.hidden = false
            
            self.txtMonth.text = "\(CurrentDate.Month())"
            self.txtYear.text = "\(CurrentDate.Year())"

            self.showBoxSelection()
        }
        
        let byYear = UIAlertAction(title: "By year", style: .Default){
            UIAlertAction in
            
            self.choice = "year"
            
            self.lblTitle.text = "Specify year"
            self.lblInstruction.text = "Data will be in this year"
            
            self.txtDay.text = ""
            self.txtDay.hidden = true
            self.lblDay.hidden = true
            self.lblMonth.hidden = true
            self.txtMonth.hidden = true
            
            self.txtMonth.text = "\(CurrentDate.Month())"
            self.txtYear.text = "\(CurrentDate.Year())"
            
            self.showBoxSelection()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Default){
            UIAlertAction in
        }
        
        MessageBox.Show(self, title: "Type of statistics", message: "Choose one", actions: [today, byWeek, byMonth, byYear, cancel])
    }
    
    // Pass data to another controller before segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? PasswordController
        
        if segue.identifier == "SegueShowPassword" {
            destination?.fromDay = fromDay
            destination?.fromMonth = fromMonth
            destination?.fromYear = fromYear
            destination?.toDay = toDay
            destination?.choice = choice
        }
    }
    
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConditionBox()
    }
    
    // MARK: Main view
    @IBAction func btnContractor_Tapped(sender: UIButton) {
        choice = "Contractors"
        self.performSegueWithIdentifier("SegueShowPassword", sender: self)
    }
    
    @IBAction func btnWorkers_Tapped(sender: UIButton) {
        choice = "Workers"
        self.performSegueWithIdentifier("SegueShowPassword", sender: self)        
    }
    
}