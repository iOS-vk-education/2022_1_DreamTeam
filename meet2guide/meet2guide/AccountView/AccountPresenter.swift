import Foundation

protocol AccountPresenterProtocol: AnyObject {
    init(view: AccountView)
    func didLoadView()
    func didRowSelect(indexPath: IndexPath)
}

final class AccountPresenter: AccountPresenterProtocol {
    weak var viewController: AccountView?
    private let model: AccountModel = AccountModel()
    
    var user: User {
        return model.user
    }
    
    init(view: AccountView) {
        viewController = view
    }
    
    func didLoadView() {
        model.loadData()
        viewController?.reloadData(with: user)
    }
    
    func didRowSelect(indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewController?.openInfoUser()
        }
    }
}
