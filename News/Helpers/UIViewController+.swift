//
//  UIViewController+.swift
//  News
//
//  Created by Ponomarev Vasiliy on 20/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import UIKit
import Foundation

extension UIViewController {
    func showAlert(title: String?, message: String, items: UIAlertAction...) {
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        items.forEach(alertVc.addAction)
        present(alertVc, animated: true)
    }
}

