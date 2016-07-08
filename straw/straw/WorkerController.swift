//
//  WorkerController.swift
//  straw
//
//  Created by quang on 7/8/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class WorkerController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource{
    // MARK: UI Elements
    @IBOutlet weak var tblWorkers: UITableView!
    @IBOutlet weak var dialog: UIView!
    @IBOutlet weak var txtWorkerName: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    
    // MARK: Model
    var lastIndex = NSIndexPath()
    var contractors = [Contractor]()
    var workers = [[Worker]]()
    
    // MARK: dialog
    func setupDialog(dialog: UIView){
        let radius = 5
        dialog.layer.cornerRadius = CGFloat(radius)
        dialog.layer.borderWidth = 1
        dialog.layer.borderColor = UIColor.blueColor().CGColor
        dialog.alpha = 0
    }
    
    func animateBoxSelection(dialog: UIView, from: CGFloat, to: CGFloat){
        dialog.alpha = from
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            dialog.alpha = to
        }, completion: nil)
    }
    
    func showDialog() {
        animateBoxSelection(dialog, from: 0, to: 1)
    }
    
    func hideDialog() {
        animateBoxSelection(dialog, from: 1, to: 0)
    }

    @IBAction func btnAdd_Click(sender: UIButton) {
        
        hideDialog()
    }
    
    @IBAction func btnUpdate_Click(sender: UIButton) {
        if dirty {
            
            
            
            dirty = false
        }
        
        hideDialog()
    }
    
    @IBAction func btnDelete_Click(sender: UIButton) {
        hideDialog()
    }
    
    var dirty = false
    
    @IBAction func txtWorkerName_Changed(sender: UITextField) {
        dirty = true
        btnOK.setTitle("Update", forState: .Normal)
    }
    
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDialog(dialog)
        
        let data = Worker.GetWorkersGroupByContractor()
        contractors = data.Contractors
        workers = data.Workers
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
        let cell = tblWorkers.dequeueReusableCellWithIdentifier("WorkerCellID", forIndexPath: indexPath) as! WorkerCell
        let worker = workers[indexPath.section][indexPath.row]
        cell.lblWorkerName.text = worker.WorkerName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndex = indexPath
        showDialog()    
    }
    
    // MARK: Picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "A"
    }

}
