import UIKit

class UserSettingsVC: UIViewController {
    
    let (userName, _, _) = tempUsers[homeIndex]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
    }
}
