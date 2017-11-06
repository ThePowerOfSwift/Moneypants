import UIKit
import Firebase

class Step7EditHabitsVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var habitTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var habit: JobsAndHabits!                  // is passed from Step7HabitsVC
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        habitTextField.delegate = self      // for truncating job name to 25 characters
        habitTextField.text = habit.name
        
        updateSaveButtonState()
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        if checkForDuplicateNames() == true {
            print("no duplicates found")
            for (index, userHabit) in JobsAndHabits.finalDailyHabitsArray.enumerated() {
                if userHabit.assigned == habit.assigned && userHabit.name == habit.name {       // filter out all other users...
                    JobsAndHabits.finalDailyHabitsArray[index].name = habitTextField.text!      // ...then replace old habit name with new one
                    
                    // send update to Firebase
                    ref.child("dailyHabits").child(habit.assigned).queryOrdered(byChild: "name").queryEqual(toValue: habit.name).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                        snapshot.ref.updateChildValues(["name" : self.habitTextField.text!])
                    })
                }
            }
            view.endEditing(true)
            dismiss(animated: true, completion: nil)
        } else {
            duplicateNameAlert()
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func checkForDuplicateNames() -> Bool {
        // check if new job name is found in the current user's habit array (not entire habits array for all users)
        for habit in JobsAndHabits.finalDailyHabitsArray.filter({ return $0.assigned == habit.assigned }) {
            if habit.name.lowercased() == habitTextField.text?.lowercased() {
                duplicateNameAlert()
                return false
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        if habitTextField.text != "" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func duplicateNameAlert() {
        let alert = UIAlertController(title: "Edit Habit", message: "You have entered in a habit with the same name as another habit. Please choose a unique name for this habit.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
                self.habitTextField.becomeFirstResponder()          // for some reason, this causes a spellcheck error with Xcode
            })
        }))
        present(alert, animated: true, completion: nil)
    }
}
