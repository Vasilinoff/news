//
//  NewsListVC.swift
//  News
//
//  Created by Ponomarev Vasiliy on 16/02/2019.
//  Copyright © 2019 vasilek. All rights reserved.
//
import CoreData
import UIKit

class NewsListVC: UIViewController {

    let nManager = NetworkManager<NewsApi>()
    let sManager = DataService()

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
    private var loadingInProgress = false
    private var news = [NewsListItem]()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Новости"

        setupView()

        do {
            self.news = try sManager.getNewsListItem()
        } catch {
            self.news = []
        }
        loadData(offset: 0)
    }

    func loadData(offset: Int) {
        let offset = self.news.count
        loadingInProgress = true

        nManager.request(NewsListResponse.self, requestType: .articles(offset: offset)) { (item, error) in
            self.loadingInProgress = false
            if error != nil {
                self.showAlert(title: "Упс", message: "Проверьте интернет соединение", items: .agian { _ in
                    self.loadData(offset: offset)
                    }, .no)
                return
            }
            if offset == 0 {
                self.sManager.deleteAllNews()
            }
            item?.response.news.forEach({ item in
                self.sManager.saveNewsListItem(item)
            })
            self.news += item?.response.news ?? []
            self.tableView.reloadData()
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
        let slug = news[indexPath.row].slug
        let newsId = news[indexPath.row].id
        let newsArticleVC = NewsArticleVC(slug: slug, newsId: newsId)
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

extension NewsListVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentSize.height < scrollView.frame.size.height {
            return
        }

        let currentOffset  = scrollView.contentOffset.y
        let maiximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset    = maiximumOffset - currentOffset

        if deltaOffset <= 150 {
            guard !loadingInProgress else { return }
            let offset = news.count
            self.loadData(offset: offset)
        }
    }
}
