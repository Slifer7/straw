//
//  BoxManController.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class BoxManController : UIViewController, UITableViewDelegate, UITableViewDataSource , UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK: UI elements
    @IBOutlet weak var txtFilterName: UITextField!
    @IBOutlet weak var dialogBoxSelection: UIView!
    @IBOutlet weak var tblWorkers: UITableView!
    @IBOutlet weak var btnFinish: UIButton!
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustDialogs()
    }
    
    func adjustDialogs(){
        let radius = 5
        dialogBoxSelection.layer.cornerRadius = CGFloat(radius)
        dialogBoxSelection.layer.borderWidth = 1
        dialogBoxSelection.layer.borderColor = UIColor.blueColor().CGColor
        
    }
    
    // MARK: Box selection
    @IBAction func btnTake_Click(sender: UIButton) {
        
    }

    @IBAction func btnCancel_Click(sender: UIButton) {
        hideBoxSelection()
    }
    
    func hideBoxSelection() {
        self.dialogBoxSelection.alpha = 1
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.dialogBoxSelection.alpha = 0
            }, completion: nil)
    }
    
    func showBoxSelection() {
        self.dialogBoxSelection.alpha = 0
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.dialogBoxSelection.alpha = 1
            }, completion: nil)
    }
    
    
    
    // MARK: Table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblWorkers.dequeueReusableCellWithIdentifier("BoxCellID", forIndexPath: indexPath) as! BoxManCell
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tblWorkers.dequeueReusableCellWithIdentifier("BoxCellID", forIndexPath: indexPath) as! BoxManCell
        cell.selectionStyle = .None
        
        
        showBoxSelection()
    }
    
    // MARK: Picker view
    var box = ["250g", "500g", "1kg"]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return box.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return box[row]
    }


}
