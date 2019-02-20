    //
//  NewsArticleVC.swift
//  News
//
//  Created by Ponomarev Vasiliy on 20/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import UIKit
import Foundation

typealias NewsId = String

class NewsArticleVC: UIViewController, UITextViewDelegate {
    private let scrollView = UIScrollView()
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

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isSelectable = true
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.contentInset = .zero
        textView.delegate = self
        return textView
    }()

    let newsId: NewsId

    init(newsId: NewsId) {
        self.newsId = newsId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        loadData()

    }

    deinit {
        print("check")
    }

    private func loadData() {
        NetworkManager.shared.request(NewsArticleResponse.self,requestType: .article(newsId: newsId)) { (item, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert(title: "Упс", message: "Проверьте интернет соединение", items: .agian { _ in
                            self.loadData()
                        }, .no)
                }
                return
            }
            DispatchQueue.main.async {
                self.set(item: item?.response)
            }
        }
    }

    private func setupViews() {
        view.layoutMargins = .zero
        scrollView.layoutMargins = .zero
        view.backgroundColor = .white
        view.addSubview(scrollView)

        scrollView.makeToSuperview(.topSafeArea, .bottomSafeArea, .left, .right)

        let containerView = UIView()
        containerView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        scrollView.addSubview(containerView)

        containerView.makeToSuperview(.edges, addSelf: .width(view.frame.width))

        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(textView)

        titleLabel.makeToSuperview(.left, .right, .topSafeArea)
        dateLabel.makeToSuperview(.left, .right, add: .topSpaceTo(titleLabel, 9))
        textView.makeToSuperview(.left, .right, .bottom, add: .topSpaceTo(dateLabel, 9))
    }

    private func set(item: NewsItem?) {
        guard let item = item else { return }
        titleLabel.text = item.title
        dateLabel.text = item.date
        textView.attributedText = convertHTMLStringToAttributed(string: item.text)
    }

    func convertHTMLStringToAttributed(string: String) -> NSAttributedString? {
        if let data = string.data(using: String.Encoding.utf16),
            let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            let string = NSMutableAttributedString(attributedString: attributedString)
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
            string.addAttributes(attributes, range: NSRange(location: 0, length: string.string.count))
            return string
        }
        return nil
    }
}
