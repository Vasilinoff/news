//
//  UIAlertViewController.swift
//  News
//
//  Created by Ponomarev Vasiliy on 20/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import UIKit
import Foundation

extension UIAlertAction {
    static var ok: UIAlertAction {
        return UIAlertAction(title: "Ок", style: .default, handler: nil)
    }

    static func ok(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: "Повторить", style: .default, handler: handler)
    }

    static func yes(_ handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: "ДА", style: .default, handler: handler)
    }

    static var no: UIAlertAction {
        return UIAlertAction(title: "Нет", style: .default, handler: nil)
    }
}
