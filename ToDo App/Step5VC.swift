import UIKit

class Step5VC: UIViewController {
    
    // ---------
    // Variables
    // ---------

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var incomeOne: UITextField!
    @IBOutlet weak var incomeTwo: UITextField!
    @IBOutlet weak var incomeThree: UITextField!
    @IBOutlet weak var incomeFour: UITextField!
    @IBOutlet weak var incomeFive: UITextField!
    @IBOutlet weak var totalIncome: UILabel!
    
    var firstValue: Int = 0
    var secondValue: Int = 0
    var thirdValue: Int = 0
    var fourthValue: Int = 0
    var fifthValue: Int = 0
    var totalValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topBottomConstraint.constant = -(bottomView.bounds.height)
    }

    @IBAction func yesButtonTapped(_ sender: UIButton) {
        yesButton.isSelected = true
        noButton.isSelected = false
        topBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        noButton.isSelected = true
        yesButton.isSelected = false
        topBottomConstraint.constant = -(bottomView.bounds.height)
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
    }
    
    // ------------------------
    // text field editingDidEnd
    // ------------------------

    // NOTE: all five text fields link up to this one function
    @IBAction func incomeOneEditingDidEnd(_ sender: UITextField) {
        totalIncome.text = "\(calculateTotal())"
        yearlyIncomeOutside = calculateTotal()
    }
    
    
    // -------------------------------------------
    // func to calculate total of all input fields
    // -------------------------------------------
    
    func calculateTotal() -> Int {
        if incomeOne.text != "" {
            firstValue = Int(incomeOne.text!)!
        } else {
            firstValue = 0
        }
        if incomeTwo.text != "" {
            secondValue = Int(incomeTwo.text!)!
        } else {
            secondValue = 0
        }
        if incomeThree.text != "" {
            thirdValue = Int(incomeThree.text!)!
        } else {
            thirdValue = 0
        }
        if incomeFour.text != "" {
            fourthValue = Int(incomeFour.text!)!
        } else {
            fourthValue = 0
        }
        if incomeFive.text != "" {
            fifthValue = Int(incomeFive.text!)!
        } else {
            fifthValue = 0
        }
        return firstValue + secondValue + thirdValue + fourthValue + fifthValue
        
    }

    
}
