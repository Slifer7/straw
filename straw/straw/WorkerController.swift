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
    @IBOutlet weak var pickerContractor: UIPickerView!
    @IBOutlet weak var btnAdd: UIButton!
    
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
        btnOK.setTitle("OK", forState: .Normal)
        btnAdd.hidden = true
        
        tblWorkers.allowsSelection = false
        animateBoxSelection(dialog, from: 0, to: 1)
    }
    
    func hideDialog() {
        tblWorkers.allowsSelection = true
        animateBoxSelection(dialog, from: 1, to: 0)
    }
    
    func getDataForDialog(){
        let worker = workers[lastIndex.section][lastIndex.row]
        txtWorkerName.text = worker.WorkerName
        let index = findIndexOfWorkerContractor(worker.ContractorID)
        pickerContractor.selectRow(index, inComponent: 0, animated: true)
    
    }

    func findIndexOfWorkerContractor(workerid: Int64)->Int{
        for i in 0..<contractors.count
        {
            if contractors[i].ContractorID == workerid{
                return i
            }
        }
        
        return 0
    }
    
    
    @IBAction func btnAdd_Click(sender: UIButton) {
        let name = txtWorkerName.text!
        let index = pickerContractor.selectedRowInComponent(0)
        let contractorid = contractors[index].ContractorID
        
        let worker = Worker(id: -1, name: name, cid: contractorid)
        
        // DB update
        Worker.Insert(worker)
        
        // GUI update - Trường hợp phải move cell mệt quá nên nạp lại từ csdl cho chắc
        let data = Worker.GetWorkersGroupByContractor()
        contractors = data.Contractors
        workers = data.Workers
        tblWorkers.reloadData()
        
        hideDialog()
        dirty = false
    }
    
    @IBAction func btnUpdate_Click(sender: UIButton) {
        if dirty {
            let worker = workers[lastIndex.section][lastIndex.row]
            let name = txtWorkerName.text!
            let index = pickerContractor.selectedRowInComponent(0)
            let contractorid = contractors[index].ContractorID
            
            // DB update
            Worker.Update(worker.Workerid, name: name, cid: contractorid)
            
            // GUI update - Trường hợp phải move cell mệt quá nên nạp lại từ csdl cho chắc
            let data = Worker.GetWorkersGroupByContractor()
            contractors = data.Contractors
            workers = data.Workers
            tblWorkers.reloadData()
            
            dirty = false
        }
        
        hideDialog()
    }
    
    @IBAction func btnDelete_Click(sender: UIButton) {
        let worker = workers[lastIndex.section][lastIndex.row]
        
        // DB update
        Worker.Delete(worker.Workerid)
        
        // model update
        workers[lastIndex.section].removeAtIndex(lastIndex.row)
        
        // UI update
        tblWorkers.reloadData()
        
        hideDialog()
    }
    
    var dirty = false
    
    @IBAction func txtWorkerName_Changed(sender: UITextField) {
        dirty = true
        btnOK.setTitle("Update", forState: .Normal)
        btnAdd.hidden = false
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
        
        getDataForDialog()
        showDialog()    
    }
    
    // MARK: Picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contractors.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return contractors[row].ContractorName
    }

}
