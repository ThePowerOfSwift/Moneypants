import UIKit
import Firebase

class SetupCompleteVC: UIViewController {
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        // need to check that all user dates for due dates are still in the future (after the next payday)
        let testArray = Budget.budgetsArray.filter({ $0.hasDueDate == true && $0.firstPayment < FamilyData.calculatePayday().next.timeIntervalSince1970 })
        
        if testArray.isEmpty {
            print("no budget due date conflicts found. continuing with setup")
            setupCompleteAlert()
        } else {
            print("error. one or more items have due dates in the past and must be corrected before moving forward")
            budgetConflictAlert(testArray: testArray)
        }
    }
    
    func setupCompleteAlert() {
        let formatterForLabel = DateFormatter()
        formatterForLabel.dateStyle = .long
        let alert = UIAlertController(title: "Congratulations!", message: "You are all set and ready to go.\nYour first payday is scheduled for \(formatterForLabel.string(from: FamilyData.calculatePayday().next)).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (stuff) in
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "Done", sender: self)
            // update setup progress
            if FamilyData.setupProgress <= 11 {
                FamilyData.setupProgress = 11
                self.ref.updateChildValues(["setupProgress" : 11])
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func budgetConflictAlert(testArray: [Budget]) {
        var budgetErrorArray: [String] = []
        for item in testArray {
            let arrayItem = ("\(item.ownerName): \(item.category) >>> \(item.expenseName)")
            budgetErrorArray.append(arrayItem)
        }
        
        let alert = UIAlertController(title: "Budget Conflict", message: "\(testArray.count) item(s) have due dates in the past and must be corrected before moving forward. Please review the following budget items for the following user(s):\n\n\(budgetErrorArray)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (stuff) in
            alert.dismiss(animated: true, completion: nil)
            
            MPUser.currentUser = (MPUser.usersArray.count - 1)          // start with youngest user first
            
            let storyboard = UIStoryboard(name: "Setup", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Step8OutsideIncomeVC") as! Step8OutsideIncomeVC
            self.navigationController?.pushViewController(vc, animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
}
