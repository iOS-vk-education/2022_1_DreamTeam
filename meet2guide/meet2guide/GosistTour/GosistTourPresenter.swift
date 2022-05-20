import Foundation

protocol GosistTourPresenterProtocol: AnyObject {
    func didLoadView(with id: String)
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
}
