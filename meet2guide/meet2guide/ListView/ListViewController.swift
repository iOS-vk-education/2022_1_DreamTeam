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
    
    func loadIdAdded(with ids: Array<String>)
    
    func loadMyExcursions(with ids: Array<String>)
}


class ListViewController: UIViewController {
    var output: ListPresenterProtocol?
    
    private let searchPanel: UISearchBar = UISearchBar()
    private let colorGrayCustom: UIColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.2)

    private let tableExcursion: UITableView = UITableView()
    
    private var excursions = Array<ExcursionData>()
    
    private var loading = LoadingViewController()
    
    private var addedExcursionsId = Array<String>()
    
    private var myExcursionsId = Array<String>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loading.modalPresentationStyle = .overCurrentContext
        loading.modalTransitionStyle = .crossDissolve
        present(loading, animated: true, completion: nil)
        output?.didLoadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

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
        var isAdded: Bool = false
        if addedExcursionsId.contains(idExcursion) {
            isAdded = true
        } else {
            isAdded = false
        }
        
        var isAdding = false
        
        if myExcursionsId.contains(idExcursion) {
            isAdding = false
        } else {
            isAdding = true
        }
        let excursionViewController = GosistTourAssembler.make(idExcursion: idExcursion, isAdding: isAdding, isAdded: isAdded)
        let navigationController = UINavigationController(rootViewController: excursionViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func loadedListExcursions(excursions: Array<ExcursionData>) {
        self.excursions = excursions
        tableExcursion.reloadData()
        tableExcursion.refreshControl?.endRefreshing()
        loading.dismiss(animated: true, completion: nil)
    }
    
    func loadIdAdded(with ids: Array<String>) {
        self.addedExcursionsId = ids
    }
    
    func loadMyExcursions(with ids: Array<String>) {
        myExcursionsId = ids
    }
}
