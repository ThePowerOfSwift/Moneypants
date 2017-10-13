import UIKit
import Firebase

class Step2UsersVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var passcodeTextField: UITextField!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var parentButton: UIButton!
    @IBOutlet weak var childButton: UIButton!
    
    var navBarTitle: String = ""
    
    var genderValue: String = ""
    var childParentValue: String = ""
    var birthDate: String = ""
    
    var selectedProfileImage: UIImage!
    var user: User?
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem?.title = navBarTitle
        
        // -----------------
        // Date Picker Setup
        // -----------------
        
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(sender:)), for: UIControlEvents.valueChanged)
        birthdayTextField.inputView = datePicker
        datePicker.backgroundColor = UIColor.white
        
        nameTextField.delegate = self
        birthdayTextField.delegate = self
        passcodeTextField.delegate = self
        
        // -------------------------
        // Customize Buttons & Photo
        // -------------------------
        
        customizeButton(buttonName: maleButton)
        customizeButton(buttonName: femaleButton)
        customizeButton(buttonName: parentButton)
        customizeButton(buttonName: childButton)
        customizeButton(buttonName: photoImageView)
        
        // ------------------
        // Edit Existing User
        // ------------------
        
        if let existingUser = user {
            photoImageView.image = existingUser.photo
            nameTextField.text = existingUser.firstName
            nameTextField.isUserInteractionEnabled = false
            nameTextField.textColor = UIColor.lightGray
            birthDate = "\(existingUser.birthday)"
            
            // update Date Picker with correct birthday
            let dateString = "\(existingUser.birthday)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            let dateFromString = dateFormatter.date(from: dateString)
            datePicker.date = dateFromString!
            
            // show birthday as text in birthday text field
            dateFormatter.dateStyle = .medium
            birthdayTextField.text = dateFormatter.string(from: dateFromString!)
            
            passcodeTextField.text = "\(existingUser.passcode)"
            genderValue = existingUser.gender
            
            // highlight appropriate gender button
            if genderValue == "male" {
                maleButton.isSelected = true
            } else {
                femaleButton.isSelected = true
            }
            
            childParentValue = existingUser.childParent
            
            // highlight appropriate parent / child button
            if childParentValue == "child" {
                childButton.isSelected = true
            } else {
                parentButton.isSelected = true
            }
        }
        
        updateSaveButtonState()         // Enable Save button only if all fields are filled out
    }
    
    
    // --------------------
    // MARK: Choose Picture
    // --------------------
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss picker if user cancels
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may have multiple versions of the image. We want to use the original
        if let libraryImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedProfileImage = libraryImage     // assign variable for use with Firebase
            photoImageView.image = libraryImage     // assign user-selected image to profile picture on screen
        }
        updateSaveButtonState()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        view.endEditing(true)
        
        let imagePickerController = UIImagePickerController()
        
        // Only allow pictures to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // ---------------------------
    // MARK: Cancel & Save Buttons
    // ---------------------------
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photo = photoImageView.image!
        let name = nameTextField.text!
        let birthday = Int(birthDate)!
        let passcode = Int(passcodeTextField.text!)!
        let gender = genderValue
        let childParent = childParentValue
        
        user = User(photo: photo,
                    firstName: name,
                    birthday: birthday,
                    passcode: passcode,
                    gender: gender,
                    childParent: childParent)
    }
    
    
    // -----------------------
    // MARK: Button Selections
    // -----------------------
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        if !maleButton.isSelected {
            maleButton.isSelected = true
            genderValue = "male"
            femaleButton.isSelected = false
        } else {
            maleButton.isSelected = false
            femaleButton.isSelected = true
            genderValue = "female"
        }
        updateSaveButtonState()
    }
    
    @IBAction func femaleButtonTapped(_ sender: UIButton) {
        if !femaleButton.isSelected {
            femaleButton.isSelected = true
            genderValue = "female"
            maleButton.isSelected = false
        } else {
            femaleButton.isSelected = false
            maleButton.isSelected = true
            genderValue = "male"
        }
        updateSaveButtonState()
    }
    
    @IBAction func parentButtonTapped(_ sender: UIButton) {
        if !parentButton.isSelected {
            parentButton.isSelected = true
            childParentValue = "parent"
            childButton.isSelected = false
        } else {
            parentButton.isSelected = false
            childButton.isSelected = true
            childParentValue = "child"
        }
        updateSaveButtonState()
    }
    
    @IBAction func childButtonTapped(_ sender: UIButton) {
        if !childButton.isSelected {
            childButton.isSelected = true
            childParentValue = "child"
            parentButton.isSelected = false
        } else {
            childButton.isSelected = false
            parentButton.isSelected = true
            childParentValue = "parent"
        }
        updateSaveButtonState()
    }
    
    
    // ---------------------------
    // MARK: Show/Hide Save Button
    // ---------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false            // Disable save button while editing
        cancelButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()                 // Run function after editing is done
        cancelButton.isEnabled = true
    }
    
    private func updateSaveButtonState() {
        
        let placeholderImage = UIImage(named: "choose photo")
        let providedName = nameTextField.text ?? ""                 // Check to see if fields are empty
        let providedPassword = passcodeTextField.text ?? ""
        let providedBirthday = birthdayTextField.text ?? ""
        let providedGender = genderValue
        let providedParent = childParentValue
        
        if (photoImageView.image != placeholderImage) &&
            (!providedName.isEmpty && !providedBirthday.isEmpty && !providedGender.isEmpty && !providedParent.isEmpty) &&
            (providedPassword.characters.count == 4) {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    // ----------------------
    // MARK: Input Validation
    // ----------------------
    
    // Verify age
    @IBAction func datePickerEditingDidEnd(_ sender: Any) {
        verifyAge()
    }
    
    func verifyAge() {
        let dateOfBirth = datePicker.date
        print("Datepicker.date = ",dateOfBirth)
        let gregorian = Calendar(identifier: .gregorian)
        let ageComponents = gregorian.dateComponents([.year], from: dateOfBirth, to: Date())
        let age = ageComponents.year!
        if age < 2 {
            createAlert(title: "Age Error", message: "Individuals must be at least two years old to use The Moneypants Solution. Please enter a valid birthday.", textField: birthdayTextField)
            //        } else if age > 25 {
            //            createAlert(title: "Too old!", message: "Children should be younger than 25.")
        } else {
            print("\(age) is a good age")
        }
        
        // convert datepicker text into Int for Firebase storage
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        birthDate = dateFormatter.string(from: dateOfBirth)
    }
    
    @IBAction func usernameEditingDidEnd(_ sender: Any) {
        for user in User.finalUsersArray {
            if user.firstName.lowercased() == nameTextField.text?.lowercased() {
                createAlert(title: "Username Error", message: "You have entered in a username that is the same as another user. Please choose a unique name for this user.", textField: nameTextField)
            }
        }
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium                // Shows how date is displayed
        formatter.timeStyle = DateFormatter.Style.none                  // No time, just date
        birthdayTextField.text = formatter.string(from: sender.date)    // show date picked in the text field
    }
    
    // Verify passcode
    @IBAction func passcodeEditingDidEnd(_ sender: Any) {
        if Int(passcodeTextField.text!) == nil || (passcodeTextField.text?.characters.count)! < 4 {
            createAlert(title: "Passcode Error", message: "Passcodes must have exactly four numbers. Please choose a 4-digit passcode.", textField: passcodeTextField)
        }
    }
    
    
    // --------------------
    // MARK: Alert template
    // --------------------
    
    func createAlert (title: String, message: String, textField: UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        // Okay Button
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            textField.becomeFirstResponder()        // don't allow user to move on to any other field until they input correct info
        })
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    // -------------------------------------
    // Customize rounded buttons with border
    // -------------------------------------

    func customizeButton(buttonName: AnyObject) {
        buttonName.layer.cornerRadius = buttonName.bounds.height / 6.4
        buttonName.layer.masksToBounds = true
        buttonName.layer.borderColor = UIColor.lightGray.cgColor
        buttonName.layer.borderWidth = 0.5
    }
    
    
    // ----------------------------------------------------------
    // MARK: Dismiss keyboard if user taps outside of text fields
    // ----------------------------------------------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}










