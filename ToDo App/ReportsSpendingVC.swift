import UIKit

class ReportsSpendingVC: UIViewController {
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]
    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = userName
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
