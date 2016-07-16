//
//  BoxManController.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class BoxManController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    // MARK: UI elements
    @IBOutlet weak var txtFilterName: UITextField!
    @IBOutlet weak var dialogBoxSelection: UIView!
    @IBOutlet weak var tblWorkers: UITableView!
    
    @IBOutlet weak var btnFinish: UIButton!
    @IBOutlet weak var lblFinished: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    
    @IBOutlet weak var btnFinish2: UIButton!
    @IBOutlet weak var lblFinished2: UILabel!
    @IBOutlet weak var btnClear2: UIButton!
    
    @IBOutlet weak var btnFinish3: UIButton!
    @IBOutlet weak var lblFinished3: UILabel!
    @IBOutlet weak var btnClear3: UIButton!
    
    @IBOutlet weak var txtBoxNo: UITextField!
    @IBOutlet weak var txtBoxNo2: UITextField!
    @IBOutlet weak var txtBoxNo3: UITextField!
    
    
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
        
        //Lấy danh sách worker từ bảng tạm Assignment để kiểm tra và đặt lại trạng thái các hộp 250,500,1kg cho từng worker trong ds
        let workersAssigment = DB.GetWorkerInAssignment()
        for arrWorker in workers {
            for wInAssignment in workersAssigment {
                let filteredWorker = arrWorker.filter({$0.Workerid == wInAssignment.Workerid})
                
                if filteredWorker.count > 0 {
                    if wInAssignment.BoxType == box[0] {
                        filteredWorker[0].BoxNumber = wInAssignment.BoxNumber
                        filteredWorker[0].BoxType = wInAssignment.BoxType
                        filteredWorker[0].Status = wInAssignment.Status
                        filteredWorker[0].LastActionTime = wInAssignment.LastActionTime
                        filteredWorker[0].Day = wInAssignment.Day
                        filteredWorker[0].Month = wInAssignment.Month
                        filteredWorker[0].Year = wInAssignment.Year
                    }
                    if wInAssignment.BoxType2 == box[1] {
                        filteredWorker[0].BoxNumber2 = wInAssignment.BoxNumber2
                        filteredWorker[0].BoxType2 = wInAssignment.BoxType2
                        filteredWorker[0].Status2 = wInAssignment.Status2
                        filteredWorker[0].LastActionTime2 = wInAssignment.LastActionTime2
                        filteredWorker[0].Day2 = wInAssignment.Day2
                        filteredWorker[0].Month2 = wInAssignment.Month2
                        filteredWorker[0].Year2 = wInAssignment.Year2
                    }
                    if wInAssignment.BoxType3 == box[2] {
                        filteredWorker[0].BoxNumber3 = wInAssignment.BoxNumber3
                        filteredWorker[0].BoxType3 = wInAssignment.BoxType3
                        filteredWorker[0].Status3 = wInAssignment.Status3
                        filteredWorker[0].LastActionTime3 = wInAssignment.LastActionTime3
                        filteredWorker[0].Day3 = wInAssignment.Day3
                        filteredWorker[0].Month3 = wInAssignment.Month3
                        filteredWorker[0].Year3 = wInAssignment.Year3
                    }
                }
            }
            
        }
    }
    
    // MARK: Filter
    @IBAction func txtFilterName_TextChanged(sender: UITextField) {
        let data = DB.GetWorkersGroupByContractor()
        let originContractors = data.Contractors
        let originWorkers = data.Workers
        
        if txtFilterName.text?.characters.count != 0 {
            contractors = [Contractor]()
            workers = [[Worker]]()
            let pattern = txtFilterName.text!
            
            for i in 0..<originContractors.count {
                var list = [Worker]()
                
                for j in 0..<originWorkers[i].count{
                    if originWorkers[i][j].WorkerName.lowercaseString.containsString(pattern.lowercaseString){
                        list += [originWorkers[i][j]]
                    }
                }
                
                if list.count > 0 {
                    workers += [list]
                    contractors += [originContractors[i]]
                }
            }
        } else {
            let data = DB.GetWorkersGroupByContractor()
            contractors = data.Contractors
            workers = data.Workers
        }
        
        tblWorkers.reloadData()
    }
    
    // MARK: Box selection
    
    @IBAction func btnClose_Click(sender: UIButton) {
        hideBoxSelection()
    }
    
    
    @IBAction func btnTake_Click(sender: UIButton) {
        if txtBoxNo.text?.characters.count == 0{
            MessageBox.Show(self, title: "Error", message: "Please specify box number!")
        } else {
            let boxType = box[0]
            let boxNo = Int(txtBoxNo.text!)!
            
            let worker = workers[lastIndex.section][lastIndex.row]
            worker.Status = "Taken"
            worker.Day = CurrentDate.Day()
            worker.Month = CurrentDate.Month()
            worker.Year = CurrentDate.Year()
            
            worker.BoxType = boxType
            worker.BoxNumber = boxNo
            worker.LastActionTime = CurrentDate.ShortTimeString()
            
            //hideBoxSelection()
            EnableFinishButton()
            tblWorkers.reloadData()
 
            DB.SaveWorkerAssignment(worker)
        }
    }
    
    func createCopyWorker500g(worker:Worker) -> Worker {
        return Worker(id: worker.Workerid, name: worker.WorkerName, cid: worker.ContractorID, phoneno: worker.PhoneNumber, day: worker.Day2, month: worker.Month2, year: worker.Year2, status: worker.Status2, boxNumber: worker.BoxNumber2, boxType: worker.BoxType2, lastActionTime: worker.LastActionTime2)
    }
    func createCopyWorker1Kg(worker:Worker) -> Worker {
        return Worker(id: worker.Workerid, name: worker.WorkerName, cid: worker.ContractorID, phoneno: worker.PhoneNumber, day: worker.Day3, month: worker.Month3, year: worker.Year3, status: worker.Status3, boxNumber: worker.BoxNumber3, boxType: worker.BoxType3, lastActionTime: worker.LastActionTime3)
    }
    
    @IBAction func btnTake2_Click(sender: UIButton) {
        if txtBoxNo2.text?.characters.count == 0{
            MessageBox.Show(self, title: "Error", message: "Please specify box number!")
        } else {
            let boxType = box[1]
            let boxNo = Int(txtBoxNo2.text!)!
            
            let worker = workers[lastIndex.section][lastIndex.row]
        
            worker.Status2 = "Taken"
            worker.Day2 = CurrentDate.Day()
            worker.Month2 = CurrentDate.Month()
            worker.Year2 = CurrentDate.Year()
            worker.BoxType2 = boxType
            worker.BoxNumber2 = boxNo
            worker.LastActionTime2 = CurrentDate.ShortTimeString()
            
            DB.SaveWorkerAssignment(createCopyWorker500g(worker))
            
            //hideBoxSelection()
            EnableFinishButton2()
            tblWorkers.reloadData()
        }
    }
    @IBAction func btnTake3_Click(sender: UIButton) {
        if txtBoxNo3.text?.characters.count == 0{
            MessageBox.Show(self, title: "Error", message: "Please specify box number!")
        } else {
            let boxType = box[2]
            let boxNo = Int(txtBoxNo3.text!)!
            
            let worker = workers[lastIndex.section][lastIndex.row]
            worker.Status3 = "Taken"
            worker.Day3 = CurrentDate.Day()
            worker.Month3 = CurrentDate.Month()
            worker.Year3 = CurrentDate.Year()
            worker.BoxType3 = boxType
            worker.BoxNumber3 = boxNo
            worker.LastActionTime3 = CurrentDate.ShortTimeString()

            DB.SaveWorkerAssignment(createCopyWorker1Kg(worker))
            
            //hideBoxSelection()
            EnableFinishButton3()
            tblWorkers.reloadData()
        }
    }
    

    @IBAction func btnFinish_Click(sender: UIButton) {
        let worker = workers[lastIndex.section][lastIndex.row]
        worker.Status = "Finished"
        worker.LastActionTime = CurrentDate.ShortTimeString()
        //hideBoxSelection()
        DisableFinishButton()
        txtBoxNo.text = ""
        tblWorkers.reloadData()

        DB.SaveTaskDone(worker)
        DB.DeleteAssignment(worker)
    }
    @IBAction func btnFinish2_Click(sender: UIButton) {
        let worker = workers[lastIndex.section][lastIndex.row]
        worker.Status2 = "Finished"
        worker.LastActionTime2 = CurrentDate.ShortTimeString()
        //hideBoxSelection()
        DisableFinishButton2()
        txtBoxNo2.text = ""
        tblWorkers.reloadData()
        
        let tempWorker = Worker(id: worker.Workerid, name: worker.WorkerName, cid: worker.ContractorID, phoneno: worker.PhoneNumber, day: worker.Day2, month: worker.Month2, year: worker.Year2, status: worker.Status2, boxNumber: worker.BoxNumber2, boxType: worker.BoxType2, lastActionTime: worker.LastActionTime2)
        
        DB.SaveTaskDone(tempWorker)
        DB.DeleteAssignment(tempWorker)
    }
    @IBAction func btnFinish3_Click(sender: UIButton) {
        let worker = workers[lastIndex.section][lastIndex.row]
        worker.Status3 = "Finished"
        worker.LastActionTime3 = CurrentDate.ShortTimeString()
        //hideBoxSelection()
        DisableFinishButton3()
        txtBoxNo3.text = ""
        tblWorkers.reloadData()
        
        let tempWorker = Worker(id: worker.Workerid, name: worker.WorkerName, cid: worker.ContractorID, phoneno: worker.PhoneNumber, day: worker.Day3, month: worker.Month3, year: worker.Year3, status: worker.Status3, boxNumber: worker.BoxNumber3, boxType: worker.BoxType3, lastActionTime: worker.LastActionTime3)
        
        DB.SaveTaskDone(tempWorker)
        DB.DeleteAssignment(tempWorker)
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
        
        //hideBoxSelection()
        DisableFinishButton()
        
        DB.DeleteAssignment(worker)
    }
    @IBAction func btnClearInfo2_Click(sender: UIButton) {
        let worker = workers[lastIndex.section][lastIndex.row]
        worker.Status = ""
        worker.BoxType = ""
        worker.BoxNumber = -1
        tblWorkers.reloadData()
        //hideBoxSelection()
        DisableFinishButton2()
        
        DB.DeleteAssignment(worker)
    }
    @IBAction func btnClearInfo3_Click(sender: UIButton) {
        let worker = workers[lastIndex.section][lastIndex.row]
        worker.Status = ""
        worker.BoxType = ""
        worker.BoxNumber = -1
        tblWorkers.reloadData()
        //hideBoxSelection()
        DisableFinishButton3()
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
        let cell = tblWorkers.dequeueReusableCellWithIdentifier("BoxManCell2", forIndexPath: indexPath) as! BoxManCell2
        let worker = workers[indexPath.section][indexPath.row]
        if worker.PhoneNumber?.characters.count > 0 {
            cell.txtWorkerName.text = "\(worker.WorkerName) - \(worker.PhoneNumber!)"
        } else {
            cell.txtWorkerName.text = "\(worker.WorkerName)"
        }
        
        //250g
        if (worker.Status == "") {// Nothing
            cell.txtBox250.text = ""
            cell.txtBox250.hidden = true
            cell.txtLastActionTime250.hidden = false
            cell.txtLastActionTime250.text = ""
        } else if (worker.Status == "Taken"){
            cell.txtBox250.text = "250g (Taken)"
            cell.txtBox250.hidden = false
            cell.txtLastActionTime250.hidden = false
            cell.txtLastActionTime250.text = "Box #\(worker.BoxNumber). Time: \(worker.LastActionTime)"
        } else if (worker.Status == "Finished"){
            cell.txtBox250.text = "250g (Finished)"
            cell.txtBox250.hidden = false
            cell.txtLastActionTime250.text = "Box #\(worker.BoxNumber). Time: \(worker.LastActionTime)"
        }
        //500g
        if (worker.Status2 == "") {// Nothing
            cell.txtBox500.text = ""
            cell.txtBox500.hidden = true
            cell.txtLastActionTime500.hidden = false
            cell.txtLastActionTime500.text = ""
        } else if (worker.Status2 == "Taken"){
            cell.txtBox500.text = "500g (Taken)"
            cell.txtBox500.hidden = false
            cell.txtLastActionTime500.hidden = false
            cell.txtLastActionTime500.text = "Box #\(worker.BoxNumber2). Time: \(worker.LastActionTime2)"
        } else if (worker.Status2 == "Finished"){
            cell.txtBox500.text = "500g (Finished)"
            cell.txtBox500.hidden = false
            cell.txtLastActionTime500.text = "Box #\(worker.BoxNumber2). Time: \(worker.LastActionTime2)"
        }
        //1Kg
        if (worker.Status3 == "") {// Nothing
            cell.txtBox1.text = ""
            cell.txtBox1.hidden = true
            cell.txtLastActionTime1.hidden = false
            cell.txtLastActionTime1.text = ""
        } else if (worker.Status3 == "Taken"){
            cell.txtBox1.text = "1Kg (Taken)"
            cell.txtBox1.hidden = false
            cell.txtLastActionTime1.hidden = false
            cell.txtLastActionTime1.text = "Box #\(worker.BoxNumber3). Time: \(worker.LastActionTime3)"
        } else if (worker.Status3 == "Finished"){
            cell.txtBox1.text = "1Kg (Finished)"
            cell.txtBox1.hidden = false
            cell.txtLastActionTime250.text = "Box #\(worker.BoxNumber3). Time: \(worker.LastActionTime3)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndex = indexPath
        let worker = workers[indexPath.section][indexPath.row]
        
        //250g
        if worker.Status == "" || worker.Status == "Finished" {
            txtBoxNo.text = ""
            DisableFinishButton()
            showBoxSelection()
        } else if worker.Status == "Taken" {
            AutoFillDataToBoxSelectionDialog(worker)
            EnableFinishButton()
            showBoxSelection()
        }
        //500g
        if worker.Status2 == "" || worker.Status2 == "Finished" {
            txtBoxNo2.text = ""
            DisableFinishButton2()
            showBoxSelection()
        } else if worker.Status2 == "Taken" {
            AutoFillDataToBox2SelectionDialog(worker)
            EnableFinishButton2()
            showBoxSelection()
        }
        //1kg
        if worker.Status3 == "" || worker.Status3 == "Finished" {
            txtBoxNo3.text = ""
            DisableFinishButton3()
            showBoxSelection()
        } else if worker.Status3 == "Taken" {
            AutoFillDataToBox3SelectionDialog(worker)
            EnableFinishButton3()
            showBoxSelection()
        }
        
        print(DB.GetBoxCountByDay(Int(worker.Workerid), day: CurrentDate.Day(), month: CurrentDate.Month(), year: CurrentDate.Year()))
    }
    
    func EnableFinishButton(){
        btnFinish.enabled = true
        lblFinished.enabled = true
        btnClear.alpha = 1
        btnClear.enabled = true
        btnFinish.alpha = 1
        lblFinished.alpha = 1
    }
    func DisableFinishButton(){
        btnFinish.enabled = false
        lblFinished.enabled = false
        btnClear.alpha = 0.2
        btnClear.enabled = true
        btnFinish.alpha = 0.5
        lblFinished.alpha = 0.5
    }
    func EnableFinishButton2(){
        btnFinish2.enabled = true
        lblFinished2.enabled = true
        btnClear2.alpha = 1
        btnClear2.enabled = true
        btnFinish2.alpha = 1
        lblFinished2.alpha = 1
    }
    func DisableFinishButton2(){
        btnFinish2.enabled = false
        lblFinished2.enabled = false
        btnClear2.alpha = 0.2
        btnClear2.enabled = true
        btnFinish2.alpha = 0.5
        lblFinished2.alpha = 0.5
    }
    func EnableFinishButton3(){
        btnFinish3.enabled = true
        lblFinished3.enabled = true
        btnClear3.alpha = 1
        btnClear3.enabled = true
        btnFinish3.alpha = 1
        lblFinished3.alpha = 1
    }
    func DisableFinishButton3(){
        btnFinish3.enabled = false
        lblFinished3.enabled = false
        btnClear3.alpha = 0.2
        btnClear3.enabled = true
        btnFinish3.alpha = 0.5
        lblFinished3.alpha = 0.5
    }
    
    func AutoFillDataToBoxSelectionDialog(worker: Worker){
        txtBoxNo.text = String(worker.BoxNumber)
    }
    func AutoFillDataToBox2SelectionDialog(worker: Worker){
        txtBoxNo2.text = String(worker.BoxNumber2)
    }
    func AutoFillDataToBox3SelectionDialog(worker: Worker){
        txtBoxNo3.text = String(worker.BoxNumber3)
    }
    
    // MARK: Picker view
    var box = ["250g", "500g", "1kg"]
}
/*
 - Khi insert vào bảng tạm assignment thì cần check lại khóa để đảm bảo thêm 3 dòng tương ứng với 3 loại cho 1 worker
 - Để hiện thông tin ở box thì dựa vào status2, status 3 của 1 thằng worker
 - Finish thì nhớ reset status/status2/status3
 - Sửa lại thông tin mỗi Cell gồm:
    + Tên
    + Số điện thoại
    + 250g (Taken/Finished) - Label 
    + 500g (Taken/Finished) - Label
    + 1kg (Taken/Finished) - Label
 - Khi lưu xuống db thì sử dụng thuộc tính thứ nhất (boxType, boxNo,...); các trường hợp biện luận khác thì sủ dụng thuộc tính 2 hoặc 3 (boxType2, boxNo2,...)
 - Chưa kiểm trả trùng mã hộp ở các lần nhập khác nhau. Chắc không cần chỉ làm khi client y/c. Tự đảm bảo bằng mắt!!
 */