import Foundation

protocol ListPresenterProtocol: AnyObject {
    func didRowSelect(indexPath: IndexPath)
}

final class ListPresenter  {
    weak var viewController: ListView?
    
    init(view: ListView) {
        viewController = view
    }
}

extension ListPresenter: ListPresenterProtocol {
    func didRowSelect(indexPath: IndexPath) {
        viewController?.openExcursion()
    }
}
