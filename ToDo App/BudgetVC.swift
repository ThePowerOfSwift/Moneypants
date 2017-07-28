import UIKit

class BudgetVC: UIViewController {
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
    }
    
    // -----------
    // Home Button
    // -----------
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
