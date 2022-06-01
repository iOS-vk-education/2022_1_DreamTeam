//
//  UserExcursionPresenter.swift
//  meet2guide
//
//  Created by Екатерина Григоренко on 01.06.2022.
//

import Foundation
import UIKit

protocol UserExcursionPresenterProtocol: AnyObject {
    func didLoadView()
    
    func didDeleteCard(with id: String)
    
    func didInfo(with id: String)
    
    func deleteCard(with id: String)
}

final class UserExcursionPresenter  {
    weak var viewController: UserExcursionView?
    
    let networkManager = NetworkManager.shared

    init(view: UserExcursionView) {
        viewController = view
    }
}

extension UserExcursionPresenter: UserExcursionPresenterProtocol {
    func didLoadView() {
        networkManager.getExcursionsAddedByUser { [weak self] result in
            switch result {
            case .success(let listExcursions):
                self?.viewController?.reloadData(with: listExcursions)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didDeleteCard(with id: String) {
        deleteAlert(with: id)
    }
    
    func didInfo(with id: String) {
        viewController?.openExcursion(with: id)
    }
    
    func deleteAlert(with id: String) {
        let alert = UIAlertController(title: "Удалить",
                                      message: "Вы уверены, что хотите удалить экскурсию?",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Удалить",
                                     style: .cancel) { [weak self] _ in
            self?.deleteCard(with: id)
        }
        
        let closeAction = UIAlertAction(title: "Закрыть",
                                        style: .default,
                                        handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(closeAction)
        
        viewController?.showAlert(alert: alert)
    }
    
    func deleteCard(with id: String) {
        networkManager.updateUserExcurions(with: id)
        /*if viewController?.getExcursions().count == 1 {
            didLoadView()
        }*/
        networkManager.deleteExcrusion(with: id)
    }
}
