import UIKit

class WithdrawalVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var withdrawalAmount: UITextField!
    @IBOutlet weak var withdrawalDescription: UITextField!
    @IBOutlet weak var withdrawalTextField: UITextField!
    @IBOutlet weak var chooseCategoryButton: UIButton!
    
    var withdrawalCategory1: String?
    var withdrawalCategory2: String?
    
    var withdrawalDesc: String?
    let withdrawalPicker = UIPickerView()
    
    let (userName, _, _) = tempUsers[homeIndex]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
        
        chooseCategoryButton.layer.cornerRadius = chooseCategoryButton.bounds.height / 6.4
        chooseCategoryButton.layer.masksToBounds = true
        chooseCategoryButton.layer.borderColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0).cgColor
        chooseCategoryButton.layer.borderWidth = 0.5
        
//        withdrawalPicker.delegate = self
//        withdrawalPicker.dataSource = self
//        withdrawalTextField.inputView = withdrawalPicker
    }
    
    // -----------------
    // Setup Picker View
    // -----------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return expenseEnvelopes.count
        } else {
            if pickerView.selectedRow(inComponent: 0) == 0 {
                return clothingEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 1 {
                return personalCareEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 2 {
                return sportsDanceEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 3 {
                return musicArtEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 4 {
                return schoolEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 5 {
                return electronicsEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 6 {
                return summerCampsEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 7 {
                return transportationEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 8 {
                return otherEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 9 {
                return funMoneyEnvelope.count
            } else if pickerView.selectedRow(inComponent: 0) == 10 {
                return donationsEnvelope.count
            } else {
                return savingsEnvelope.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return expenseEnvelopes[row]
        } else if pickerView.selectedRow(inComponent: 0) == 0 {
            return clothingEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 1 {
            return personalCareEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 2 {
            return sportsDanceEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 3 {
            return musicArtEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 4 {
            return schoolEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 5 {
            return electronicsEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 6 {
            return summerCampsEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 7 {
            return transportationEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 8 {
            return otherEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 9 {
            return funMoneyEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 10 {
            return donationsEnvelope[row]
        } else {
            return savingsEnvelope[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            withdrawalCategory1 = expenseEnvelopes[row]
            pickerView.reloadComponent(0)
            pickerView.reloadComponent(1)
        } else if pickerView.selectedRow(inComponent: 0) == 0 {
            withdrawalCategory2 = clothingEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 1 {
            withdrawalCategory2 = personalCareEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 2 {
            withdrawalCategory2 = sportsDanceEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 3 {
            withdrawalCategory2 = musicArtEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 4 {
            withdrawalCategory2 = schoolEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 5 {
            withdrawalCategory2 = electronicsEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 6 {
            withdrawalCategory2 = summerCampsEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 7 {
            withdrawalCategory2 = transportationEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 8 {
            withdrawalCategory2 = otherEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 9 {
            withdrawalCategory2 = funMoneyEnvelope[row]
        } else if pickerView.selectedRow(inComponent: 0) == 10 {
            withdrawalCategory2 = donationsEnvelope[row]
        } else {
            withdrawalCategory2 = savingsEnvelope[row]
        }
        pickerView.reloadComponent(1)
        withdrawalTextField.text = (withdrawalCategory1 ?? "") + ": " + (withdrawalCategory2 ?? "")
    }
    
    
    // -------
    // Buttons
    // -------
    
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
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: {_ in
            CATransaction.setCompletionBlock({
                self.performSegue(withIdentifier: "UnwindToUserVCSegue", sender: nil)
            })
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // -----------------
    // Navigation Segues
    // -----------------
    
    @IBAction func chooseCategoryButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowBudgetSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowBudgetSegue" {
            let nextController = segue.destination as! MoneyVC
            nextController.navTop = 0
        }
    }
}
