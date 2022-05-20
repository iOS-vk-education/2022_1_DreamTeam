//
//  ViewController.swift
//  meet2guide
//
//  Created by user on 07.04.2022.
//

import UIKit
import PinLayout


struct Excursion {
    let name: String
    let rating: Double
    let price: Double
    let mainImageURL: URL
}

protocol ListView: AnyObject {
    func openExcursion(idExcursion: String)
    
    func loadedListExcursions(excursions: Array<ExcursionData>)
}


class ListViewController: UIViewController {
    var output: ListPresenterProtocol?
    
    private let searchPanel: UISearchBar = UISearchBar()
    private let colorGrayCustom: UIColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.2)

    private let tableExcursion: UITableView = UITableView()
    
    private var excursions = Array<ExcursionData>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output?.didLoadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        searchPanel.backgroundColor = .clear
        searchPanel.searchBarStyle = .minimal
        
        tableExcursion.delegate = self
        tableExcursion.dataSource = self
        tableExcursion.register(ExcursionCell.self, forCellReuseIdentifier: "ExcursionCell")
        
        tableExcursion.separatorStyle = .none
        tableExcursion.frame = view.bounds
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableExcursion.refreshControl = refreshControl
        
        view.addSubview(searchPanel)
        view.addSubview(tableExcursion)
    }
    
    @objc
    private func didPullToRefresh() {
        output?.updateList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchPanel
            .pin
            .top(40)
            .left(5%)
            .right(5%)
            .sizeToFit(.width)
        
        tableExcursion
            .pin
            .topCenter(to: searchPanel.anchor.bottomCenter)
            .margin(10)
            .all()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcursionCell", for: indexPath) as? ExcursionCell
        
        cell?.configure(excursion: excursions[indexPath.row])
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        excursions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ExcursionCell
        
        output?.didRowSelect(idExcursion: cell.getId())
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: ListView {
    func openExcursion(idExcursion: String) {
        print(idExcursion)
        let excursionViewController = GosistTourAssembler.make(idExcursion: idExcursion)
        let navigationController = UINavigationController(rootViewController: excursionViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func loadedListExcursions(excursions: Array<ExcursionData>) {
        self.excursions = excursions
        tableExcursion.reloadData()
        tableExcursion.refreshControl?.endRefreshing()
    }
}
