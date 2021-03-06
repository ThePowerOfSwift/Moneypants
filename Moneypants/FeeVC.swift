import UIKit
import Firebase

class FeeVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var feeTextField: UITextField!
    @IBOutlet weak var feeButton: UIButton!
    @IBOutlet weak var explainerLabel: UILabel!
    
    let feePicker = UIPickerView()
    
    var currentUserName: String!
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    var selectedDate: Date!
    var selectedDateNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        explainerLabel.text = "The maximum daily limit is $\(String(format: "%.2f", Double(FamilyData.feeValueMultiplier * 3) / 100)) (3 strikes)."
        feeButton.setTitle("add $\(String(format: "%.2f", Double(FamilyData.feeValueMultiplier) / 100)) fee", for: .normal)
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName

        navigationItem.title = currentUserName
        
        feePicker.delegate = self
        feePicker.dataSource = self
        feePicker.backgroundColor = UIColor.white
        feeTextField.inputView = feePicker
        feeTextField.delegate = self
    }
    
    // -----------------
    // Setup Picker View
    // -----------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return FamilyData.fees[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FamilyData.fees.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        feeTextField.text = FamilyData.fees[row]
    }
    
    // ---------
    // Functions
    // ---------
    
    @IBAction func addFeeButtonTapped(_ sender: UIButton) {
        // dismiss keyboard
        view.endEditing(true)
        
        // setup two alert messages (one for 'fighting', and one for everything else)
        let alertMessageFighting = "\(currentUserName!) will get charged a $\(String(format: "%.2f", Double(FamilyData.feeValueMultiplier) / 100)) fee for '\(feeTextField.text!)'.\n\nLet \(currentUserName!) know that if \(MPUser.gender(user: MPUser.currentUser).he_she.lowercased()) goes the remainder of the day without \(feeTextField.text!), this fee will be refunded. Tap okay to confirm."
        let alertMessageDefault = "\(currentUserName!) will get charged a $\(String(format: "%.2f", Double(FamilyData.feeValueMultiplier) / 100)) fee for '\(feeTextField.text!)'. Tap okay to confirm."
        
        // throw error message if fee field is blank or has something other than the five options (if user pasted text from somewhere else)
        if feeTextField.text! == "" || !FamilyData.fees.contains(feeTextField.text!) {
            selectionErrorAlert()
        } else {
            if feeTextField.text == "fighting" {
                selectionAlert(alertMessage: alertMessageFighting)
            } else {
                selectionAlert(alertMessage: alertMessageDefault)
            }
        }
    }
    
    func selectionErrorAlert() {
        let errorAlert = UIAlertController(title: "Selection Error", message: "Please choose from one of the five possible options.", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                errorAlert.dismiss(animated: true, completion: nil)
            }))
            present(errorAlert, animated: true, completion: nil)
    }
    
    func selectionAlert(alertMessage: String) {
        let alert = UIAlertController(title: "\(feeTextField.text!.capitalized) Fee", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: {_ in
            CATransaction.setCompletionBlock({
                // refresh selectedDate variable with current time
                self.selectedDate = Calendar.current.date(byAdding: .day, value: self.selectedDateNumber, to: Date())
                let fee = Points(user: self.currentUserName,
                                 itemName: self.feeTextField.text!,
                                 itemCategory: "fees",
                                 code: "F",
                                 valuePerTap: -(FamilyData.feeValueMultiplier),
                                 itemDate: self.selectedDate.timeIntervalSince1970,
                                 paid: false)
                
                Points.pointsArray.append(fee)
                
                // add item to Firebase
                // need to organize them in some way? perhaps by date? category?
                self.ref.child("points").childByAutoId().setValue(["user" : self.currentUserName,
                                                                   "itemName" : self.feeTextField.text!,
                                                                   "itemCategory" : "fees",
                                                                   "code" : "F",
                                                                   "valuePerTap" : -(FamilyData.feeValueMultiplier),
                                                                   "itemDate" : self.selectedDate.timeIntervalSince1970])
                
                // subtract amount from user's income
                for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                    if incomeItem.user == self.currentUserName {
                        Income.currentIncomeArray[incomeIndex].currentPoints -= FamilyData.feeValueMultiplier
                    }
                }
                
                // update Firebase
                self.ref.child("mpIncome").updateChildValues([self.currentUserName! : Income.currentIncomeArray[MPUser.currentUser].currentPoints])
                
                self.view.endEditing(true)
                _ = self.navigationController?.popViewController(animated: true)
            })
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if feeTextField.text == "" {
            feeTextField.text = "fighting"
        }
    }
}


