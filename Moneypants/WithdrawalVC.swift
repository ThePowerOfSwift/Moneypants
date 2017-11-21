import UIKit

class WithdrawalVC: UIViewController {
    
    @IBOutlet weak var withdrawalAmount: UITextField!
    @IBOutlet weak var withdrawalDescription: UITextField!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    
    var withdrawalCategory1: String?
    var withdrawalCategory2: String?
    
    var withdrawalDesc: String?
    
    var currentUserName: String!

    
    let (userName, _, _) = tempUsers[homeIndex]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        navigationItem.title = currentUserName
        
        chooseCategoryButton.layer.cornerRadius = chooseCategoryButton.bounds.height / 6.4
        chooseCategoryButton.layer.masksToBounds = true
        chooseCategoryButton.layer.borderColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0).cgColor
        chooseCategoryButton.layer.borderWidth = 0.5
    }
    
    // -------
    // Buttons
    // -------
    
    @IBAction func readMoreButtonTapped(_ sender: UIButton) {
        // Left justify the alert bubble
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        // Lengthy alert bubble
        let messageText = NSMutableAttributedString(
            string: "Withdrawals should be used for the following reasons:\n\n1. if child wishes to purchase something but their card won't allow it (e.g. Internet purchases)\n\n2. if child forgot their debit card at a store but has sufficient funds in their bank account to buy an item\n\n3. if child broke something and needs to pay for it",
            attributes: [
                NSParagraphStyleAttributeName : paragraphStyle,
                NSFontAttributeName : UIFont.systemFont(ofSize: 13.0),
                NSForegroundColorAttributeName : UIColor.black
            ]
        )
        
        // Not sure what this does,  but it works
        let alert = UIAlertController(title: "Withdrawals", message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        // Button one: "okay"
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addWithdrawalButtonTapped(_ sender: UIButton) {
        withdrawalDesc = withdrawalDescription.text
        let alert = UIAlertController(title: "Add Withdrawal", message: "You have chosen to make a $\(withdrawalAmount.text!) withdrawal from \"\(withdrawalDesc!)\" in \(userName)'s account. Tap okay to confirm.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: {_ in
            CATransaction.setCompletionBlock({
                self.performSegue(withIdentifier: "UnwindToUserVCSegue", sender: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // -----------------
    // Navigation Segues
    // -----------------
    
    @IBAction func chooseCategoryButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowBudgetSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBudgetSegue" {
            let nextVC = segue.destination as! MoneyVC
            nextVC.navTop = 0
            // convert textField input to Double, then to Int
            nextVC.withdrawalAmount = Int(Double(withdrawalAmount.text!)! * 100)
        }
    }
}
