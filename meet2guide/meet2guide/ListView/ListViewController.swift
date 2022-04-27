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
    func openExcursion()
}


class ListViewController: UIViewController, ListView {
    var output: ListPresenterProtocol?
    
    private let searchPanel: UISearchBar = UISearchBar()
    private let colorGrayCustom: UIColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 0.2)
    /*
    private let tabBar: UITabBar = UITabBar()
    private let mapTabBarItem: UITabBarItem = UITabBarItem()
    private let favoriteTabBarItem: UITabBarItem = UITabBarItem()
    private let accountTabBarItem: UITabBarItem = UITabBarItem()
    private let searchTabBarItem: UITabBarItem = UITabBarItem()*/
    private let tableExcursion: UITableView = UITableView()

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
        
        view.addSubview(searchPanel)
        view.addSubview(tableExcursion)
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
            .width((self.view.window?.frame.width ?? 310))
            .height((self.view.window?.frame.height ?? 310) - 1000)
    }
    
    func openExcursion() {
        let excursionViewController = GosistTourAssembler.make()
        let navigationController = UINavigationController(rootViewController: excursionViewController)
        present(navigationController, animated: true, completion: nil)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExcursionCell", for: indexPath) as? ExcursionCell
        
        //cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell ?? .init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output?.didRowSelect(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
