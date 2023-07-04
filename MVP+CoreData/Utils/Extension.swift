//
//  Extension.swift
//  MVP+CoreData
//
//  Created by Umang on 16/06/23.
//

import UIKit
import Toast
 
extension UIView {
    func roundedCorners() {
        self.layer.cornerRadius = self.frame.width / 2
    }
    
    func setCorners(ofRadius: CGFloat = 4) {
        self.layer.cornerRadius = ofRadius
    }
}

extension UIViewController {
    func showToast(_ message: String) {
        self.view.makeToast(message)
    }
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

extension String {
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        if self.first == "." || self.first == "@" || self.first == "_" {
            return false
        } else if ((self.components(separatedBy: "@")[0]).last == ".") {
            return false
        } else if self.contains("..") == true{
            return false
        } else {
            return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
        }
    }
}
