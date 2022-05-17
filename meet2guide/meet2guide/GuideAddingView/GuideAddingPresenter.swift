import Foundation
import UIKit


protocol GuideAddingPresenterProtocol: AnyObject {
    func didTapChangeImage()
    
    func addExcursion(excursion: ExcursionData)
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
}

extension GuideAddingPresenter: ImagePickerProtocol {
    func didSelect(image: UIImage?) {
        viewController?.loadImage(image: image)
    }
}
