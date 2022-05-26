import Foundation
import UIKit


protocol GuideAddingPresenterProtocol: AnyObject {
    func didTapChangeImage()
    
    func addExcursion(excursion: ExcursionData)
    
    func didTapOpenMap()
}


class GuideAddingPresenter {
    weak var viewController: GuideAddingView?
    
    private let networkManager = NetworkManager.shared
    
    init(view: GuideAddingView) {
        viewController = view
    }
}

extension GuideAddingPresenter: GuideAddingPresenterProtocol {
    func didTapChangeImage() {
        viewController?.openImagePicker(output: self)
    }
    
    func addExcursion(excursion: ExcursionData) {
        networkManager.addExcursion(excursion: excursion)
        print("pyk")
    }
    
    func didTapOpenMap() {
        viewController?.openMap()
    }
}

extension GuideAddingPresenter: ImagePickerProtocol {
    func didSelect(image: UIImage?) {
        viewController?.loadImage(image: image)
    }
}
