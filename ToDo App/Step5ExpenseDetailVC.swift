import UIKit

class Step5ExpenseDetailVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseAmountTextField: UITextField!
    @IBOutlet weak var hasDueDateSwitch: UISwitch!
    @IBOutlet weak var firstPaymentDueDateLabel: UILabel!
    @IBOutlet weak var firstPaymentDatePickerView: UIDatePicker!
    @IBOutlet weak var repeatsLabel: UILabel!
    @IBOutlet weak var repeatsPickerView: UIPickerView!
    @IBOutlet weak var finalPaymentDueDateLabel: UILabel!
    @IBOutlet weak var finalPaymentDatePickerView: UIDatePicker!
    @IBOutlet weak var yearlyTotalLabel: UILabel!
    
    var firstPaymentDatePickerHeight: CGFloat = 0
    var repeatPickerHeight: CGFloat = 0
    var finalPaymentDueCellHeight: CGFloat = 0
    var finalPaymentDatePickerHeight: CGFloat = 0
    
    var firstPaymentDueDate: String?
    var finalPaymentDueDate: String?
    
    var currentUser: Int!               // passed from Step5VC
    var expense: Expense?               // passed from Step5VC
    
    var currentUserName: String!
    
    let repeatOptions = ["never", "weekly", "monthly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expenseNameTextField.delegate = self
        expenseAmountTextField.delegate = self
        
        hasDueDateSwitch.isOn = false
        repeatsLabel.text = "never"
        repeatsPickerView.delegate = self
        hasDueDateSwitch.onTintColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)        // green
        saveButton.isEnabled = false
        
        currentUserName = User.usersArray[currentUser].firstName
        navigationItem.title = currentUserName!
        
        // ----------------------
        // edit exisiting expense
        // ----------------------
        
        if let existingExpense = expense {
            expenseNameTextField.text = existingExpense.expenseName
            expenseAmountTextField.text = "\(existingExpense.amount)"
            hasDueDateSwitch.isOn = existingExpense.hasDueDate
            
            // update First Payment Due Date Picker with correct date (if there is one, otherwise make the date today's date)
            firstPaymentDueDate = "\(existingExpense.firstPayment)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let dateFromString = dateFormatter.date(from: firstPaymentDueDate!)
            firstPaymentDatePickerView.date = dateFromString ?? Date()
            
            // show first payment as text in first payment text field (if there is one, otherwise make the date today)
            dateFormatter.dateStyle = .medium
            firstPaymentDueDateLabel.text = dateFormatter.string(from: dateFromString ?? Date())
            
            repeatsLabel.text = existingExpense.repeats
            if existingExpense.repeats != "never" {
                // show final payment due row if the repeat button is set to anything other than "never"
                finalPaymentDueCellHeight = 44
            }
            
            // update repeat picker with selected frequency (if there is one, otherwise select 'never' at index 0)
            for (index, repeatInterval) in repeatOptions.enumerated() {
                if existingExpense.repeats.contains(repeatInterval) {
                    repeatsPickerView.selectRow(index, inComponent: 0, animated: true)
                } else {
                    repeatsPickerView.selectRow(0, inComponent: 0, animated: true)
                }
            }
            
            // update Final Payment Due Date Picker with correct date (if there is one, otherwise make the date today's date)
            finalPaymentDueDate = "\(existingExpense.finalPayment)"
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "yyyyMMdd"
            let dateFromString2 = dateFormatter2.date(from: finalPaymentDueDate!)
            finalPaymentDatePickerView.date = dateFromString2 ?? Date()
            
            // show final payment as text in final payment text field (if there is one, otherwise make the date today)
            dateFormatter2.dateStyle = .medium
            finalPaymentDueDateLabel.text = dateFormatter2.string(from: dateFromString2 ?? Date())
            
            // calculate total at bottom
            if existingExpense.repeats == "monthly" {
                let numberOfMonths = dateFromString2?.months(from: dateFromString!)
                yearlyTotalLabel.text = "\(existingExpense.expenseName) = $\(existingExpense.amount * numberOfMonths!)"
//                print(numberOfMonths!)
            } else if existingExpense.repeats == "weekly" {
                let numberOfWeeks = dateFromString2?.weeks(from: dateFromString!)
                yearlyTotalLabel.text = "\(existingExpense.expenseName) = $\(existingExpense.amount * numberOfWeeks!)"
//                print(numberOfWeeks!)
            }
        }
    }
    
    // -------------
    // Repeat Picker
    // -------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return repeatOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        repeatsLabel.text = repeatOptions[row]
        // show final due date if user chooses 'weekly' or 'monthly' repeat
        if row != 0 {
            finalPaymentDueCellHeight = 44
        } else {
            finalPaymentDueCellHeight = 0
        }
    }
    
    // ----------
    // Table View
    // ----------
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if firstPaymentDatePickerHeight == 216 {
                    firstPaymentDatePickerHeight = 0
                    firstPaymentDueDateLabel.textColor = UIColor.lightGray
                } else {
                    firstPaymentDatePickerHeight = 216
                    firstPaymentDueDateLabel.textColor = UIColor.red
                    // collapse other pickers and turn their text colors back to black
                    repeatPickerHeight = 0
                    repeatsLabel.textColor = UIColor.black
                    finalPaymentDatePickerHeight = 0
                    finalPaymentDueDateLabel.textColor = UIColor.lightGray
                }
            }
            if indexPath.row == 2 {
                if repeatPickerHeight == 120 {
                    repeatPickerHeight = 0
                    repeatsLabel.textColor = UIColor.lightGray
                } else {
                    repeatPickerHeight = 120
                    repeatsLabel.textColor = UIColor.red
                    // collapse other pickers and turn their text colors back to black
                    firstPaymentDatePickerHeight = 0
                    firstPaymentDueDateLabel.textColor = UIColor.lightGray
                    finalPaymentDatePickerHeight = 0
                    finalPaymentDueDateLabel.textColor = UIColor.lightGray
                }
            }
            if indexPath.row == 4 {
                if finalPaymentDatePickerHeight == 216 {
                    finalPaymentDatePickerHeight = 0
                    finalPaymentDueDateLabel.textColor = UIColor.lightGray
                } else {
                    finalPaymentDatePickerHeight = 216
                    finalPaymentDueDateLabel.textColor = UIColor.red
                    // collapse other pickers and turn their text colors back to black
                    firstPaymentDatePickerHeight = 0
                    firstPaymentDueDateLabel.textColor = UIColor.lightGray
                    repeatPickerHeight = 0
                    repeatsLabel.textColor = UIColor.lightGray
                }
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            // hide all cells in section 1 if repeat switch is off
            if hasDueDateSwitch.isOn == false {
                return 0
            } else {
                switch indexPath.row {
                case 1:
                    return firstPaymentDatePickerHeight
                case 3:
                    return repeatPickerHeight
                case 4:
                    return finalPaymentDueCellHeight
                case 5:
                    return finalPaymentDatePickerHeight
                default:
                    return 44
                }
            }
        }
        // hide all cells in section 2 if repeat switch if off
        if indexPath.section == 2 {
            if hasDueDateSwitch.isOn == false {
                return 0
            } else if repeatsLabel.text != "never" {
                return 66
            } else {
                return 0
            }
        }
        return 44
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        
        // TODO: have due date text field update when user chooses a different date...
        
        // check for if due date is selected, there's a valid due date that's after today
        // check if repeat is selected, there's a final due date that's after today's date AND after the first due date
        
        
        if expenseNameTextField.text == "" {
            blankNameAlert()
        } else if Int(expenseAmountTextField.text!) == nil {
            blankAmountAlert()
        } else if checkForDuplicateNames() == true {
            duplicateNameAlert()
        } else {
            for (index, item) in Expense.expensesArray.enumerated() {
                if item.ownerName == currentUserName && item.expenseName == expense?.expenseName {
                    Expense.expensesArray[index].expenseName = expenseNameTextField.text!
                    Expense.expensesArray[index].amount = Int(expenseAmountTextField.text!)!
                    if hasDueDateSwitch.isOn {
                        Expense.expensesArray[index].hasDueDate = true
                    } else {
                        Expense.expensesArray[index].hasDueDate = false
                    }
                    Expense.expensesArray[index].firstPayment = firstPaymentDueDate!
                    Expense.expensesArray[index].repeats = repeatsLabel.text!
                    Expense.expensesArray[index].finalPayment = finalPaymentDueDate!
                }
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func checkForDuplicateNames() -> Bool {
        var duplicatesAmount: Int = 0
        for expense in Expense.expensesArray.filter({ return $0.ownerName == currentUserName }) {
            print(expense.expenseName)
            if expense.expenseName.lowercased() == expenseNameTextField.text?.lowercased() {
                duplicatesAmount += 1
                print("POTENTIAL DUPLICATE #\(duplicatesAmount): ",expense.expenseName)
            }
        }
        // if there are more than one expense in the array with the same name, return true
        if duplicatesAmount > 1 {
            return true
        } else {
            return false
        }
    }
    
    func blankNameAlert() {
        let alert = UIAlertController(title: "Expense Name", message: "Please give this expense a name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func blankAmountAlert() {
        let alert = UIAlertController(title: "Expense Amount", message: "Please enter an amount for this expense.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func duplicateNameAlert() {
        let alert = UIAlertController(title: "Edit Expense", message: "You have entered in an expense with the same name as another expense. Please choose a unique name for this expense.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
                self.expenseNameTextField.becomeFirstResponder()          // for some reason, this causes a spellcheck error with Xcode
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func hasDueDateSwitchTapped(_ sender: UISwitch) {
        view.resignFirstResponder()
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hasDueDateSwitch.isEnabled = false
        saveButton.isEnabled = false
    }
    
    // only allow entry of numbers, nothing else
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == expenseAmountTextField {
            let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = true
        hasDueDateSwitch.isEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension Date {
    // Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    // Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    // Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    // Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    // Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    // Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    // Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    // Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}



