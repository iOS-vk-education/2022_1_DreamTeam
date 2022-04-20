import Foundation

protocol MapPresenterProtocol: AnyObject {
}

final class MapPresenter: MapPresenterProtocol {
    weak var viewController: MapView?

    init(view: MapView) {
        viewController = view
    }

}
