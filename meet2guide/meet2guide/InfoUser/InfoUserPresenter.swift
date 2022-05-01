import Foundation

protocol InfoUserPresenterProtocol: AnyObject {
    func didLoadView()
    
    func logOut()
}

final class InfoUserPresenter  {
    weak var viewController: InfoUserView?
    private let model: InfoUserModel = InfoUserModel()
    
    var user: User {
        return model.user
    }
    
    init(view: InfoUserView) {
        viewController = view
    }
}

extension InfoUserPresenter: InfoUserPresenterProtocol {
    func didLoadView() {
        model.loadData()
        viewController?.reloadData(with: user)
    }
    
    func logOut() {
        model.logOut()
        
        viewController?.openStartWindow()
    }
}
