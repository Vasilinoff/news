//
//  ConstraintViewDSL+.swift
//  News
//
//  Created by Ponomarev Vasiliy on 18/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import UIKit
import Foundation

extension UIView {

    // MARK: ViewConstraint
    /**
     Создает констренты относительно другой вью
     */
    func makeTo(_ view: UIView, _  constraints: ViewConstraint...) {
        constraints.forEach { $0.make(self, destinationView: view) }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    /**
     Создает констренты относительно другой вью + можем создать SelfConstraint
     */
    func makeTo(_ view: UIView, _  constraints: ViewConstraint..., add selfConstraints: [SelfConstraint]) {
        constraints.forEach { $0.make(self, destinationView: view) }
        selfConstraints.forEach { $0.make(self) }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: SelfConstraint
    /**
     Создает констренты без завязок на другие вью
     */
    func makeSelf(constraints: SelfConstraint...) {
        constraints.forEach { $0.make(self) }
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: SuperviewConstraint
    /**
     Позиционируем вью относительно супервью при этом используем отступы заданные для супервью через layoutMargins  + дополнительно можем задать один направленный констрейнт
     */
    func makeToSuperview(_ constraints: SuperviewConstraint..., add directionalConstraint: DirectionalConstraint? = nil) {
        if let directionalConstraint = directionalConstraint {
            makeToSuperview(constraints, add: [directionalConstraint])
        } else {
            makeToSuperview(constraints, add: [])
        }
    }
    /**
     Позиционируем вью относительно супервью при этом используем отступы заданные для супервью через layoutMargins  + дополнительно задаем направленные констрейнты
     */
    func makeToSuperview(_ constraints: SuperviewConstraint..., adds directionalConstraints: [DirectionalConstraint]) {
        makeToSuperview(constraints, add: directionalConstraints)
    }

    /**
     Позиционируем вью относительно супервью при этом используем отступы заданные для супервью через layoutMargins  + дополнительно задаем направленные констрейнты
     */
    private func makeToSuperview(_ constraints: [SuperviewConstraint], add directionalConstraints: [DirectionalConstraint]) {
        guard let superview = self.superview else {
            fatalError("View doesn't have superview")
        }

        constraints.forEach { $0.make(self, superview: superview, edgeInsets: superview.layoutMargins) }
        directionalConstraints.forEach { $0.make(self)}
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    /**
     Позиционируем вью относительно супервью при этом используем отступы заданные для супервью через layoutMargins  + дополнительно можем задать один направленный констрейнт
     */
    func makeToSuperview(_ constraints: SuperviewConstraint..., addSelf selfConstraints: SelfConstraint) {
        makeToSuperview(constraints, addSelf: [selfConstraints])
    }

    /**
     Позиционируем вью относительно супервью при этом используем отступы заданные для супервью через layoutMargins  + дополнительно задаем SelfConstraint
     */
    func makeToSuperview(_ constraints: SuperviewConstraint..., addsSelf selfConstraints: [SelfConstraint]) {
        makeToSuperview(constraints, addSelf: selfConstraints)
    }

    /**
     Позиционируем вью относительно супервью при этом используем отступы заданные для супервью через layoutMargins  + дополнительно задаем  SelfConstraint
     */
    private func makeToSuperview(_ constraints: [SuperviewConstraint], addSelf selfConstraints: [SelfConstraint]) {
        guard let superview = self.superview else {
            fatalError("View doesn't have superview")
        }

        constraints.forEach { $0.make(self, superview: superview, edgeInsets: superview.layoutMargins) }
        selfConstraints.forEach { $0.make(self) }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
