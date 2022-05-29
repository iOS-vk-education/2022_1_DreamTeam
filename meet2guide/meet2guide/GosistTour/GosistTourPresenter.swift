import Foundation

protocol GosistTourPresenterProtocol: AnyObject {
    func didLoadView(with id: String)
    
    func didAddExcursion(with id: String)
    
    func openMap()
}

final class GosistTourPresenter {
    weak var viewController: GosistTourView?
    //private let model: InfoUserModel = InfoUserModel()
    
    private let networkManager = NetworkManager.shared
    
    init(view: GosistTourView) {
        viewController = view
    }
}

extension GosistTourPresenter: GosistTourPresenterProtocol {
    func didLoadView(with id: String) {
        networkManager.getExcursion(with: id) { [weak self] result in
            switch result {
            case .success(let excursion):
                self?.viewController?.reloadData(with: excursion)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didAddExcursion(with id: String) {
        networkManager.addExcursionToUser(with: id)
    }
    
    func openMap() {
        viewController?.openMap()
    }
}
