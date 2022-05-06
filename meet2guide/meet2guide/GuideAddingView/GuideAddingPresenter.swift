import Foundation


protocol GuideAddingPresenterProtocol: AnyObject {
    
}


class GuideAddingPresenter {
    weak var viewController: GuideAddingView?
    
    init(view: GuideAddingView) {
        viewController = view
    }
}

extension GuideAddingPresenter: GuideAddingPresenterProtocol {
    
}
