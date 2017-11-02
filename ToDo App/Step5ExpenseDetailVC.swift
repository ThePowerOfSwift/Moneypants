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
    @IBOutlet weak var totalNumberOfPaymentsLabel: UILabel!
    @IBOutlet weak var yearlyTotalLabel: UILabel!
    
    // for when user taps 'savings' from Step5ExpensesVC
    @IBOutlet weak var expenseAmountCell: UITableViewCell!
    @IBOutlet weak var hasDueDateCell: UITableViewCell!
    @IBOutlet weak var expenseAmountDollarSignLabel: UILabel!
    @IBOutlet weak var hasDueDateLabel: UILabel!
    var expenseAmountCellIsEnabled = true
    var hasDueDateCellIsEnabled = true
    var expenseAmountDollarSignLabelColor = UIColor.black
    var hasDueDateLabelColor = UIColor.black
    var expenseAmountTextFieldColor = UIColor.black
    // end for when user taps 'savings' from Step5ExpensesVC
    
    var firstPaymentDatePickerHeight: CGFloat = 0
    var repeatPickerHeight: CGFloat = 0
    var finalPaymentDueCellHeight: CGFloat = 0
    var finalPaymentDatePickerHeight: CGFloat = 0
    var totalNumberOfPaymentsHeight: CGFloat = 0
    var firstPaymentDueDate: String?
    var finalPaymentDueDate: String?
    
    var currentUser: Int!               // passed from Step5VC
    var expense: Expense?               // passed from Step5VC
    var currentUserName: String!
    
    let repeatOptions = ["never", "weekly", "monthly"]
    let formatterForLabel = DateFormatter()
    let formatterForFirebase = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatterForLabel.dateStyle = DateFormatter.Style.medium                        // Shows how date is displayed
        formatterForLabel.timeStyle = DateFormatter.Style.none                          // No time, just date
        formatterForFirebase.dateFormat = "yyyyMMdd"                                    // convert datepicker text into Int for Firebase storage
        
        totalNumberOfPaymentsLabel.text = "1"
        
        // for when user taps 'savings' from Step5ExpensesVC
        expenseAmountCell.isUserInteractionEnabled = expenseAmountCellIsEnabled
        hasDueDateCell.isUserInteractionEnabled = hasDueDateCellIsEnabled
        expenseAmountDollarSignLabel.textColor = expenseAmountDollarSignLabelColor
        expenseAmountTextField.textColor = expenseAmountTextFieldColor
        hasDueDateLabel.textColor = hasDueDateLabelColor
        // end for when user taps 'savings' from Step5ExpensesVC
        
        expenseNameTextField.delegate = self
        expenseAmountTextField.delegate = self
        hasDueDateSwitch.isOn = false
        repeatsLabel.text = "never"
        repeatsPickerView.delegate = self
        hasDueDateSwitch.onTintColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)        // green
        
        firstPaymentDatePickerView.minimumDate = Date()
        
        currentUserName = User.usersArray[currentUser].firstName
        navigationItem.title = currentUserName!
        
        // ----------------------
        // edit exisiting expense
        // ----------------------
        
        loadExistingExpenseData()
    }
    
    // ------------
    // Date Pickers
    // ------------
    
    @IBAction func firstPaymentDueDateChanged(_ sender: UIDatePicker) {
        firstPaymentDueDateLabel.text = formatterForLabel.string(from: sender.date)
        firstPaymentDueDate = formatterForFirebase.string(from: sender.date)
        
        updateTotals()
    }
    
    @IBAction func finalPaymentDueDateChanged(_ sender: UIDatePicker) {
        finalPaymentDueDateLabel.text = formatterForLabel.string(from: sender.date)
        finalPaymentDueDate = formatterForFirebase.string(from: sender.date)
        
        updateTotals()
    }
    
    // -------------
    // Repeat Picker
    // -------------
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return repeatOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return repeatOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        repeatsLabel.text = repeatOptions[row]
        // get firstPayment info and convert it to NSDate...
        let firstPaymentDueDateNSDateFormat = formatterForFirebase.date(from: firstPaymentDueDate!)
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)

        // -----------------
        // for weekly repeat
        // -----------------
        
        if row == 1 {
            finalPaymentDueCellHeight = 44
            totalNumberOfPaymentsHeight = 44
            // add a week to first payment due date...
            let aWeekFromFirstPayment = calendar.date(byAdding: Calendar.Component.day, value: 7, to: firstPaymentDueDateNSDateFormat!)
            // ...then format it for the label with an initial value
            finalPaymentDueDateLabel.text = formatterForLabel.string(from: aWeekFromFirstPayment!)
            finalPaymentDatePickerView.date = aWeekFromFirstPayment!
            finalPaymentDueDate = formatterForFirebase.string(from: aWeekFromFirstPayment!)
            
        // ------------------
        // for monthly repeat
        // ------------------
            
        } else if row == 2 {
            finalPaymentDueCellHeight = 44
            totalNumberOfPaymentsHeight = 44
            // add month to first payment due date...
            let aMonthFromFirstPayment = calendar.date(byAdding: Calendar.Component.month, value: 1, to: firstPaymentDueDateNSDateFormat!)
            // ...then format it for the label
            finalPaymentDueDateLabel.text = formatterForLabel.string(from: aMonthFromFirstPayment!)
            finalPaymentDatePickerView.date = aMonthFromFirstPayment!
            finalPaymentDueDate = formatterForFirebase.string(from: aMonthFromFirstPayment!)
            
        // -------------
        // for no repeat
        // -------------
            
        } else {
            finalPaymentDueCellHeight = 0
            totalNumberOfPaymentsHeight = 0
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // ----------
    // Table View
    // ----------
    
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
                case 6:
                    return totalNumberOfPaymentsHeight
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                
                // -------------------------------
                // user tapped 'first payment due'
                // -------------------------------
                
                if firstPaymentDatePickerHeight == 0 {
                    // show datepicker and turn text color red
                    firstPaymentDatePickerHeight = 216
                    firstPaymentDueDateLabel.textColor = .red
                    // collapse other pickers and turn their colors to light gray
                    repeatPickerHeight = 0
                    repeatsLabel.textColor = .lightGray
                    finalPaymentDatePickerHeight = 0
                    finalPaymentDueDateLabel.textColor = .lightGray
                } else {
                    firstPaymentDatePickerHeight = 0
                    firstPaymentDueDateLabel.textColor = .lightGray
                }
            }
            
            if indexPath.row == 2 {
                
                // ---------------------
                // user tapped 'repeats'
                // ---------------------
                
                if repeatPickerHeight == 0 {
                    // expand picker
                    repeatPickerHeight = 120
                    repeatsLabel.textColor = .red
                    // hide other pickers and turn their colors back to light gray
                    firstPaymentDatePickerHeight = 0
                    firstPaymentDueDateLabel.textColor = .lightGray
                    finalPaymentDatePickerHeight = 0
                    finalPaymentDueDateLabel.textColor = .lightGray
                } else {
                    repeatPickerHeight = 0
                    repeatsLabel.textColor = .lightGray
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
        
        // 1. make sure name is not blank
        // 2. then make sure name is not duplicate
        // 3. then make sure amount is not blank
        
        if expenseNameTextField.text == "" {
            blankNameAlert()
        } else if expenseAmountTextField.text == "" {
            blankAmountAlert()
        } else {
            if expense?.expenseName == expenseNameTextField.text {
                updateExpenseInfo()
                dismiss(animated: true, completion: nil)
            } else {
                let dupArray = Expense.expensesArray.filter({ $0.ownerName == currentUserName && $0.category == expense?.category })
                if dupArray.contains(where: { $0.expenseName == expenseNameTextField.text }) {
                    duplicateNameAlert()
                } else {
                    updateExpenseInfo()
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func loadExistingExpenseData() {
        if let existingExpense = expense {
            expenseNameTextField.text = existingExpense.expenseName
            expenseAmountTextField.text = "\(existingExpense.amount)"
            hasDueDateSwitch.isOn = existingExpense.hasDueDate
            
            // update First Payment Due Date Picker with correct date (if there is one, otherwise make the date today's date)
            firstPaymentDueDate = "\(existingExpense.firstPayment)"
            let dateFromString = formatterForFirebase.date(from: firstPaymentDueDate!)
            firstPaymentDatePickerView.date = dateFromString ?? Date()
            
            // show first payment as text in first payment text field (if there is one, otherwise make the date today)
            firstPaymentDueDateLabel.text = formatterForLabel.string(from: dateFromString ?? Date())
            
            repeatsLabel.text = existingExpense.repeats
            if existingExpense.repeats != "never" {
                // show final payment due row if the repeat button is set to anything other than "never"
                totalNumberOfPaymentsHeight = 44
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
            let dateFromString2 = formatterForFirebase.date(from: finalPaymentDueDate!)
            finalPaymentDatePickerView.date = dateFromString2 ?? Date()
            
            // show final payment as text in final payment text field (if there is one, otherwise make the date today)
            finalPaymentDueDateLabel.text = formatterForLabel.string(from: dateFromString2 ?? Date())
            
            // calculate total at bottom
//            if existingExpense.repeats == "monthly" {
//                let numberOfMonths = dateFromString2?.months(from: dateFromString!)
//                yearlyTotalLabel.text = "\(existingExpense.expenseName) = $\(existingExpense.amount * numberOfMonths!)"
//            } else if existingExpense.repeats == "weekly" {
//                let numberOfWeeks = dateFromString2?.weeks(from: dateFromString!)
//                yearlyTotalLabel.text = "\(existingExpense.expenseName) = $\(existingExpense.amount * numberOfWeeks!)"
//            } else {
//                yearlyTotalLabel.text = "\(existingExpense.expenseName) = $\(existingExpense.amount)"
//            }
            updateTotals()
        }
    }
    
    func updateTotals() {
        let firstPayment = formatterForFirebase.date(from: firstPaymentDueDate!)
        let finalPayment = formatterForFirebase.date(from: finalPaymentDueDate!)
        if repeatsLabel.text == "weekly" {
            let numberOfWeeks = finalPayment?.weeks(from: firstPayment!)
            if expenseNameTextField.text != "" && Int(expenseAmountTextField.text!) != nil {
                totalNumberOfPaymentsLabel.text = "\(numberOfWeeks!)"
                yearlyTotalLabel.text = "\(expenseNameTextField.text!) = $\(Int(expenseAmountTextField.text!)! * numberOfWeeks!)"
            }
        } else if repeatsLabel.text == "monthly" {
            let numberOfMonths = finalPayment?.months(from: firstPayment!)
            if expenseNameTextField.text != "" && Int(expenseAmountTextField.text!) != nil {
                totalNumberOfPaymentsLabel.text = "\(numberOfMonths!)"
                yearlyTotalLabel.text = "\(expenseNameTextField.text!) = $\(Int(expenseAmountTextField.text!)! * numberOfMonths!)"
            }
        } else {
            yearlyTotalLabel.text = "\(expenseNameTextField.text!)"
        }
    }
    
    func updateExpenseInfo() {
        for (index, item) in Expense.expensesArray.enumerated() {
            if item.ownerName == currentUserName && item.expenseName == expense?.expenseName && item.category == expense?.category {
                Expense.expensesArray[index].expenseName = expenseNameTextField.text!
                Expense.expensesArray[index].amount = Int(expenseAmountTextField.text!)!
                if hasDueDateSwitch.isOn {
                    Expense.expensesArray[index].hasDueDate = true
                    Expense.expensesArray[index].firstPayment = firstPaymentDueDate!
                    if repeatsLabel.text != "never" {
                        Expense.expensesArray[index].repeats = repeatsLabel.text!
                        Expense.expensesArray[index].finalPayment = finalPaymentDueDate!
                    } else {
                        Expense.expensesArray[index].repeats = "never"
                        Expense.expensesArray[index].finalPayment = "none"
                    }
                } else {
                    Expense.expensesArray[index].hasDueDate = false
                    Expense.expensesArray[index].firstPayment = "none"
                    Expense.expensesArray[index].repeats = "never"
                    Expense.expensesArray[index].finalPayment = "none"
                }
            }
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
//                self.expenseNameTextField.becomeFirstResponder()          // for some reason, this causes a spellcheck error with Xcode
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func hasDueDateSwitchTapped(_ sender: UISwitch) {
        
        if firstPaymentDueDate == "none" {
            // make first payment due date equal to today
            firstPaymentDueDate = formatterForFirebase.string(from: Date())
        }

        view.endEditing(true)
        tableView.beginUpdates()
        tableView.endUpdates()
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
        updateTotals()
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



