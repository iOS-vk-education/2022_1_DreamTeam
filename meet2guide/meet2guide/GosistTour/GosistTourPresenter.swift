import Foundation

protocol GosistTourPresenterProtocol: AnyObject {
}

final class GosistTourPresenter: GosistTourPresenterProtocol {
    weak var viewController: GosistTourView?
    //private let model: InfoUserModel = InfoUserModel()
    
    init(view: GosistTourView) {
        viewController = view
    }
}
