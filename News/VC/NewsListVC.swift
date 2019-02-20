//
//  NewsListVC.swift
//  News
//
//  Created by Ponomarev Vasiliy on 16/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//

import UIKit

class NewsListVC: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.register(NewsListCell.self, forCellReuseIdentifier: "NewsListCell")
        tableView.tableFooterView = UIView()

        tableView.dataSource = self
        tableView.delegate = self

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()

    private var news = [NewsListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        loadData()
    }

    func loadData() {
        NetworkManager.shared.request(NewsListResponse.self,requestType: .articles) { (item, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert(title: "Упс", message: "Проверьте интернет соединение", items: .agian { _ in
                        self.loadData()
                        }, .no)
                }
                return
            }
            self.news = item?.response.news ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func setupView() {
        view.backgroundColor = .white
        view.layoutMargins = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        view.addSubview(tableView)

        tableView.makeToSuperview(.topSafeArea, .bottomSafeArea, .left, .right)
    }
}

extension NewsListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsId = news[indexPath.row].slug
        let newsArticleVC = NewsArticleVC(newsId: newsId)
        navigationController?.pushViewController(newsArticleVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: NewsListCell = tableView.dequeueReusableCell(withIdentifier: "NewsListCell") as? NewsListCell else {
            return UITableViewCell()
        }
        let item = news[indexPath.row]
        cell.set(item: item)
        cell.selectionStyle = .none
        return cell
    }
}
