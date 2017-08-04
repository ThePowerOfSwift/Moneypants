import UIKit

class WithdrawalVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func readMoreButtonTapped(_ sender: UIButton) {
        // Left justify the alert bubble
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        // Lengthy alert bubble
        let messageText = NSMutableAttributedString(
            string: "Withdrawals should be used for the following reasons:\n\n1. if child wishes to purchase something but their card won't allow it (e.g. Internet purchases)\n\n2. if child forgot their debit card at a store but has sufficient funds in their bank account to buy an item\n\n3. if child broke something and needs to pay for it\n\n",
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
        
        let alert = UIAlertController(title: "add withdrawal", message: "Confirmation message goes here. Tap 'okay' to confirm.", preferredStyle: .alert)
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
