import UIKit
import Firebase

class Step4PaydayInspectVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    @IBOutlet weak var paydayParentButton: UIButton!
    @IBOutlet weak var paydayDateButton: UIButton!
    @IBOutlet weak var paydayDatePicker: UIPickerView!
    @IBOutlet weak var paydayDateTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var inspectionsParentButton: UIButton!
    @IBOutlet weak var inspectionsParentTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: UIButton!
    
    let paydayOptions = [["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
                         ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"],
                         ["AM", "PM"]]
    
    var selectedDay: String = "Sunday"
    var selectedHour: String = "1"
    var selectedAMPM: String = "AM"
    var paydayTimeConfirmed = false
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    let parents = User.finalUsersArray.filter({ return $0.childParent == "parent" })

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        paydayDateTopConstraint.constant = -(thirdView.bounds.height)
        inspectionsParentTopConstraint.constant = -(fourthView.bounds.height)
        paydayDatePicker.delegate = self
        paydayDateButton.layer.backgroundColor = UIColor.red.cgColor
        paydayDateButton.setTitle("\(selectedDay) \(selectedHour) \(selectedAMPM)?", for: .normal)
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        loadExistingAssignments()
    }
    
    
    // -----------
    // Date Picker
    // -----------

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return paydayOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return paydayOptions[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if component == 0 {
            return 130
        } else if component == 1 {
            return 60
        } else {
            return 60
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.font = UIFont.systemFont(ofSize: 23.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = paydayOptions[component][row]
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // change button color to indicate a change has been made but not updated
        paydayDateButton.layer.backgroundColor = UIColor.red.cgColor
        if component == 0 {
            selectedDay = paydayOptions[component][row]
        } else if component == 1 {
            selectedHour = paydayOptions[component][row]
        } else {
            selectedAMPM = paydayOptions[component][row]
        }
        paydayTimeConfirmed = false
        paydayDateButton.setTitle("\(selectedDay) \(selectedHour) \(selectedAMPM)?", for: .normal)
    }
    
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func paydayParentButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select A Parent", message: "Please choose a parent to hold weekly payday.", preferredStyle: .alert)
        // add list of parents
        for parent in parents {
            alert.addAction(UIAlertAction(title: parent.firstName, style: .default, handler: { (action) in
                self.paydayParentButton.setTitle(parent.firstName, for: .normal)
                self.paydayParentButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor     // green
                UIView.animate(withDuration: 0.25) {
                    self.paydayDateTopConstraint.constant = 0        // reveal next button
                    self.view.layoutIfNeeded()
                }
                self.scrollPageIfNeeded()
                // send selection to Firebase
                self.ref.child("paydayAndInspections").child("payday").updateChildValues(["name" : "weekly payday",
                                                                                          "multiplier" : 1,
                                                                                          "assigned" : parent.firstName,
                                                                                          "order" : 0])
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func paydayDateButtonTapped(_ sender: UIButton) {
        paydayTimeConfirmed = true
        // update color to green
        paydayDateButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor     // green
        // update button to show date user selected
        paydayDateButton.setTitle("\(selectedDay) \(selectedHour) \(selectedAMPM)", for: .normal)
        UIView.animate(withDuration: 0.25) {
            self.inspectionsParentTopConstraint.constant = 0     // reveal next button
            self.view.layoutIfNeeded()
            self.scrollPageIfNeeded()
        }
        
        // MARK: TODO - append / update local variable
        
        
        
        // send selection to Firebase
        self.ref.updateChildValues(["paydayTime" : "\(selectedDay) \(selectedHour) \(selectedAMPM)"])
        ref.child("paydayTime").removeAllObservers()
    }
    
    @IBAction func inspectionsParentButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select A Parent", message: "Please choose which parent will be responsible for performing daily inspections.", preferredStyle: .alert)
        for parent in parents {
            alert.addAction(UIAlertAction(title: parent.firstName, style: .default, handler: { (action) in
                self.inspectionsParentButton.setTitle(parent.firstName, for: .normal)
                self.inspectionsParentButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor     // green
                self.nextButton.isEnabled = true
                
                // send selection to Firebase
                self.ref.child("paydayAndInspections").child("inspections").updateChildValues(["name" : "daily inspections",
                                                                                               "multiplier" : 1,
                                                                                               "assigned" : parent.firstName,
                                                                                               "order" : 0])
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if paydayTimeConfirmed == false {
            let alert = UIAlertController(title: "Payday Time", message: "Please confirm your payday time by tapping the red payday button.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "AssignmentSummary", sender: self)
        }
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func loadExistingAssignments() {
        let inspectionParentName = JobsAndHabits.parentalDailyJobsArray[0].assigned
        let paydayParentName = JobsAndHabits.parentalWeeklyJobsArray[0].assigned
        
        if paydayParentName != "" {
            paydayParentButton.setTitle(paydayParentName, for: .normal)
            paydayParentButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor     // green
            paydayDateTopConstraint.constant = 0        // reveal next button
        }
        
        if FamilyData.paydayTime != "" {
            paydayDateButton.setTitle(FamilyData.paydayTime, for: .normal)
            paydayDateButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor     // green
            inspectionsParentTopConstraint.constant = 0     // reveal next button
            paydayTimeConfirmed = true
        }
        
        if inspectionParentName != "" {
            inspectionsParentButton.setTitle(inspectionParentName, for: .normal)
            inspectionsParentButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor     // green
            self.nextButton.isEnabled = true
        }
    }
    
    func scrollPageIfNeeded() {
        let height1 = self.secondView.bounds.height
        let height2 = self.paydayDateTopConstraint.constant + self.thirdView.bounds.height
        let height3 = self.inspectionsParentTopConstraint.constant + self.fourthView.bounds.height
        let heightTotal = height1 + height2 + height3
        
        if heightTotal > self.scrollView.bounds.height {
            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        }
    }
}







