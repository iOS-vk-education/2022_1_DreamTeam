import Foundation

protocol InfoUserPresenterProtocol: AnyObject {
    init(view: InfoUserView)
    func didLoadView()
}

final class InfoUserPresenter: InfoUserPresenterProtocol {
    weak var viewController: InfoUserView?
    private let model: InfoUserModel = InfoUserModel()
    
    var user: User {
        return model.user
    }
    
    init(view: InfoUserView) {
        viewController = view
    }
    
    func didLoadView() {
        model.loadData()
        viewController?.reloadData(with: user)
    }
}
