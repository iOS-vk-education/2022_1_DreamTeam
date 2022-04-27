import Foundation

protocol ListPresenterProtocol: AnyObject {
    func didRowSelect(indexPath: IndexPath)
}

final class ListPresenter: ListPresenterProtocol {
    weak var viewController: ListView?
    //private let model: InfoUserModel = InfoUserModel()
    
    init(view: ListView) {
        viewController = view
    }
    
    func didRowSelect(indexPath: IndexPath) {
        viewController?.openExcursion()
    }
}
