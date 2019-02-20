//
//  NewsListCell.swift
//  News
//
//  Created by Ponomarev Vasiliy on 20/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import UIKit
import Foundation

class NewsListCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = .lightGray
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white

        contentView.layoutMargins = UIEdgeInsets(top: 9, left: 16, bottom: 9, right: 16)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(countLabel)

        titleLabel.makeToSuperview(.left, .top)
        dateLabel.makeToSuperview(.left, .right, .bottom, add: .topSpaceTo(titleLabel, 9))

        countLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            countLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            countLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 10),
            countLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
        ]
        countLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate(constraints)


    }

    func set(item: NewsListItem) {
        titleLabel.text = item.title
        dateLabel.text = item.date

        countLabel.text = "12 раз"
    }
}
