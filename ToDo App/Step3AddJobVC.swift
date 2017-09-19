import UIKit

class Step3AddJobVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var newJobTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var jobTextField: String = ""
    var navBarTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newJobTextField.text = jobTextField
        newJobTextField.delegate = self
        navBar.topItem?.title = navBarTitle
        
        updateSaveButtonState()
    }
    
    
    // ---------------------
    // Cancel & Save Buttons
    // ---------------------
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        print("save button tapped")
    }
    
    
    // ---------------------------
    // MARK: Show/Hide Save Button
    // ---------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false        // Disable save button while editing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()             // Run function after editing is done
    }

    func updateSaveButtonState() {
        if newJobTextField.text != "" {     // Enable button only if field isn't empty
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    // ----------------------------------------------------------
    // MARK: Dismiss keyboard if user taps outside of text fields
    // ----------------------------------------------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    
}
