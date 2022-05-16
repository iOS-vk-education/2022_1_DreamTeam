import Foundation
import UIKit


protocol AccountPresenterProtocol: AnyObject {
    func didLoadView()
    func didRowSelect(indexPath: IndexPath)

}

final class AccountPresenter: AccountPresenterProtocol {
    weak var viewController: AccountView?
    
    let networkManager = NetworkManager.shared
    
    private var user: UserData = UserData(name: "", surname: "", phone: "", email: "", image: UIImage(), rating: 0)
    
    init(view: AccountView) {
        viewController = view
    }
    
    func didLoadView() {
        networkManager.getUser { [weak self] result in
            switch result {
            case .failure(let error):
                self?.failedLoad(error: error)
                return
            case .success(let user):
                self?.viewController?.reloadData(with: user)
            }
        }
    }
    
    func didRowSelect(indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewController?.openInfoUser()
        } else if indexPath.row == 1 {
            viewController?.openGuideAdding()
        }
    }
    
    func failedLoad(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                                     style: .cancel,
                                     handler: nil)
        
        alert.addAction(okAction)
        
        viewController?.showAlert(alert: alert)
    }
}
