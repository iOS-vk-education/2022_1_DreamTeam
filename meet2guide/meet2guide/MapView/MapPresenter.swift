import Foundation

protocol MapPresenterProtocol: AnyObject {
    func getExcursions()
    
    func openInfo(with excursion: ExcursionData)
}

final class MapPresenter {
    weak var viewController: MapView?
    
    private let networkManager = NetworkManager.shared

    init(view: MapView) {
        viewController = view
    }
}

extension MapPresenter: MapPresenterProtocol {
    func getExcursions() {
        networkManager.observeUpdateExcursions { [weak self] result in
            switch result {
            case .success(let excursions):
                self?.viewController?.reloadData(with: excursions)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func openInfo(with excursion: ExcursionData) {
        viewController?.openInfo(with: excursion)
    }
}
