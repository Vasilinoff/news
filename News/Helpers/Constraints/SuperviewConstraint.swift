//
//  ConstraintViewDSL+Superview+Directional.swift
//  News
//
//  Created by Ponomarev Vasiliy on 18/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import Foundation
import UIKit

/**
 СуперВью констренты, позиционируют вью относительно супервью
 */
enum SuperviewConstraint {

    case edges
    case left
    case right
    case leftRight(CGFloat)
    case top
    case bottom
    case centerX
    case centerY

    // SafeArea
    case topSafeArea
    case bottomSafeArea

    case heightMult(CGFloat)
    case widthMult(CGFloat)

    // swiftlint:disable cyclomatic_complexity
    func make(_ view: UIView, superview: UIView, edgeInsets: UIEdgeInsets) {

        func activate(_ viewContrst: ViewConstraint) {
            viewContrst.make(view, destinationView: superview)
        }

        switch self {
        case .edges: activate(.edges)
        case .left: activate(.leftSpace(edgeInsets.left))
        case .right: activate(.rightSpace(edgeInsets.right))
        case .leftRight(let offset):
            activate(.leftSpace(offset))
            activate(.rightSpace(offset))
        case .top: activate(.topSpace(edgeInsets.top))
        case .bottom: activate(.bottomSpace(edgeInsets.bottom))
        case .centerY: activate(.centerYSpace(0))
        case .centerX: activate(.centerXSpace(0))

        //SafeArea
        case .topSafeArea:
            if #available(iOS 11.0, *) {
                view.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: edgeInsets.top).isActive = true
            } else {
                activate(.topSpace(edgeInsets.top))
            }
        case .bottomSafeArea:
            if #available(iOS 11.0, *) {
                view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -edgeInsets.bottom).isActive = true
            } else {
                activate(.bottomSpace(edgeInsets.bottom))
            }

        case let .heightMult(multiplier):
            view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: multiplier).isActive = true
        case let .widthMult(multiplier):
            view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: multiplier).isActive = true
        }
    }
}
