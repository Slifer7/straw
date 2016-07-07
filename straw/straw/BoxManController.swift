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
    @IBOutlet weak var lblFinished: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    
    
    var lastIndex = NSIndexPath()
    
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBoxSelection()
    }
    
    // MARK: Box selection
    @IBAction func btnTake_Click(sender: UIButton) {
        
    }

    @IBAction func btnCancel_Click(sender: UIButton) {
        hideBoxSelection()
    }
    
    func animateBoxSelection(from: CGFloat, to: CGFloat){
        self.dialogBoxSelection.alpha = from
        
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.dialogBoxSelection.alpha = to
            }, completion: nil)

    }
    
    func setupBoxSelection(){
        let radius = 5
        dialogBoxSelection.layer.cornerRadius = CGFloat(radius)
        dialogBoxSelection.layer.borderWidth = 1
        dialogBoxSelection.layer.borderColor = UIColor.blueColor().CGColor
        btnFinish.enabled = false
        lblFinished.enabled = false
        btnClear.enabled = false
    }
    
    func showBoxSelection() {
        animateBoxSelection(0, to: 1)
        tblWorkers.allowsSelection = false
    }
    
    func hideBoxSelection() {
        animateBoxSelection(1, to: 0)
        tblWorkers.allowsSelection = true
        tblWorkers.deselectRowAtIndexPath(lastIndex, animated: true)
        tblWorkers.reloadData()
    }
    
    // MARK: Table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblWorkers.dequeueReusableCellWithIdentifier("BoxCellID", forIndexPath: indexPath) as! BoxManCell
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndex = indexPath
        
        let cell = tblWorkers.dequeueReusableCellWithIdentifier("BoxCellID", forIndexPath: indexPath) as! BoxManCell
        //cell.selectionStyle = .None
        
        
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
