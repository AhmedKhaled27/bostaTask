//
//  UIViewController + Extension.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 19/02/2023.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    
    func showIndicator() {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.isUserInteractionEnabled = false
        indicator.show(animated: true)
        self.view.isUserInteractionEnabled = false
    }
    
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
