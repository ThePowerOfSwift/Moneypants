import UIKit

class ReportsBudgetVC: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = "\(userName)'s expenses"
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
