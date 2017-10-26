import UIKit

class Step5ExpenseDetail123VC: UIViewController {

    let datePicker = UIDatePicker()
    @IBOutlet weak var dueDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(Step5ExpenseDetail123VC.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        dueDate.inputView = datePicker
        datePicker.backgroundColor = UIColor.white
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium                // Shows how date is displayed
        formatter.timeStyle = DateFormatter.Style.none                  // No time, just date
        dueDate.text = formatter.string(from: sender.date)              // show date picked in the text field
    }
}
