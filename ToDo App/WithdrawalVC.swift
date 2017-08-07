import UIKit

class WithdrawalVC: UIViewController {
    
    let (userName, _, _) = tempUsers[homeIndex]
    @IBOutlet weak var withdrawalAmount: UITextField!
    @IBOutlet weak var withdrawalDescription: UITextField!
    @IBOutlet weak var budgetSelectButton: UIButton!
    var withdrawalDesc: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
        budgetSelectButton.layer.cornerRadius = 5
        budgetSelectButton.layer.masksToBounds = true
        budgetSelectButton.layer.borderColor = UIColor.lightGray.cgColor
        budgetSelectButton.layer.borderWidth = 0.5
    }
    
    
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
        let alert = UIAlertController(title: "Add Withdrawal", message: "You have chosen to add a $\(withdrawalAmount.text!) withdrawal for \"\(withdrawalDesc!)\" to \(userName)'s account. Tap okay to confirm.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "UnwindToUserVCSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
