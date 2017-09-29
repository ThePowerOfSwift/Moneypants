import UIKit

class Step3AddJobVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var navBarTitle: String = ""            // for allowing other VCs to change navbar title
    
    var job: JobsAndHabits?                 // 'job' is an instance of 'JobsAndHabits' class
    var dailyJobs: [JobsAndHabits]?         // This value will get passed from Step3VC
    var weeklyJobs: [JobsAndHabits]?        // This value will get passed from Step3VC
    var jobSection: Int?                    // this value passed from Step3VC alert when user chose to add 'daily' or 'weekly' job
    
    var jobDescription: String = ""
    var jobMultiplier: Double!
    var jobClassification: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobTextField.text = jobDescription
        jobTextField.delegate = self
        navBar.topItem?.title = navBarTitle
        
        // Set up view if editing an existing job
        if let existingJob = job {          // check to see if 'job' is not nil
            jobTextField.text = existingJob.name
            jobMultiplier = existingJob.multiplier
            jobClassification = existingJob.assigned
        }
        
        updateSaveButtonState()
    }
    
    
    // ---------------------
    // Cancel & Save Buttons
    // ---------------------
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    // This gets executed when 'SAVE' button is tapped, before segue is performed
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if jobSection == 0 {
            for job in dailyJobs! {
                if job.name.lowercased() == (jobTextField.text?.lowercased()) {        // check to see if lowercased text matches
                    duplicateNameAlert()
                    return false
                }
            }
            return true
        } else if jobSection == 1 {
            for job in weeklyJobs! {
                if job.name.lowercased() == (jobTextField.text?.lowercased()) {
                    duplicateNameAlert()
                    return false
                }
            }
            return true
        } else {
            return true
        }
    }
    
    
    
    
    // This is what gets executed when "SAVE" button is tapped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // set new job name to be passed back to Step3VC after the unwind segue
        let name = jobTextField.text
        
        // MARK: need to update this value if user adds more than the default 10 jobs
        let multiplier = job?.multiplier ?? 1
        
        // NOTE: the default assignment is "none"
        let assigned = job?.assigned ?? "none"
        
        let order = job?.order ?? 1
        
        job = JobsAndHabits(jobName: name!, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
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
        if jobTextField.text != "" {     // Enable button only if field isn't empty
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func duplicateNameAlert() {
        let alert = UIAlertController(title: "Add Job", message: "You have entered in a job with the same name as another job. Please choose a unique name for this job.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {
                self.jobTextField.becomeFirstResponder()          // for some reason, this causes a spellcheck error with Xcode
            })
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    // ----------------------------------------------------------
    // MARK: Dismiss keyboard if user taps outside of text fields
    // ----------------------------------------------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
