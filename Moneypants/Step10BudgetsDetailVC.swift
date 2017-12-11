import UIKit
import Firebase

class Step10BudgetsDetailVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    
    // for when user taps 'savings' from Step10BudgetsVC
    @IBOutlet weak var expenseAmountCell: UITableViewCell!
    @IBOutlet weak var hasDueDateCell: UITableViewCell!
    @IBOutlet weak var expenseAmountDollarSignLabel: UILabel!
    @IBOutlet weak var hasDueDateLabel: UILabel!
    var expenseAmountCellIsEnabled = true
    var hasDueDateCellIsEnabled = true
    var expenseAmountDollarSignLabelColor = UIColor.black
    var hasDueDateLabelColor = UIColor.black
    var expenseAmountTextFieldColor = UIColor.black
    // end for when user taps 'savings' from Step10BudgetsVC
    
    var firstPaymentDatePickerHeight: CGFloat = 0
    var repeatPickerHeight: CGFloat = 0
    var finalPaymentDueCellHeight: CGFloat = 0
    var finalPaymentDatePickerHeight: CGFloat = 0
    var totalNumberOfPaymentsHeight: CGFloat = 0
    var firstPaymentDueTimestamp: TimeInterval!
    var finalPaymentDueTimestamp: TimeInterval!
    
    var budgetItem: Budget?               // passed from Step10BudgetsVC
    var currentUserName: String!
    
    let repeatOptions = ["never", "weekly", "monthly"]
    let formatterForLabel = DateFormatter()
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hasDueDateCell.selectionStyle = .none
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        formatterForLabel.dateStyle = DateFormatter.Style.medium                        // Shows how date is displayed
//        formatterForLabel.timeStyle = DateFormatter.Style.none                          // No time, just date
        
        totalNumberOfPaymentsLabel.text = "1"
        
        // for when user taps 'savings' from Step10BudgetsVC
        expenseAmountCell.isUserInteractionEnabled = expenseAmountCellIsEnabled
        hasDueDateCell.isUserInteractionEnabled = hasDueDateCellIsEnabled
        expenseAmountDollarSignLabel.textColor = expenseAmountDollarSignLabelColor
        expenseAmountTextField.textColor = expenseAmountTextFieldColor
        hasDueDateLabel.textColor = hasDueDateLabelColor
        // end for when user taps 'savings' from Step10BudgetsVC
        
        expenseNameTextField.delegate = self
        expenseAmountTextField.delegate = self
        hasDueDateSwitch.isOn = false
        repeatsLabel.text = "never"
        repeatsPickerView.delegate = self
        hasDueDateSwitch.onTintColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)  // green
        
        currentUserName = MPUser.usersArray[MPUser.currentUser].firstName
        navigationItem.title = currentUserName!
        
        // ----------------------
        // edit exisiting expense
        // ----------------------
        
        loadExistingBudgetData()
    }
    
    // ------------
    // Date Pickers
    // ------------
    
    @IBAction func firstPaymentDueDateChanged(_ sender: UIDatePicker) {
        // take date from datepicker and format it to short date format for display on label
        firstPaymentDueDateLabel.text = formatterForLabel.string(from: sender.date)
        
        // take data from datepicker and format it for Firebase
        firstPaymentDueTimestamp = sender.date.timeIntervalSince1970
        
        // make sure first payment is AFTER first payday
        if firstPaymentDueTimestamp < FamilyData.calculatePayday().next.timeIntervalSince1970 {
            // user has selected a start date that is in the past
            let attributedString = NSMutableAttributedString(string: firstPaymentDueDateLabel.text!)
            attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributedString.length))
            firstPaymentDueDateLabel.attributedText = attributedString
        }
        
        // if first payment is later than final payment, then adjust final payment to move forward accordingly.
        if firstPaymentDueTimestamp >= finalPaymentDueTimestamp {
            // if repeats label is monthly, move the final due date ahead at least a month
            if repeatsLabel.text == "monthly" {
                finalPaymentDueTimestamp = Calendar.current.date(byAdding: .month, value: 1, to: Date(timeIntervalSince1970: firstPaymentDueTimestamp))?.timeIntervalSince1970
            // if repeats label is "weekly" or "none", move the final due date ahead at least a week
            } else {
                finalPaymentDueTimestamp = Calendar.current.date(byAdding: .day, value: 7, to: Date(timeIntervalSince1970: firstPaymentDueTimestamp))?.timeIntervalSince1970
            }
            // update pickerview to reflect new date
            finalPaymentDatePickerView.date = Date(timeIntervalSince1970: finalPaymentDueTimestamp)
            // update label to show user new updated date
            finalPaymentDueDateLabel.text = formatterForLabel.string(from: Date(timeIntervalSince1970: finalPaymentDueTimestamp))
        }
        
        updateTotals()
    }
    
    @IBAction func finalPaymentDueDateChanged(_ sender: UIDatePicker) {
        finalPaymentDueDateLabel.text = formatterForLabel.string(from: sender.date)
        finalPaymentDueTimestamp = sender.date.timeIntervalSince1970
        
        if firstPaymentDueTimestamp > finalPaymentDueTimestamp {
            // user has selected a start date that is in the past
            let attributedString = NSMutableAttributedString(string: finalPaymentDueDateLabel.text!)
            attributedString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributedString.length))
            finalPaymentDueDateLabel.attributedText = attributedString
        }
        
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

        // -----------------
        // for weekly repeat
        // -----------------
        
        if row == 1 {
            finalPaymentDueCellHeight = 44
            totalNumberOfPaymentsHeight = 44
            // add a week to first payment due date...
            let aWeekFromFirstPayment = Calendar.current.date(byAdding: .day, value: 7, to: Date(timeIntervalSince1970: firstPaymentDueTimestamp))
            // ...then format it for the label with an initial value
            finalPaymentDueDateLabel.text = formatterForLabel.string(from: aWeekFromFirstPayment!)
            finalPaymentDatePickerView.date = aWeekFromFirstPayment!
            finalPaymentDueTimestamp = aWeekFromFirstPayment?.timeIntervalSince1970
            
        // ------------------
        // for monthly repeat
        // ------------------
            
        } else if row == 2 {
            finalPaymentDueCellHeight = 44
            totalNumberOfPaymentsHeight = 44
            // add month to first payment due date...
            let aMonthFromFirstPayment = Calendar.current.date(byAdding: .month, value: 1, to: Date(timeIntervalSince1970: firstPaymentDueTimestamp))
            // ...then format it for the label
            finalPaymentDueDateLabel.text = formatterForLabel.string(from: aMonthFromFirstPayment!)
            finalPaymentDatePickerView.date = aMonthFromFirstPayment!
            finalPaymentDueTimestamp = aMonthFromFirstPayment?.timeIntervalSince1970
            
        // -------------
        // for no repeat
        // -------------
            
        } else {
            finalPaymentDueCellHeight = 0
            totalNumberOfPaymentsHeight = 0
        }
        updateTotals()
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
        view.endEditing(true)
        // 1. make sure name is not blank
        if expenseNameTextField.text == "" {
            blankNameAlert()
        // 2. then make sure amount is not blank
        } else if expenseAmountTextField.text == "" {
            blankAmountAlert()
        // 3. make sure first payment due is after first payday date
        } else if firstPaymentDueTimestamp < FamilyData.calculatePayday().next.timeIntervalSince1970 {
            dueDateBeforeFirstPaydayErrorAlert()
        // 4. make sure first payment is BEFORE final payment
        } else if firstPaymentDueTimestamp > finalPaymentDueTimestamp {
            finalPaymentBeforeFirstPaymentErrorAlert()
        // 5. make sure chosen due dates fall within the 1-year budget period
        } else if firstPaymentDueTimestamp > (FamilyData.budgetEndDate?.timeIntervalSince1970)! || finalPaymentDueTimestamp > (FamilyData.budgetEndDate?.timeIntervalSince1970)! {
            finalDueDateOutsideBudgetRangeAlert()
        // 6. then make sure name is not duplicate
        } else {
            if budgetItem?.expenseName == expenseNameTextField.text {
                updateBudgetInfo()
                dismiss(animated: true, completion: nil)
            } else {
                let dupArray = Budget.budgetsArray.filter({ $0.ownerName == currentUserName && $0.category == budgetItem?.category })
                if dupArray.contains(where: { $0.expenseName == expenseNameTextField.text }) {
                    duplicateNameAlert()
                } else {
                    updateBudgetInfo()
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func loadExistingBudgetData() {
        if let existingExpense = budgetItem {
            expenseNameTextField.text = existingExpense.expenseName
            expenseAmountTextField.text = "\(existingExpense.amount)"
            hasDueDateSwitch.isOn = existingExpense.hasDueDate
            
            // if first payment is '0', make first payment the same as next payday. Otherwise, return the 'first payment' values for the budget item
            if existingExpense.firstPayment == 0 {
                firstPaymentDueTimestamp = FamilyData.calculatePayday().next.timeIntervalSince1970
                firstPaymentDatePickerView.date = FamilyData.calculatePayday().next
                firstPaymentDueDateLabel.text = formatterForLabel.string(from: FamilyData.calculatePayday().next)
                
                print("D:",FamilyData.calculatePayday().next.timeIntervalSince1970,FamilyData.calculatePayday().next)
                print("E:",firstPaymentDueTimestamp,Date(timeIntervalSince1970: firstPaymentDueTimestamp))
                
            } else {
                firstPaymentDueTimestamp = existingExpense.firstPayment
                firstPaymentDatePickerView.date = Date(timeIntervalSince1970: firstPaymentDueTimestamp)
                firstPaymentDueDateLabel.text = formatterForLabel.string(from: Date(timeIntervalSince1970: firstPaymentDueTimestamp))
            }
            
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
            
            // if last payment is '0', make last payment the same as first payment plus a week / month. Otherwise, return the 'last payment' values for the budget item
            let timeAddedToFirstPayment: Date!
            if existingExpense.repeats == "monthly" {
                timeAddedToFirstPayment = Calendar.current.date(byAdding: .month, value: 1, to: Date(timeIntervalSince1970: firstPaymentDueTimestamp))
            } else {
                timeAddedToFirstPayment = Calendar.current.date(byAdding: .day, value: 7, to: Date(timeIntervalSince1970: firstPaymentDueTimestamp))
            }
            
            // if last payment is '0', make last payment the same as first payment plus a week / month. Otherwise, return the 'last payment' values for the budget item
            if existingExpense.finalPayment == 0 {
                finalPaymentDueTimestamp = timeAddedToFirstPayment.timeIntervalSince1970
                finalPaymentDatePickerView.date = timeAddedToFirstPayment
                finalPaymentDueDateLabel.text = formatterForLabel.string(from: timeAddedToFirstPayment)
            } else {
                finalPaymentDueTimestamp = existingExpense.finalPayment
                finalPaymentDatePickerView.date = Date(timeIntervalSince1970: finalPaymentDueTimestamp)
                finalPaymentDueDateLabel.text = formatterForLabel.string(from: Date(timeIntervalSince1970: finalPaymentDueTimestamp))
            }
            
            updateTotals()
        }
    }
    
    func updateTotals() {
        let firstPayment = Date(timeIntervalSince1970: firstPaymentDueTimestamp)
        let finalPayment = Date(timeIntervalSince1970: finalPaymentDueTimestamp)
        if repeatsLabel.text == "weekly" {
            let numberOfWeeks = finalPayment.weeks(from: firstPayment) + 1
            if expenseNameTextField.text != "" && Int(expenseAmountTextField.text!) != nil {
                totalNumberOfPaymentsLabel.text = "\(numberOfWeeks)"
                yearlyTotalLabel.text = "\(expenseNameTextField.text!) = $\(Int(expenseAmountTextField.text!)! * numberOfWeeks)"
            } else {
                totalNumberOfPaymentsLabel.text = "\(numberOfWeeks)"
                yearlyTotalLabel.text = "\(expenseNameTextField.text!) = $0"
            }
        } else if repeatsLabel.text == "monthly" {
            let numberOfMonths = finalPayment.months(from: firstPayment) + 1
            if expenseNameTextField.text != "" && Int(expenseAmountTextField.text!) != nil {
                totalNumberOfPaymentsLabel.text = "\(numberOfMonths)"
                yearlyTotalLabel.text = "\(expenseNameTextField.text!) = $\(Int(expenseAmountTextField.text!)! * numberOfMonths)"
            } else {
                totalNumberOfPaymentsLabel.text = "\(numberOfMonths)"
                yearlyTotalLabel.text = "\(expenseNameTextField.text!) = $0"
            }
        } else {
            yearlyTotalLabel.text = "\(expenseNameTextField.text!)"
        }
    }
    
    // only called when user taps 'save'
    func updateBudgetInfo() {
        for (index, item) in Budget.budgetsArray.enumerated() {
            if item.ownerName == currentUserName && item.expenseName == budgetItem?.expenseName && item.category == budgetItem?.category {
                // update local array...
                Budget.budgetsArray[index].expenseName = expenseNameTextField.text!
                Budget.budgetsArray[index].amount = Int(expenseAmountTextField.text!)!
                // ...and update Firebase (get snapshot of all budget items for current user, then sort by category and then by name)
                ref.child("budgets")
                    .child(currentUserName)
                    .child("\((budgetItem?.category)!) \((budgetItem?.order)!)")
                    .updateChildValues(["expenseName" : expenseNameTextField.text!,
                                        "amount" : Int(expenseAmountTextField.text!)!])
                
                // if expense amount is zero, nuke all the data
                if expenseAmountTextField.text == "0" {
                    Budget.budgetsArray[index].hasDueDate = false
                    Budget.budgetsArray[index].firstPayment = 0
                    Budget.budgetsArray[index].repeats = "never"
                    Budget.budgetsArray[index].finalPayment = 0
                    Budget.budgetsArray[index].totalNumberOfPayments = 1
                    // ...and update Firebase
                    ref.child("budgets")
                        .child(currentUserName)
                        .child("\((budgetItem?.category)!) \((budgetItem?.order)!)")
                        .updateChildValues(["hasDueDate" : false,
                                            "firstPayment" : 0,
                                            "repeats" : "never",
                                            "finalPayment" : 0,
                                            "totalNumberOfPayments" : 1])
                    
                // if expense has due date...
                } else if hasDueDateSwitch.isOn {
                    Budget.budgetsArray[index].hasDueDate = true
                    Budget.budgetsArray[index].firstPayment = firstPaymentDueTimestamp!
                    // ...and update Firebase
                    ref.child("budgets")
                        .child(currentUserName)
                        .child("\((budgetItem?.category)!) \((budgetItem?.order)!)")
                        .updateChildValues(["hasDueDate" : true,
                                            "firstPayment" : firstPaymentDueTimestamp!])
                    
                    // ...with repeat
                    if repeatsLabel.text != "never" {
                        Budget.budgetsArray[index].repeats = repeatsLabel.text!
                        Budget.budgetsArray[index].finalPayment = finalPaymentDueTimestamp!
                        Budget.budgetsArray[index].totalNumberOfPayments = Int(totalNumberOfPaymentsLabel.text!)!
                        // ...and udpate Firebase
                        ref.child("budgets")
                            .child(currentUserName)
                            .child("\((budgetItem?.category)!) \((budgetItem?.order)!)")
                            .updateChildValues(["repeats" : repeatsLabel.text!,
                                                "finalPayment" : finalPaymentDueTimestamp!,
                                                "totalNumberOfPayments" : Int(totalNumberOfPaymentsLabel.text!)!])
                        
                    // ...without repeat
                    } else {
                        Budget.budgetsArray[index].repeats = "never"
                        Budget.budgetsArray[index].finalPayment = 0
                        Budget.budgetsArray[index].totalNumberOfPayments = 1
                        // ...and update Firebase
                        ref.child("budgets")
                            .child(currentUserName)
                            .child("\((budgetItem?.category)!) \((budgetItem?.order)!)")
                            .updateChildValues(["repeats" : "never",
                                                "finalPayment" : 0,
                                                "totalNumberOfPayments" : 1])
                    }
                    
                // if expense has no due date
                } else {
                    Budget.budgetsArray[index].hasDueDate = false
                    Budget.budgetsArray[index].firstPayment = 0
                    Budget.budgetsArray[index].repeats = "never"
                    Budget.budgetsArray[index].finalPayment = 0
                    Budget.budgetsArray[index].totalNumberOfPayments = 1
                    // ...and update Firebase
                    ref.child("budgets")
                        .child(currentUserName)
                        .child("\((budgetItem?.category)!) \((budgetItem?.order)!)")
                        .updateChildValues(["hasDueDate" : false,
                                            "firstPayment" : 0,
                                            "repeats" : "never",
                                            "finalPayment" : 0,
                                            "totalNumberOfPayments" : 1])
                }
            }
        }
    }
    
    @IBAction func hasDueDateSwitchTapped(_ sender: UISwitch) {
        view.endEditing(true)
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == expenseAmountTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            if string.characters.count > 0 {
                var allowedCharacters = CharacterSet.alphanumerics
                allowedCharacters.insert(charactersIn: " -()#&") // "white space & hyphen"
                
                let unwantedStr = string.trimmingCharacters(in: allowedCharacters)
                return unwantedStr.characters.count == 0
            }
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateTotals()
    }
    
    // ------
    // Alerts
    // ------
    
    func finalDueDateOutsideBudgetRangeAlert() {
        let alert = UIAlertController(title: "Due Date Error", message: "The selected due date is past the limits of the current yearly budget.\n\nPlease choose a date that is on or before \(formatterForLabel.string(from: FamilyData.budgetEndDate!)).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (stuff) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func blankNameAlert() {
        let alert = UIAlertController(title: "Expense Name", message: "Please give this expense a name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func blankAmountAlert() {
        let alert = UIAlertController(title: "Expense Amount", message: "Please enter an amount for this expense.\n\nIf you wish to cancel this expense, simply add '0' to the amount.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func duplicateNameAlert() {
        let alert = UIAlertController(title: "Duplicate Name", message: "You have entered in an expense with the same name as another expense. Please choose a unique name for this expense.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func dueDateBeforeFirstPaydayErrorAlert() {
        let alert = UIAlertController(title: "Due Date Error", message: "The due date cannot be before your first payday. Please choose a date that is on or after \(formatterForLabel.string(from: Date(timeIntervalSince1970: FamilyData.budgetStartDate!))).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func finalPaymentBeforeFirstPaymentErrorAlert() {
        let alert = UIAlertController(title: "Final Due Date", message: "The final payment cannot be due before the first payment is due.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
            })
        }))
        present(alert, animated: true, completion: nil)
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



