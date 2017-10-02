import UIKit
import Firebase

class Step1VC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var incomeTextField: UITextField!
    
    let incomeMinimum = 30000
    let incomeMaximum = 1000000
    
    var users = [Item]()
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeTextField?.delegate = self
        
        customizeButton(buttonName: questionButton)
        customizeButton(buttonName: nextButton)
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        // -----------------
        // Customize Nav Bar
        // -----------------
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 242/255, green: 101/255, blue: 34/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Arista2.0", size: 26)!
        ]
        
        loadExistingIncome()
    }
    
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        if incomeTextField.text != "" {     // check if field is empty
            yearlyIncomeMPS = Int(incomeTextField.text!.components(separatedBy: [",", " "]).joined())       // remove commas
            if yearlyIncomeMPS < incomeMinimum || yearlyIncomeMPS > incomeMaximum {     // check if income is within range
                createIncomeAlert()
            } else {        // good to go!
                ref.child("income").setValue(yearlyIncomeMPS)
                performSegue(withIdentifier: "GoToStep2", sender: self)
            }
        } else {
            createIncomeAlert()
        }
        ref.child("income").removeAllObservers()
    }
    
    
    // ---------
    // Functions
    // ---------
    
    
    func createIncomeAlert() {
        // format the income values
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let incomeMin = formatter.string(from: NSNumber(value: incomeMinimum))
        let incomeMax = formatter.string(from: NSNumber(value: incomeMaximum))
        
        let alert = UIAlertController(title: "Income Error", message: "Please enter a value between $\(incomeMin!) and $\(incomeMax!). If your income is outside this range, please contact support for custom setup instructions.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            self.incomeTextField.becomeFirstResponder()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    // allows for dismissal of keyboard when user taps any white space
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // validate and format input, adding commas
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((string == "0" || string == "") && (textField.text! as NSString).range(of: ".").location < range.location) {
            return true
        }
        
        // First check whether the replacement string's numeric...
        let cs = NSCharacterSet(charactersIn: "0123456789").inverted
        let filtered = string.components(separatedBy: cs)
        let component = filtered.joined(separator: "")
        let isNumeric = string == component
        
        // Then if the replacement string's numeric, or if it's
        // a backspace, or if it's a decimal point and the text
        // field doesn't already contain a decimal point,
        // reformat the new complete number using
        if isNumeric {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 8
            // Combine the new text with the old; then remove any
            // commas from the textField before formatting
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let numberWithOutCommas = newString.replacingOccurrences(of: ",", with: "")
            let number = formatter.number(from: numberWithOutCommas)
            if number != nil {
                let formattedString = formatter.string(from: number!)
                textField.text = formattedString
            } else {
                textField.text = nil
            }
        }
        return false
        
    }
    
    
    func customizeButton(buttonName: UIButton) {
        buttonName.layer.cornerRadius = buttonName.bounds.height / 6.4
        buttonName.layer.masksToBounds = true
    }
    
    // Get income value from Firebase
    func loadExistingIncome() {
        ref.child("income").observe(.value, with: { (snapshot) in
            if let snapVal = snapshot.value as? NSNumber {
                
                // Format income with thousands separators
                let formatter = NumberFormatter()
                formatter.groupingSeparator = ","
                formatter.numberStyle = .decimal
                let formattedNumber = formatter.string(from: snapVal)
                
                // put existing income into text field
                self.incomeTextField.text = "\(formattedNumber!)"
            }
        })
    }

}

