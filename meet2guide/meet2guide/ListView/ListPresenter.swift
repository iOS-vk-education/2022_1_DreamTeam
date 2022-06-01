import Foundation

protocol ListPresenterProtocol: AnyObject {
    func didRowSelect(idExcursion: String)
    
    func didLoadView()
    
    func updateList()
}

final class ListPresenter  {
    weak var viewController: ListView?
    
    private let networkManager = NetworkManager.shared
    
    init(view: ListView) {
        viewController = view
    }
}

extension ListPresenter: ListPresenterProtocol {
    func didRowSelect(idExcursion: String) {
        viewController?.openExcursion(idExcursion: idExcursion)
    }
    
    func didLoadView() {
        networkManager.loadListExcursion { [weak self] result in
            switch result {
            case .success(let excursions):
                self?.viewController?.loadedListExcursions(excursions: excursions)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        networkManager.getExcursionsIdByUser { [weak self] result in
            switch result {
            case .success(let excustionsId):
                self?.viewController?.loadIdAdded(with: excustionsId)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        networkManager.getAddedExcursionsIdByUser { [weak self] result in
                switch result {
                case .success(let excustionsId):
                    self?.viewController?.loadMyExcursions(with: excustionsId)
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    func updateList() {
        networkManager.loadListExcursion { [weak self] result in
            switch result {
            case .success(let excursions):
                self?.viewController?.loadedListExcursions(excursions: excursions)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
