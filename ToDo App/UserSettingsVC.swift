import UIKit

class UserSettingsVC: UIViewController {
    
    
    
    let (userName, _, _) = tempUsers[homeIndex]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
    }
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
