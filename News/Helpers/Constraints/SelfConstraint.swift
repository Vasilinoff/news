//
//  ConstraintViewDSL+SelfConstraint.swift
//  News
//
//  Created by Ponomarev Vasiliy on 18/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import Foundation
import UIKit
/**
 Констренты для самой вью
 */
enum SelfConstraint {
    case width(CGFloat)
    case height(CGFloat)
    case widthHeight(CGFloat)

    func make(_ view: UIView) {
        switch self {
        case let .width(val): view.widthAnchor.constraint(equalToConstant: val).isActive = true
        case let .height(val): view.heightAnchor.constraint(equalToConstant: val).isActive = true
        case let .widthHeight(val):
            view.heightAnchor.constraint(equalToConstant: val).isActive = true
            view.widthAnchor.constraint(equalToConstant: val).isActive = true
        }
    }
}
