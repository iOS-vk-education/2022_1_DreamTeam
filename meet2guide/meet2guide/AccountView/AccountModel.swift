import UIKit

final class AccountModel {
    var user: User = User(name: "Иван", surname: "Иванович", phone: "", email: "8 (800) 555-35-35", image: UIImage(systemName: "person")!, rating: 4.87)
    
    func loadData() {
        self.user = User(name: "Иван", surname: "Иванович", phone: "", email: "8 (800) 555-35-35", image: UIImage(systemName: "person")!, rating: 4.87)
    }
}
