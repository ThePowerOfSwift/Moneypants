import UIKit
import Firebase
//import AKMaskField

class Step1ViewController: UIViewController, UITextFieldDelegate {
    
    // ---------------
    // MARK: Variables
    // ---------------
    
    var user: FIRUser!
    var users = [Item]()
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!
    @IBOutlet weak var incomeField: UITextField!
    @IBOutlet weak var incomeMessageLabel: UILabel!
//    @IBOutlet weak var incomeField: AKMaskField!        // NEW
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.incomeField.delegate = self
        
        // -----------      // NEW
        // AKMaskField
        // -----------

//        incomeField = AKMaskField()
//        incomeField.maskExpression = "{dddd}-{DDDD}-{WaWa}-{aaaa}"
//        incomeField.maskTemplate = "ABCD-EFGH-IJKL-MNOP"
        
        // --------
        // Firebase
        // --------
        
        user = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        startObservingDatabase()

        // -----------------
        // Customize Nav Bar
        // -----------------
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 242/255, green: 101/255, blue: 34/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        // UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Arista2.0", size: 26)!
        ]

    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        if incomeField.text != "" {
            yearlyIncomeMPS = Int(incomeField.text!)!
        } else {
            yearlyIncomeMPS = 150000
        }
        print(incomeField.text ?? "no income entered")
    }
    
    
    @IBAction func incomeFieldEditingChanged(_ sender: UITextField) {
        let firstNumber = Int(incomeField.text!)
        if firstNumber != nil {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
            incomeMessageLabel.text = "You've entered $\(numberFormatter.string(from: NSNumber(value: firstNumber!))!) as your yearly income."
        }
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
    
    func startObservingDatabase () {
        databaseHandle = ref.child("users/\(self.user.uid)/items").observe(.value, with: { (snapshot) in
            var newItems = [Item]()
            
            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! FIRDataSnapshot)
                newItems.append(item)
            }
            
            self.users = newItems
            
        })
    }
    
    deinit {
        ref.child("users/\(self.user.uid)/items").removeObserver(withHandle: databaseHandle)
    }


}
