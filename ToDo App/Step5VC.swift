import UIKit
import Firebase

class Step5VC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topQuestionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomQuestionLabel: UILabel!
    @IBOutlet weak var incomeOne: UITextField!
    @IBOutlet weak var incomeTwo: UITextField!
    @IBOutlet weak var incomeThree: UITextField!
    @IBOutlet weak var incomeFour: UITextField!
    @IBOutlet weak var incomeFive: UITextField!
    @IBOutlet weak var totalIncome: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var firstValue: Int = 0
    var secondValue: Int = 0
    var thirdValue: Int = 0
    var fourthValue: Int = 0
    var fifthValue: Int = 0
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var currentMember: Int = 0           // used for cycling through users when 'next' button is tapped
    var currentUserName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        
        incomeOne.delegate = self
        incomeTwo.delegate = self
        incomeThree.delegate = self
        incomeFour.delegate = self
        incomeFive.delegate = self
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        User.finalUsersArray.sort(by: {$0.birthday > $1.birthday})       // sort users by birthday with youngest first
        currentUserName = User.finalUsersArray[currentMember].firstName
        
        topBottomConstraint.constant = -(bottomView.bounds.height)
        
        topQuestionLabel.text = "Does \(currentUserName!) have any income \(User.determineGender(currentMember: currentMember).he_she.lowercased()) earns OUTSIDE the home?"
        yesLabel.text = "Yes, \(currentUserName!) has other income."
        noLabel.text = "No, \(currentUserName!) does not have other income."
        bottomQuestionLabel.text = "What are \(User.determineGender(currentMember: currentMember).his_her.lowercased()) other sources of income?"
        
    }

    @IBAction func yesButtonTapped(_ sender: UIButton) {
        yesButton.isSelected = true
        noButton.isSelected = false
        if individualMainTotalIncome > 0 {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
        topBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        noButton.isSelected = true
        yesButton.isSelected = false
        nextButton.isEnabled = true
        topBottomConstraint.constant = -(bottomView.bounds.height)
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    // ------------------------
    // text field editingDidEnd
    // ------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nextButton.isEnabled = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        totalIncome.text = "\(calculateTotal())"
        yearlyIncomeOutside = calculateTotal()
        if yearlyIncomeOutside > 0 {
            nextButton.isEnabled = true
        }
    }
    
    
    // -------------------------------------------
    // func to calculate total of all input fields
    // -------------------------------------------
    
    func calculateTotal() -> Int {
        let firstValue = Int(incomeOne.text!) ?? 0
        let secondValue = Int(incomeTwo.text!) ?? 0
        let thirdValue = Int(incomeThree.text!) ?? 0
        let fourthValue = Int(incomeFour.text!) ?? 0
        let fifthValue = Int(incomeFive.text!) ?? 0
        return firstValue + secondValue + thirdValue + fourthValue + fifthValue
        
    }
    
    func invalidNumberAlert(whichNumber: UITextField) {
        let alert = UIAlertController(title: "Invalid Entry", message: "Please enter a valid number", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            whichNumber.text = ""
            whichNumber.becomeFirstResponder()
        }))
        present(alert, animated: true, completion: nil)
    }
    
//    func scrollPageIfNeeded() {
//        let height1 = self.secondView.bounds.height
//        let height2 = self.paydayDateTopConstraint.constant + self.thirdView.bounds.height
//        let height3 = self.inspectionsParentTopConstraint.constant + self.fourthView.bounds.height
//        let heightTotal = height1 + height2 + height3
//        
//        if heightTotal > self.scrollView.bounds.height {
//            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
//            self.scrollView.setContentOffset(bottomOffset, animated: true)
//        }
//    }
}

