import Foundation
import UIKit

protocol InfoUserPresenterProtocol: AnyObject {
    func didLoadView()
    
    func logOut()
    
    func didTapChangeImage()
    
    func didUpdateUser(user: UserData)
}

final class InfoUserPresenter  {
    weak var viewController: InfoUserView?
    
    let networkManager = NetworkManager.shared
    
    var user: UserData = UserData(name: "", surname: "", phone: "", email: "", image: UIImage(), rating: 0)
    
    init(view: InfoUserView) {
        viewController = view
    }
}

extension InfoUserPresenter: InfoUserPresenterProtocol {
    func didTapChangeImage() {
        viewController?.openImagePicker(output: self)
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
    
    func logOut() {
        networkManager.logOut()
        
        viewController?.openStartWindow()
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
    
    func didUpdateUser(user: UserData) {
        networkManager.saveUser(user: user)
    }
}

extension InfoUserPresenter: ImagePickerProtocol {
    func didSelect(image: UIImage?) {
        viewController?.loadImage(image: image)
    }
}
