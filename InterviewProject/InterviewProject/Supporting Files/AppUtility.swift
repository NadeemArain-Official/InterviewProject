//
//  AppUtility.swift
//  InterviewProject
//
//  Created by Nadeem Arain on 4/17/19.
//  Copyright © 2019 logics limited. All rights reserved.
//

import Foundation
import UIKit

class AppUtility: NSObject {

    static let shared = AppUtility()
    
    func displayAlert(title titleTxt:String, messageText msg:String, delegate controller:UIViewController) ->()
    {
        
        let alertController = UIAlertController(title: titleTxt, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async(execute: { () -> Void in
            controller.present(alertController, animated: true, completion: nil)
            
        });
        
    }

}
