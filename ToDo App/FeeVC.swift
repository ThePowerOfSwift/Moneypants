import UIKit

class FeeVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var feeTextField: UITextField!
    let feePicker = UIPickerView()
    let fees = ["fighting", "lying", "stealing", "disobedience", "bad language"]
    
    let (userName, _, _) = tempUsers[homeIndex]
    var feeDesc: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = userName
        
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
        feeDesc = feeTextField.text
        if feeDesc == "" {
            print("feeDesc is blank")
            feeDesc = "blank"
        }
        let alert = UIAlertController(title: "Add Fee", message: "You have chosen to add a $1.00 fee for \"\(feeDesc!)\" to \(userName)'s account. Tap okay to confirm.", preferredStyle: .alert)
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
    
}
