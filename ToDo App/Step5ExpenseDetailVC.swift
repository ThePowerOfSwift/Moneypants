import UIKit

class Step5ExpenseDetailVC: UITableViewController {
    
    
    
    var firstPaymentDueCellExpanded: Bool = false
    var lastPaymentDueCellExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if firstPaymentDueCellExpanded == true {
                    firstPaymentDueCellExpanded = false
//                    tableView.deselectRow(at: indexPath, animated: true)
                } else {
                    firstPaymentDueCellExpanded = true
//                    tableView.deselectRow(at: indexPath, animated: true)
                }
                tableView.beginUpdates()
                tableView.endUpdates()
//                tableView.reloadData()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                if firstPaymentDueCellExpanded == true {
                    return 216
                } else {
                    return 0
                }
            }
        }
        return 44
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
