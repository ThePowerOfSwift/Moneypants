import UIKit

class FeeVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var feeTextField: UITextField!
    @IBOutlet weak var feeButton: UIButton!
    @IBOutlet weak var explainerLabel: UILabel!
    
    let feePicker = UIPickerView()
    let fees = ["fighting", "lying", "stealing", "disobedience", "bad language"]
    
    var currentUserName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        explainerLabel.text = "The maximum daily limit is $\(String(format: "%.2f", Double(FamilyData.feeValueMultiplier * 3) / 100)) (3 strikes)."
        feeButton.setTitle("add $\(String(format: "%.2f", Double(FamilyData.feeValueMultiplier) / 100)) fee", for: .normal)
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName

        navigationItem.title = currentUserName
        
        feePicker.delegate = self
        feePicker.dataSource = self
        feePicker.backgroundColor = UIColor.white
        feeTextField.inputView = feePicker
    }
    
    // -----------------
    // Setup Picker View
    // -----------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fees[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fees.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        feeTextField.text = fees[row]
    }
    
    // --------------
    // Add Fee Button
    // --------------
    
    @IBAction func addFeeButtonTapped(_ sender: UIButton) {
        // dismiss keyboard
        view.endEditing(true)
        
        // setup two alert messages (one for 'fighting', and one for everything else)
        let alertMessageFighting = "You have chosen to charge \(currentUserName!) a $\(String(format: "%.2f", Double(FamilyData.feeValueMultiplier) / 100)) fee for '\(feeTextField.text!)'.\n\nLet \(currentUserName!) know that if \(MPUser.gender(user: MPUser.currentUser).he_she.lowercased()) goes the remainder of the day without \(feeTextField.text!), the fee will be refunded. Tap okay to confirm."
        let alertMessageDefault = "You have chosen to charge \(currentUserName!) a $\(String(format: "%.2f", Double(FamilyData.feeValueMultiplier) / 100)) fee for '\(feeTextField.text!)'. Tap okay to confirm."
        
        // throw error message if fee field is blank or has something other than the five options (if user pasted text from somewhere else)
        if feeTextField.text! == "" || !fees.contains(feeTextField.text!) {
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
                let fee = Points(user: self.currentUserName, itemName: self.feeTextField.text!, itemCategory: "fees", codeCEXSN: "F", valuePerTap: -(FamilyData.feeValueMultiplier), itemDate: Date().timeIntervalSince1970)
                Points.pointsArray.append(fee)
                // subtract amount from user's income
                for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                    if incomeItem.user == self.currentUserName {
                        Income.currentIncomeArray[incomeIndex].currentPoints -= FamilyData.feeValueMultiplier
                    }
                }
                self.view.endEditing(true)
                _ = self.navigationController?.popViewController(animated: true)
            })
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}


