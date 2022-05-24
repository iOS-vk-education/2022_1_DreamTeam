//
//  AddedExcursionPresenter.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 20.05.2022.
//

import Foundation

protocol AddedExcursionsPresenterProtocol: AnyObject {
    func didLoadView()
}

final class AddedExcursionsPresenter  {
    weak var viewController: AddedExcursionsView?
    
    let networkManager = NetworkManager.shared

    init(view: AddedExcursionsView) {
        viewController = view
    }
}

extension AddedExcursionsPresenter: AddedExcursionsPresenterProtocol {
    func didLoadView() {
        networkManager.getExcursionsByUser { [weak self] result in
            switch result {
            case .success(let listExcursions):
                self?.viewController?.reloadData(with: listExcursions)
            case .failure(let error):
                print(error)
            }
        }
    }
}
