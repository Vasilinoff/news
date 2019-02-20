//
//  DirectionalConstraint.swift
//  News
//
//  Created by Ponomarev Vasiliy on 18/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import UIKit
import Foundation

enum DirectionalConstraint {
    case topSpaceTo(UIView, CGFloat)
    case bottomSpaceTo(UIView, CGFloat)
    case leftSpaceTo(UIView, CGFloat)
    case rightSpaceTo(UIView, CGFloat)
    case equalWidth(UIView)
    case equal(UIView)
    case centerY(UIView)
    case rightSpace(UIView, CGFloat)
    case bottomSpace(UIView, CGFloat)

    func make(_ view: UIView) {
        switch self {
        case let .topSpaceTo(directView, space):
            ViewConstraint.topSpaceTo(space).make(view, destinationView: directView)
        case let .bottomSpaceTo(directView, space):
            ViewConstraint.bottomSpaceTo(space).make(view, destinationView: directView)
        case let .leftSpaceTo(directView, space):
            ViewConstraint.leftSpaceTo(space).make(view, destinationView: directView)
        case let .rightSpaceTo(directView, space):
            ViewConstraint.rightSpaceTo(space).make(view, destinationView: directView)
        case let .equalWidth(directView):
            ViewConstraint.width.make(view, destinationView: directView)
        case let .equal(directView):
            ViewConstraint.equal.make(view, destinationView: directView)
        case let .centerY(directView):
            ViewConstraint.centerYSpace(0).make(view, destinationView: directView)
        case let .rightSpace(directView, space):
            ViewConstraint.rightSpace(space).make(view, destinationView: directView)
        case let .bottomSpace(directView, space):
            ViewConstraint.bottomSpace(space).make(view, destinationView: directView)
        }
    }
}
