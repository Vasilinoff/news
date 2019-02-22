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

    private let networkManager = NetworkManager<NewsApi>()
    private let dataService = DataService(modelName: "News")

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

    private var isFirstLoad = true
    private var loadingInProgress = false
    private var news = [NewsListItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Новости"

        setupView()

        do {
            self.news = try dataService.getNewsListItem()
        } catch {
            self.news = []
        }
        loadData(offset: 0)
    }

    private func loadData(offset: Int) {
        let offset = self.news.count
        loadingInProgress = true

        networkManager.request(NewsListResponse.self, requestType: .articles(offset: offset)) { [weak self] (item, error) in
            guard let self = self else { return }
            self.loadingInProgress = false
            if error != nil {
                self.showAlert(title: "Упс", message: "Проверьте интернет соединение", items: .agian { _ in
                    self.loadData(offset: offset)
                    }, .no)
                return
            }
            if self.isFirstLoad {
                self.isFirstLoad = false
                self.news = []
                self.dataService.deleteAllNews()
            }
            item?.response.news.forEach({ item in
                self.dataService.saveNewsListItem(item)
            })
            self.news += item?.response.news ?? []
            self.tableView.reloadData()
        }
    }

    private func setupView() {
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
        let newsArticleVC = NewsArticleVC(networkManager: networkManager,
                                          dataService: dataService,
                                          slug: slug,
                                          newsId: newsId)
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

        if deltaOffset <= 0 {
            guard !loadingInProgress else { return }
            let offset = news.count
            self.loadData(offset: offset)
        }
    }
}
