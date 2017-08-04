import UIKit

class SpendingVC: UIViewController {
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
    }
}
