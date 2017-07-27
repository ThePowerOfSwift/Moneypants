import UIKit

class BudgetVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // -----------
    // Home Button
    // -----------
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
