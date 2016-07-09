//
//  PasswordController.swift
//  straw
//
//  Created by quang on 7/9/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class PasswordController : UIViewController {
    // MARK: UI Elements
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var dialogChangePassword: UIView!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtNewPasswordAgain: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    
    // MARK: model
    var fromDay = -1
    var fromMonth = -1
    var fromYear = -1
    var toDay = -1
    var choice = ""
    
    
    // MARK: Initial load
    override func viewDidLoad() {
        super.viewDidLoad()
        txtPassword.text = "" // Quan trọng: cần reset lại
        dialogChangePassword.alpha = 0
        setupDialog(dialogChangePassword)
        
        if (choice == "today"){
            self.performSegueWithIdentifier("SegueShowStatistics", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? StatisticsController
        
        if segue.identifier == "SegueShowStatistics" {
            destination?.fromDay = fromDay
            destination?.fromMonth = fromMonth
            destination?.fromYear = fromYear
            destination?.toDay = toDay
            destination?.choice = choice
        }
    }
    
    @IBAction func btnOK_Tapped(sender: UIButton) {
        if txtPassword.text?.characters.count == 0{
            MessageBox.Show(self, title: "Error", message: "Please enter password")
        } else {
            let config = DB.GetConfig()[0]
            let pass = txtPassword.text!
            
            if config.Pass != pass {
                MessageBox.Show(self, title: "Error", message: "Password is incorrect!")
            }else { // Correct password
                txtPassword.text = "" // Tạm thời reset đỡ ô mật khẩu về rỗng khi bấm back
                if choice == "Workers" {
                    self.performSegueWithIdentifier("SegueShowWorkers", sender: self)
                } else if choice == "Contractors" {
                    self.performSegueWithIdentifier("SegueShowContractors", sender: self)
                }
                else {
                    self.performSegueWithIdentifier("SegueShowStatistics", sender: self)
                }
            }
        }
    }
    
    
    @IBAction func btnChagePassword_Tapped(sender: UIButton) {
        showDialog()
    }
    
    
    // MARK: Change password dialog
    func setupDialog(dialog: UIView){
        let radius = 5
        dialog.layer.cornerRadius = CGFloat(radius)
        dialog.layer.borderWidth = 1
        dialog.layer.borderColor = UIColor.blueColor().CGColor
        dialog.alpha = 0
        
        viewPassword.layer.cornerRadius = CGFloat(radius)
        viewPassword.layer.borderWidth = 1
        viewPassword.layer.borderColor = UIColor.blueColor().CGColor
    }
    
    func animateBoxSelection(dialog: UIView, from: CGFloat, to: CGFloat){
        dialog.alpha = from
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            dialog.alpha = to
            }, completion: nil)
    }
    
    func showDialog() {
        viewPassword.hidden = true
        animateBoxSelection(dialogChangePassword, from: 0, to: 1)
    }
    
    func hideDialog() {
        viewPassword.hidden = false
        animateBoxSelection(dialogChangePassword, from: 1, to: 0)
    }
    
    @IBAction func btnUpdate_Tapped(sender: UIButton) {
        if txtOldPassword.text?.characters.count == 0 {
            MessageBox.Show(self, title: "Error", message: "Please type your old password")
        } else if txtNewPassword.text?.characters.count == 0{
            MessageBox.Show(self, title: "Error", message: "Please type new password")
        } else if txtNewPasswordAgain.text?.characters.count == 0{
            MessageBox.Show(self, title: "Error", message: "Please type again new password")
        } else if txtNewPassword.text! != txtNewPasswordAgain.text!{
            MessageBox.Show(self, title: "Error", message: "Password retype does not match.")
        } else if txtOldPassword.text! == txtNewPassword.text!{
            MessageBox.Show(self, title: "Error", message: "Old password and new password are the same! Please change!")
        } else { // Sai mật khẩu cũ
            let config = DB.GetConfig()[0]
            let pass = txtOldPassword.text!
            if config.Pass != pass {
                MessageBox.Show(self, title: "Error", message: "Old password is not corrent")
            } else {
                let newPass = txtNewPassword.text!
                DB.UpdateConfig(newPass)
                hideDialog()
                MessageBox.Show(self, title: "Success", message: "Password updated!")
            }
        }
    }
    
    @IBAction func btnClose_Tapped(sender: UIButton) {
        hideDialog()
    }
}
