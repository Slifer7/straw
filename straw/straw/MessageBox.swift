//
//  Alert.swift
//  straw
//
//  Created by quang on 7/7/16.
//  Copyright © 2016 slifer7. All rights reserved.
//

import UIKit

class MessageBox {
    static func Show(ui: UIViewController, title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        ui.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func Show(ui: UIViewController, title: String, message: String, actions: [UIAlertAction] ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        for action in actions{
            alert.addAction(action)
        }
        
        ui.presentViewController(alert, animated: true, completion: nil)
    }

}
