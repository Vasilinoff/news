//
//  ConstraintViewDSL+ViewConstraint.swift
//  News
//
//  Created by Ponomarev Vasiliy on 18/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import Foundation
import UIKit
/**
 Вью констренты, относительно вью с которой будет вызывается метод make
 */
enum ViewConstraint {
    case edges
    case topSpace(CGFloat)
    case bottomSpace(CGFloat)
    case leftSpace(CGFloat)
    case rightSpace(CGFloat)
    case centerXSpace(CGFloat)
    case centerYSpace(CGFloat)

    case topSpaceTo(CGFloat)
    case bottomSpaceTo(CGFloat)
    case leftSpaceTo(CGFloat)
    case rightSpaceTo(CGFloat)

    case width
    case equal

    func make(_ view: UIView, destinationView: UIView) {
        switch self {
        case .edges:
            let margins = destinationView.layoutMargins
            view.topAnchor.constraint(equalTo: destinationView.topAnchor, constant: margins.top).isActive = true
            view.bottomAnchor.constraint(equalTo: destinationView.bottomAnchor, constant: -margins.bottom).isActive = true
            view.leadingAnchor.constraint(equalTo: destinationView.leadingAnchor, constant: margins.left).isActive = true
            view.trailingAnchor.constraint(equalTo: destinationView.trailingAnchor, constant: -margins.right).isActive = true
        case let .topSpace(space):
            view.topAnchor.constraint(equalTo: destinationView.topAnchor, constant: space).isActive = true
        case let .bottomSpace(space):
            view.bottomAnchor.constraint(equalTo: destinationView.bottomAnchor, constant: -space).isActive = true
        case let .leftSpace(space):
            view.leftAnchor.constraint(equalTo: destinationView.leftAnchor, constant: space).isActive = true
        case let .rightSpace(space):
            view.rightAnchor.constraint(equalTo: destinationView.rightAnchor, constant: -space).isActive = true
        case let .centerXSpace(space):
            view.centerXAnchor.constraint(equalTo: destinationView.centerXAnchor, constant: space).isActive = true
        case let .centerYSpace(space):
            view.centerYAnchor.constraint(equalTo: destinationView.centerYAnchor, constant: space).isActive = true
        case let .topSpaceTo(space):
            view.topAnchor.constraint(equalTo: destinationView.bottomAnchor, constant: space).isActive = true
        case let .bottomSpaceTo(space):
            view.bottomAnchor.constraint(equalTo: destinationView.topAnchor, constant: -space).isActive = true
        case let .leftSpaceTo(space):
            view.leftAnchor.constraint(equalTo: destinationView.rightAnchor, constant: space).isActive = true
        case let .rightSpaceTo(space):
            view.rightAnchor.constraint(equalTo: destinationView.leftAnchor, constant: -space).isActive = true

        case .width:
            view.widthAnchor.constraint(equalTo: destinationView.widthAnchor).isActive = true
        case .equal:
            view.widthAnchor.constraint(equalTo: destinationView.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: destinationView.heightAnchor).isActive = true
        }
    }
}
