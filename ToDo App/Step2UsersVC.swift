import UIKit
import Firebase

class Step2UsersVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var passcodeTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var parentButton: UIButton!
    @IBOutlet weak var childButton: UIButton!
    
    var genderValue: String = ""
    var childParentValue: String = ""
    var birthDate: String = ""
    
    var selectedProfileImage: UIImage!
    var user: User?
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference?
    var storageRef: FIRStorageReference?
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "new user"
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        
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
        
        updateSaveButtonState()         // Enable Save button only if all fields are filled out
    }
    
    func customizeButton(buttonName: AnyObject) {
        buttonName.layer.cornerRadius = buttonName.bounds.height / 6.4
        buttonName.layer.masksToBounds = true
        buttonName.layer.borderColor = UIColor.lightGray.cgColor
        buttonName.layer.borderWidth = 0.5
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
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let photo = photoImageView.image!
        let firstName = nameTextField.text!
        let birthday = Int(birthDate)!
        let passcode = Int(passcodeTextField.text!)!
        let gender = genderValue
        let childParent = childParentValue
        
        // Set the user to be passed to UserTableViewController after the unwind segue:
        self.user = User(profilePhoto: photo,
                         userFirstName: firstName,
                         userBirthday: birthday,
                         userPasscode: passcode,
                         userGender: gender,
                         isUserChildOrParent: childParent)
        
        // get profile image data prepped for storage on Firebase
        let storageRef = FIRStorage.storage().reference().child("users").child(firebaseUser.uid).child("members").child(firstName)
        if let profileImg = selectedProfileImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            
            // save user image to Firebase
            storageRef.put(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                // get Firebase image location and return the URL as a string
                let profileImageUrl = (metadata?.downloadURL()?.absoluteString)!
                // save user data to Firebase
                self.ref?.child("users").child(self.firebaseUser.uid).child("members").child(firstName).setValue(["profileImageUrl" : profileImageUrl,
                                                                                                                  "firstName" : firstName,
                                                                                                                  "birthday" : birthday,
                                                                                                                  "passcode" : passcode,
                                                                                                                  "gender" : gender,
                                                                                                                  "childParent" : childParent])
            })
        }
        dismiss(animated: true, completion: nil)
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
//        print(genderValue)
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
//        print(genderValue)
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
//        print(childParentValue)
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
//        print(childParentValue)
        updateSaveButtonState()
    }
    
    
    
    // ---------------------------
    // MARK: Show/Hide Save Button
    // ---------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false            // Disable save button while editing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()                 // Run function after editing is done
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
    // MARK: DatePicker Setup
    // ----------------------
    
    func verifyAge() {
        let dateOfBirth = datePicker.date
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        birthDate = dateFormatter.string(from: dateOfBirth)
        print("BIRTH DATE:",birthDate)
    }
    
    
    // ----------------------
    // MARK: Input Validation
    // ----------------------
    
    
    // Verify age
    @IBAction func datePickerEditingDidEnd(_ sender: Any) {
        verifyAge()
    }
    
    func datePickerValueChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium                // Shows how date is displayed
        formatter.timeStyle = DateFormatter.Style.none                  // No time, just date
        birthdayTextField.text = formatter.string(from: sender.date)    // show date picked in the text field
    }
    
    
    // Verify passcode
    @IBAction func passcodeEditingDidEnd(_ sender: Any) {
        if (passcodeTextField.text?.characters.count)! < 4 {
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
    
    
    // ----------------------------------------------------------
    // MARK: Dismiss keyboard if user taps outside of text fields
    // ----------------------------------------------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    
}










