//
//  ContractorController.swift
//  straw
//
//  Created by quang on 7/8/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class ContractorController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: UI elements
    
    @IBOutlet weak var tblContractors: UITableView!
    @IBOutlet weak var txtContractorName: UITextField!
    @IBOutlet weak var boxInfo: UIView!
    @IBOutlet weak var btnOK: UIButton!
    
    // MARK: Dialog
    @IBAction func btnUpdate_Click(sender: AnyObject) {
        if (dirty){
            let contractor = contractors[lastIndex.row]
            contractor.ContractorName = txtContractorName.text!
            Contractor.Update(contractor)
            tblContractors.reloadData()
            dirty = false
        }
        hideBoxSelection()
    }
    
    @IBAction func btnDelete_Click(sender: UIButton) {
        let contractor = contractors[lastIndex.row]
        Contractor.Delete(contractor.ContractorID)
        contractors.removeAtIndex(lastIndex.row)
        tblContractors.reloadData()
        hideBoxSelection()
    }
    
    @IBAction func btnInsert(sender: UIButton) {
        let contractor = Contractor(id: -1, name: txtContractorName.text!)
        Contractor.Insert(contractor)
        contractors += [contractor]
        tblContractors.reloadData()
        hideBoxSelection()
        dirty = false
    }
    
    func setupbox(){
        let radius = 5
        boxInfo.layer.cornerRadius = CGFloat(radius)
        boxInfo.layer.borderWidth = 1
        boxInfo.layer.borderColor = UIColor.blueColor().CGColor
        boxInfo.alpha = 0
    }
    
    func animateBoxSelection(from: CGFloat, to: CGFloat){
        self.boxInfo.alpha = from
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.boxInfo.alpha = to
        }, completion: nil)
    }
    
    func showBoxSelection() {
        btnOK.setTitle("OK", forState: .Normal)
        animateBoxSelection(0, to: 1)
    }
    
    func hideBoxSelection() {
        animateBoxSelection(1, to: 0)
    }
    var dirty = false
    
    @IBAction func txtContractorName_Changed(sender: UITextField) {
        dirty = true
        btnOK.setTitle("Update", forState: .Normal)
    }
    
    // MARK: model
    var contractors = DB.GetContractors()
    var lastIndex = NSIndexPath()
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupbox()
    }
    
    
    // MARK: Table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contractors.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "List of contractors"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tblContractors.dequeueReusableCellWithIdentifier("ContractorCellID", forIndexPath: indexPath) as! ContractorCell
        let contractor = contractors[indexPath.row]
        cell.lblContractor.text = contractor.ContractorName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastIndex = indexPath
        
        let contractor = contractors[indexPath.row]
        txtContractorName.text = contractor.ContractorName
        showBoxSelection()
    }
    
}
