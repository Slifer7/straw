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
    @IBOutlet weak var txtBoxNo: UITextField!
    @IBOutlet weak var pickerBoxes: UIPickerView!
    
    // MARK: model section
    var lastIndex = NSIndexPath()
    var contractors = [Contractor]()
    var workers = [[Worker]]()
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup UI
        setupBoxSelection()
        
        // Setup model
        let data = DB.GetWorkersGroupByContractor()
        contractors = data.Contractors
        workers = data.Workers
    }
    
    // MARK: Box selection
    @IBAction func btnTake_Click(sender: UIButton) {
        if txtBoxNo.text?.characters.count == 0{
            MessageBox.Show(self, title: "Error", message: "Please specify box number!")
        } else {
            let boxType = box[pickerBoxes.selectedRowInComponent(0)]
            let boxNo = Int(txtBoxNo.text!)!
            
            let worker = workers[lastIndex.section][lastIndex.row]
            worker.Status = "Taken"
            worker.Day = CurrentDate.Day()
            worker.Month = CurrentDate.Month()
            worker.Year = CurrentDate.Year()
            
            worker.BoxType = boxType
            worker.BoxNumber = boxNo
            
            worker.LastActionTime = CurrentDate.ShortTimeString()
            
            hideBoxSelection()
            tblWorkers.reloadData()
 
            DB.SaveWorkerAssignment(worker)
        }
    }
    
    @IBAction func btnFinish_Click(sender: UIButton) {
        let worker = workers[lastIndex.section][lastIndex.row]
        worker.Status = "Finished"
        worker.LastActionTime = CurrentDate.ShortTimeString()
        hideBoxSelection()
        tblWorkers.reloadData()
        
        DB.SaveTaskDone(worker)
        DB.DeleteAssignment(worker)
    }

    @IBAction func btnCancel_Click(sender: UIButton) {
        hideBoxSelection()
    }
    
    func animateBoxSelection(from: CGFloat, to: CGFloat){
        self.dialogBoxSelection.alpha = from
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.dialogBoxSelection.alpha = to
        }, completion: nil)
    }
    
    func setupBoxSelection(){
        let radius = 5
        dialogBoxSelection.layer.cornerRadius = CGFloat(radius)
        dialogBoxSelection.layer.borderWidth = 1
        dialogBoxSelection.layer.borderColor = UIColor.blueColor().CGColor
        btnFinish.enabled = false
        btnFinish.alpha = 0.5
        lblFinished.enabled = false
        lblFinished.alpha = 0.5
        btnClear.enabled = false
        btnClear.alpha = 0.2
    }
    
    func showBoxSelection() {
        animateBoxSelection(0, to: 1)
        tblWorkers.allowsSelection = false
    }
    
    func hideBoxSelection() {
        animateBoxSelection(1, to: 0)
        tblWorkers.allowsSelection = true
        
        tblWorkers.reloadData()
    }
    
    @IBAction func btnClearInfo_Click(sender: UIButton) {
        let worker = workers[lastIndex.section][lastIndex.row]
        worker.Status = ""
        worker.BoxType = ""
        worker.BoxNumber = -1
        tblWorkers.reloadData()
        hideBoxSelection()
        
        DB.DeleteAssignment(worker)
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
        let cell = tblWorkers.dequeueReusableCellWithIdentifier("BoxCellID", forIndexPath: indexPath) as! BoxManCell
        let worker = workers[indexPath.section][indexPath.row]
        cell.txtWorkerName.text = worker.WorkerName
        
        if (worker.Status == "") {// Nothing
            cell.imgBoxTaken.hidden = true
            cell.txtBoxType.hidden = true
            cell.imgFinish.hidden = true
            cell.txtFinish.hidden = true
            cell.txtLastActionTime.hidden = false
            cell.txtLastActionTime.text = ""
        } else if (worker.Status == "Taken"){
            cell.imgBoxTaken.hidden = false
            cell.txtBoxType.hidden = false
            cell.txtBoxType.text = worker.BoxType
            cell.imgFinish.hidden = true
            cell.txtFinish.hidden = true
            cell.txtLastActionTime.hidden = false
            cell.txtLastActionTime.text = "Box #\(worker.BoxNumber). Last action time: \(worker.LastActionTime)"
        } else if (worker.Status == "Finished"){
            cell.imgBoxTaken.hidden = false
            cell.txtBoxType.hidden = false
            cell.imgFinish.hidden = false
            cell.txtFinish.hidden = false
            cell.txtLastActionTime.text = "Box #\(worker.BoxNumber). Last action time: \(worker.LastActionTime)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndex = indexPath
        let worker = workers[indexPath.section][indexPath.row]
        
        if worker.Status == "" || worker.Status == "Finished" {
            DisableFinishButton()
            showBoxSelection()
        } else if worker.Status == "Taken" {
            AutoFillDataToBoxSelectionDialog(worker)
            EnableFinishButton()
            showBoxSelection()
        }
        
        print(DB.GetBoxCountByDay(Int(worker.Workerid), day: CurrentDate.Day(), month: CurrentDate.Month(), year: CurrentDate.Year()))
    }
    
    func EnableFinishButton(){
        btnFinish.enabled = true
        lblFinished.enabled = true
        btnClear.alpha = 1
        btnClear.enabled = true
    }
    
    func DisableFinishButton(){
        btnFinish.enabled = false
        lblFinished.enabled = false
        btnClear.alpha = 0.2
        btnClear.enabled = true
    }
    
    func AutoFillDataToBoxSelectionDialog(worker: Worker){
        pickerBoxes.selectRow(box.indexOf(worker.BoxType)!, inComponent: 0, animated: true)
        txtBoxNo.text = String(worker.BoxNumber)
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
