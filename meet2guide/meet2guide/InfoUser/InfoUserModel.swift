import UIKit

protocol InfoUserModelProtocol {
    func logOut()
}

final class InfoUserModel {
    var user: User = User(name: "Иван", surname: "Иванович", phone: "8 (800) 555-35-35", email: "pochta@bmstu.student.ru", image: UIImage(systemName: "person")!, rating: 4.87)
    
    func loadData() {
        self.user = User(name: "Иван", surname: "Иванович", phone: "8 (800) 555-35-35", email: "pochta@bmstu.student.ru", image: UIImage(systemName: "person")!, rating: 4.87)
    }
    
    private let networkManager: NetworkManagerProtocol = NetworkManager.shared
}

extension InfoUserModel: InfoUserModelProtocol {
    func logOut() {
        networkManager.logOut()
    }
    
    
}
