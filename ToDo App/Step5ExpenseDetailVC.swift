import UIKit

class Step5ExpenseDetailVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var expenseNameTextField: UITextField!
    @IBOutlet weak var expenseAmountTextField: UITextField!
    @IBOutlet weak var repeatingExpenseSwitch: UISwitch!
    @IBOutlet weak var firstPaymentDueDateLabel: UILabel!
    @IBOutlet weak var repeatsLabel: UILabel!
    @IBOutlet weak var repeatsPickerView: UIPickerView!
    @IBOutlet weak var finalPaymentDueDateLabel: UILabel!
    @IBOutlet weak var yearlyTotalLabel: UILabel!
    
//    var firstPaymentDueCellExpanded: Bool = false
    var firstPaymentDatePickerHeight: CGFloat = 0
//    var repeatCellExpanded: Bool = false
    var repeatPickerHeight: CGFloat = 0
    var finalPaymentDueCellHeight: CGFloat = 0
//    var lastPaymentDueCellExpanded: Bool = false
    var finalPaymentDatePickerHeight: CGFloat = 0
    
    let repeatOptions = ["never", "weekly", "monthly"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repeatingExpenseSwitch.isOn = false
        repeatsLabel.text = "never"
        repeatsPickerView.delegate = self
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
                } else {
                    firstPaymentDatePickerHeight = 216
                }
            }
            if indexPath.row == 2 {
                if repeatPickerHeight == 120 {
                    repeatPickerHeight = 0
                } else {
                    repeatPickerHeight = 120
                }
            }
            if indexPath.row == 4 {
                if finalPaymentDatePickerHeight == 216 {
                    finalPaymentDatePickerHeight = 0
                } else {
                    finalPaymentDatePickerHeight = 216
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
            if repeatingExpenseSwitch.isOn == false {
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
            if repeatingExpenseSwitch.isOn == false {
                return 0
            }
        }
        return 44
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // ---------
    // Functions
    // ---------
    
    @IBAction func repeatingExpenseSwitchTapped(_ sender: UISwitch) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}
