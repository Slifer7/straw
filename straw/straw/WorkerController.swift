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
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    
    
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
        btnDelete.hidden = false
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
        txtPhoneNumber.text = worker.PhoneNumber
    
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

    
    @IBAction func btnUpdate_Click(sender: UIButton) {
        if addMode {
            let name = txtWorkerName.text!
            let index = pickerContractor.selectedRowInComponent(0)
            let contractorid = contractors[index].ContractorID
            let phoneno = txtPhoneNumber.text!
            
            let worker = Worker(id: -1, name: name, cid: contractorid, phoneno: phoneno)
            
            // DB update
            Worker.Insert(worker)
            
            // GUI update - Trường hợp phải move cell mệt quá nên nạp lại từ csdl cho chắc
            let data = Worker.GetWorkersGroupByContractor()
            contractors = data.Contractors
            workers = data.Workers
            tblWorkers.reloadData()
            
            hideDialog()
            dirty = false
            addMode = false
        }
        if dirty {
            let worker = workers[lastIndex.section][lastIndex.row]
            let name = txtWorkerName.text!
            let index = pickerContractor.selectedRowInComponent(0)
            var phoneno = ""
            if txtPhoneNumber.text?.characters.count > 0
            {
                phoneno = txtPhoneNumber.text!
            }
            let contractorid = contractors[index].ContractorID
            
            // DB update
            Worker.Update(worker.Workerid, name: name, cid: contractorid, phone: phoneno)
            
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
        if addMode  == false {
            dirty = true
            btnOK.setTitle("Update", forState: .Normal)
            btnDelete.hidden = true
        }
    }
    
    @IBAction func txtPhoneNumber_Changed(sender: UITextField) {
        if addMode  == false {
            dirty = true
            btnOK.setTitle("Update", forState: .Normal)
            btnDelete.hidden = true
        }
    }
    
    @IBAction func btnClose_Click(sender: UIButton) {
        addMode = false
        hideDialog()
    }
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDialog(dialog)
        
        let data = Worker.GetWorkersGroupByContractor()
        contractors = data.Contractors
        workers = data.Workers
        
        let addButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(addButton_Tapped))
        self.navigationItem.setRightBarButtonItems([addButton], animated: true)
    }
    
    var addMode = false
    
    func addButton_Tapped(){
        addMode = true
        txtWorkerName.text = ""
        txtPhoneNumber.text = ""
        showDialog()
        
        btnOK.setTitle("Add", forState: .Normal)
        btnDelete.hidden = true
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
        if worker.PhoneNumber != nil {
            if worker.PhoneNumber!.characters.count > 0 {
                cell.lblInfo.text = "Phone number: \(worker.PhoneNumber!)"
            } else {
                cell.lblInfo.text = ""
            }
        } else {
            cell.lblInfo.text = ""
        }
        
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
