import UIKit
import Firebase

class Step1VC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    
    // ---------------
    // MARK: Variables
    // ---------------
    
    var user: FIRUser!
    var users = [Item]()
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!
    @IBOutlet weak var incomeTextField: UITextField!
    let amount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incomeTextField?.delegate = self
        
        questionButton.layer.cornerRadius = questionButton.bounds.height / 6.4
        questionButton.layer.masksToBounds = true

        // --------
        // Firebase
        // --------
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
//        startObservingDatabase()

        // -----------------
        // Customize Nav Bar
        // -----------------
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 242/255, green: 101/255, blue: 34/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Arista2.0", size: 26)!
        ]

    }
    

    // -----------
    // NEXT button
    // -----------
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        if incomeTextField.text != "" {
            yearlyIncomeMPS = Int(incomeTextField.text!.components(separatedBy: [",", " "]).joined())       // remove commas
            ref.child("users").child(user.uid).child("income").setValue(yearlyIncomeMPS)
        } else {
            print("yearly income error")
        }
    }
    
    @IBAction func didTapSkipSetup(_ sender: UIButton) {
        yearlyIncomeMPS = 150000
    }
    
    
    
    // -----------------
    // SIGN OUT function
    // -----------------
    
    @IBAction func didTapSignOut(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
            performSegue(withIdentifier: "SignOut", sender: nil)
        } catch let error {
            assertionFailure("Error signing out: \(error)")
        }
    }
    
    
    
    
    
    
    
    
    
    
    
//    func startObservingDatabase () {
//        databaseHandle = ref.child("users/\(self.user.uid)/items").observe(.value, with: { (snapshot) in
//            var newItems = [Item]()
//            
//            for itemSnapShot in snapshot.children {
//                let item = Item(snapshot: itemSnapShot as! FIRDataSnapshot)
//                newItems.append(item)
//            }
//            
//            self.users = newItems
//            
//        })
//    }
//    
//    deinit {
//        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
//    }
    
    
    
    
    
    
    
    
    
    
    

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
}

