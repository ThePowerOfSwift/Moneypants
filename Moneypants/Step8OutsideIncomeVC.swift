import UIKit
import Firebase

class Step8OutsideIncomeVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var topQuestionLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var yesLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var noLabel: UILabel!
    
    @IBOutlet weak var bottomQuestionLabel: UILabel!
    @IBOutlet weak var mowingLawnsTextField: UITextField!
    @IBOutlet weak var babysittingTextField: UITextField!
    @IBOutlet weak var houseCleaningTextField: UITextField!
    @IBOutlet weak var summerJobsTextField: UITextField!
    @IBOutlet weak var allOthersTextField: UITextField!
    @IBOutlet weak var totalIncome: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    var currentUserName: String!
    var income = [OutsideIncome]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        topBottomConstraint.constant = -(bottomView.bounds.height)
        
        mowingLawnsTextField.delegate = self
        babysittingTextField.delegate = self
        houseCleaningTextField.delegate = self
        summerJobsTextField.delegate = self
        allOthersTextField.delegate = self
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        userImage.image = MPUser.usersArray[MPUser.currentUser].photo
        navigationItem.title = MPUser.usersArray[MPUser.currentUser].firstName
        topQuestionLabel.text = "Does \(currentUserName!) have any income \(MPUser.gender(user: MPUser.currentUser).he_she.lowercased()) earns OUTSIDE the home?"
        yesLabel.text = "Yes, \(currentUserName!) has other income."
        noLabel.text = "No, \(currentUserName!) does not have other income."
        bottomQuestionLabel.text = "What are \(MPUser.gender(user: MPUser.currentUser).his_her.lowercased()) other sources of income?"
        
        loadExistingOutsideIncome()
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // update setupProgress
        if FamilyData.setupProgress <= 8 {
            FamilyData.setupProgress = 8
            ref.updateChildValues(["setupProgress" : 8])
        }
        performSegue(withIdentifier: "IncomeSummary", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IncomeSummary" {
            if noButton.isSelected == true {
                // reset all text fields to blank
                mowingLawnsTextField.text = ""
                babysittingTextField.text = ""
                houseCleaningTextField.text = ""
                summerJobsTextField.text = ""
                allOthersTextField.text = ""
                totalIncome.text = "0"
                
                zeroOutLocalArray()
                zeroOutFirebaseOutsideIncome()
            }
            
            let nextVC = segue.destination as! Step9IncomeSummaryVC
            nextVC.yearlyOutsideIncome = calculateTotal()
        }
    }
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        yesButton.isSelected = true
        noButton.isSelected = false
        if calculateTotal() > 0 {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
        topBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.25) { 
            self.view.layoutIfNeeded()
        }
        scrollPageIfNeeded()
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
    
    // ------------------
    // text field methods
    // ------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nextButton.isEnabled = false
    }
    
    // only allow entry of numbers, nothing else
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        totalIncome.text = "\(calculateTotal())"
        if calculateTotal() > 0 {
            nextButton.isEnabled = true
            updateLocalArray()
            updateFirebaseOutsideIncome()
        } else {
            zeroOutLocalArray()
            zeroOutFirebaseOutsideIncome()
        }
    }
    
    func zeroOutLocalArray() {
        for (index, income) in OutsideIncome.incomeArray.enumerated() {
            if income.userName == currentUserName {
                OutsideIncome.incomeArray[index].mowingLawns = 0
                OutsideIncome.incomeArray[index].babysitting = 0
                OutsideIncome.incomeArray[index].houseCleaning = 0
                OutsideIncome.incomeArray[index].summerJobs = 0
                OutsideIncome.incomeArray[index].allOthers = 0
            }
        }
    }
    
    func zeroOutFirebaseOutsideIncome() {
        ref.child("outsideIncome").child(currentUserName).updateChildValues(["mowingLawns" : 0,
                                                                             "babysitting" : 0,
                                                                             "houseCleaning" : 0,
                                                                             "summerJobs" : 0,
                                                                             "allOthers" : 0])
    }
    
    func updateLocalArray() {
        for (index, income) in OutsideIncome.incomeArray.enumerated() {
            if income.userName == currentUserName {
                OutsideIncome.incomeArray[index].mowingLawns = Int(mowingLawnsTextField.text!) ?? 0
                OutsideIncome.incomeArray[index].babysitting = Int(babysittingTextField.text!) ?? 0
                OutsideIncome.incomeArray[index].houseCleaning = Int(houseCleaningTextField.text!) ?? 0
                OutsideIncome.incomeArray[index].summerJobs = Int(summerJobsTextField.text!) ?? 0
                OutsideIncome.incomeArray[index].allOthers = Int(allOthersTextField.text!) ?? 0
            }
        }
    }
    
    func updateFirebaseOutsideIncome() {
        ref.child("outsideIncome").child(currentUserName).updateChildValues(["mowingLawns" : Int(mowingLawnsTextField.text!) ?? 0,
                                                                             "babysitting" : Int(babysittingTextField.text!) ?? 0,
                                                                             "houseCleaning" : Int(houseCleaningTextField.text!) ?? 0,
                                                                             "summerJobs" : Int(summerJobsTextField.text!) ?? 0,
                                                                             "allOthers" : Int(allOthersTextField.text!) ?? 0])
    }
    
    // ---------
    // functions
    // ---------
    
    func loadExistingOutsideIncome() {
        // get array with only current user's data
        income = OutsideIncome.incomeArray.filter({ return $0.userName == currentUserName })
        
        if income.isEmpty {
//            print("empty income array")
            // user hasn't entered in any data yet and all data is empty
            // create and append a new array with default values
            let outsideIncome = OutsideIncome(userName: currentUserName,
                                              allOthers: 0,
                                              babysitting: 0,
                                              houseCleaning: 0,
                                              mowingLawns: 0,
                                              summerJobs: 0)
            OutsideIncome.incomeArray.append(outsideIncome)
//            print(OutsideIncome.incomeArray)
            zeroOutFirebaseOutsideIncome()
            
        } else {
            // user has entered data (either yes or no)
            mowingLawnsTextField.text = "\(income[0].mowingLawns)"
            babysittingTextField.text = "\(income[0].babysitting)"
            houseCleaningTextField.text = "\(income[0].houseCleaning)"
            summerJobsTextField.text = "\(income[0].summerJobs)"
            allOthersTextField.text = "\(income[0].allOthers)"
            totalIncome.text = "\(calculateTotal())"
            
            if calculateTotal() == 0 {
                // use previously selected 'no' and all data is zero
                noButton.isSelected = true
                nextButton.isEnabled = true

            } else {
                // user previously selected 'yes' and at least some data is more than zero
                yesButton.isSelected = true
                nextButton.isEnabled = true
                topBottomConstraint.constant = 0
            }
        }
    }
    
    func calculateTotal() -> Int {
        let firstValue = Int(mowingLawnsTextField.text!) ?? 0
        let secondValue = Int(babysittingTextField.text!) ?? 0
        let thirdValue = Int(houseCleaningTextField.text!) ?? 0
        let fourthValue = Int(summerJobsTextField.text!) ?? 0
        let fifthValue = Int(allOthersTextField.text!) ?? 0
        return firstValue + secondValue + thirdValue + fourthValue + fifthValue
    }
    
    func scrollPageIfNeeded() {
        let height1 = self.topView.bounds.height            // add height of first view...
        let height2 = self.middleView.bounds.height         // ...and height of second view...
        let height3 = self.topBottomConstraint.constant + self.bottomView.bounds.height         // ...and height of third view (which varies depending on whether it's hidden or not b/c constraint can be negative)
        let heightTotal = height1 + height2 + height3
        // if the combined heights of all three views when fully expanded is more than the height of the screen, then scroll down
        if heightTotal > self.scrollView.bounds.height {
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}

