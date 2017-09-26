import UIKit
import Firebase

class Step3VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var dailyJobs = [JobsAndHabits]()       // create variable called 'daily jobs' which is an array of type JobsAndHabits
    var weeklyJobs = [JobsAndHabits]()      // create variable called 'weekly jobs' which is an array of type JobsAndHabits
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        
        // Customize the question button
        questionButton.layer.cornerRadius = questionButton.bounds.height / 6.4
        questionButton.layer.masksToBounds = true
        
        // add + symbol in navbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJobButtonTapped))
        
        // MARK: need to load Firebase Data if it exists, then if not, load default jobs
        loadDefaultJobs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        jobsTableView.reloadData()
    }
    
    
    
    // ----------------
    // Setup Table View
    // ----------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyJobs.count
        } else {
            return weeklyJobs.count
        }
    }
    
    // populate rows with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = jobsTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step3CustomCell
        if indexPath.section == 0 {
            cell.jobLabel.text = dailyJobs[indexPath.row].name
        } else {
            cell.jobLabel.text = weeklyJobs[indexPath.row].name
        }
        return cell
    }
    
    //Give each table section a title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily jobs"
        } else {
            return "weekly jobs"
        }
    }
    
    // Customize header view
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "EditJob", sender: dailyJobs[indexPath.row])
        } else {
            performSegue(withIdentifier: "EditJob", sender: weeklyJobs[indexPath.row])
        }
    }
    
    // allow editing of rows
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // allow rearranging of rows
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == 0 {
            let job = dailyJobs[sourceIndexPath.row]
            dailyJobs.remove(at: sourceIndexPath.row)
            dailyJobs.insert(job, at: destinationIndexPath.row)
        } else {
            let job = weeklyJobs[sourceIndexPath.row]
            weeklyJobs.remove(at: sourceIndexPath.row)
            weeklyJobs.insert(job, at: destinationIndexPath.row)
        }
    }
    
    // allow deletion of rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                if dailyJobs.count <= 10 {           // check to make sure user isn't deleting too many jobs
                    deletedTooManyRowsAlert(alertTitle: "Daily Jobs", alertMessage: "You cannot delete this daily job. You must have at least 10 daily jobs in your list.")
                } else {
                    dailyJobs.remove(at: indexPath.row)
                    jobsTableView.deleteRows(at: [indexPath], with: .fade)
                }
            } else {
                if weeklyJobs.count <= 10 {
                    deletedTooManyRowsAlert(alertTitle: "Weekly Jobs", alertMessage: "You cannot delete this weekly job. You must have at least 10 weekly jobs in your list.")
                } else {
                    weeklyJobs.remove(at: indexPath.row)
                    jobsTableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    
    // ------------------
    // MARK: - Navigation
    // ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.dailyJobs = dailyJobs
            
            // 'sender' is retrieved from 'didSelectRow' function above
            nextController.job = sender as! JobsAndHabits?
            nextController.navBarTitle = "edit job"
        } else if segue.identifier == "AddJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.dailyJobs = dailyJobs
            nextController.navBarTitle = "add daily job"
        } else {
            print("segue initiated")
        }
    }
    
    @IBAction func unwindToStep3VC(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as! Step3AddJobVC
        let updatedJob = sourceVC.job
        if let selectedIndexPathSection = jobsTableView.indexPathForSelectedRow?.section {      // if tableview cell was selected to begin with
            
            // Update existing job
            if selectedIndexPathSection == 0 {
                let selectedIndexPathRow = jobsTableView.indexPathForSelectedRow
                dailyJobs[(selectedIndexPathRow?.row)!] = updatedJob!
                jobsTableView.reloadData()
            } else if selectedIndexPathSection == 1 {
                let selectedIndexPathRow = jobsTableView.indexPathForSelectedRow
                weeklyJobs[(selectedIndexPathRow?.row)!] = updatedJob!
                jobsTableView.reloadData()
            }
        } else {
            
            // Add a new daily job in the daily jobs array
            let newIndexPath = IndexPath(row: dailyJobs.count, section: 0)
            dailyJobs.append(updatedJob!)
            jobsTableView.insertRows(at: [newIndexPath], with: .fade)

            // scroll to the newly created item
            self.jobsTableView.scrollToRow(at: newIndexPath, at: UITableViewScrollPosition.middle, animated: true)
            
            // highlight the cell orange, then fade it to white
            self.jobsTableView.cellForRow(at: newIndexPath)?.backgroundColor = UIColor(red: 242/255, green: 101/255, blue: 34/255, alpha: 1.0)  // orange
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                UIView.animate(withDuration: 1.5, animations: {
                    self.jobsTableView.cellForRow(at: newIndexPath)?.backgroundColor = UIColor.white
                })
            })
            
            // ====================================================================================================================
            // This code works to animate the scroll to the cell, but I couldn't get cell color to work anywhere inside this method
//            UIView.transition(with: jobsTableView, duration: 1.0, options: .curveEaseIn, animations: {
//                self.jobsTableView.reloadData() }, completion: { (success) in
//                    if success {
//                        self.jobsTableView.scrollToRow(at: newIndexPath, at: .middle, animated: true)
//                    }
//            })
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        disableTableEdit()
        let dailyJobMultiplier = 10 / Double(dailyJobs.count)       // recalculates depending on if user adds more than 10 daily jobs
        ref.child("dailyJobs").removeValue()                // reset daily jobs
        var dailyCounter = 0
        var weeklyCounter = 0
        for dailyJob in dailyJobs {
            dailyCounter += 1
            ref.child("dailyJobs").child("dailyJob\(dailyCounter)").setValue(["name" : dailyJob.name,
                                                                              "multiplier" : dailyJobMultiplier,
                                                                              "classification" : dailyJob.classification,
                                                                              "order" : dailyCounter])
            ref.child("dailyJobs").updateChildValues(["count" : dailyJobs.count])            // return number of daily jobs
        }
        
        for weeklyJob in weeklyJobs {
            weeklyCounter += 1
            ref.child("weeklyJobs").child("weeklyJob\(weeklyCounter)").updateChildValues(["name" : weeklyJob.name,
                                                                                          "multiplier" : weeklyJob.multiplier,
                                                                                          "classification" : weeklyJob.classification,
                                                                                          "order" : weeklyCounter])
        }
        performSegue(withIdentifier: "AssignJobs", sender: self)
    }
    
    
    // ---------
    // Functions
    // ---------
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        if cellStyleForEditing == .none {
            cellStyleForEditing = .delete
            editButton.setTitle("done", for: .normal)
        } else {
            cellStyleForEditing = .none
            editButton.setTitle("edit", for: .normal)
        }
        jobsTableView.setEditing(cellStyleForEditing != .none, animated: true)
    }
    
    func disableTableEdit() {
        if cellStyleForEditing == .none {
            print("nothing to see here...")
        } else {
            cellStyleForEditing = .none
            editButton.setTitle("edit", for: .normal)
        }
        jobsTableView.setEditing(cellStyleForEditing != .none, animated: true)
    }
    
    func loadDefaultJobs() {
        
        // create array of default jobs and habits
        dailyJobs = [JobsAndHabits(jobName: "bedroom", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 1),
                     JobsAndHabits(jobName: "bathrooms", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 2),
                     JobsAndHabits(jobName: "laundry", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 3),
                     JobsAndHabits(jobName: "living room", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 4),
                     JobsAndHabits(jobName: "sweep & vacuum", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 5),
                     JobsAndHabits(jobName: "wipe table", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 6),
                     JobsAndHabits(jobName: "counters", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 7),
                     JobsAndHabits(jobName: "dishes", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 8),
                     JobsAndHabits(jobName: "meal prep", jobMultiplier: 1, jobClass: "dailyJob",jobOrder: 9 ),
                     JobsAndHabits(jobName: "feed pet / garbage", jobMultiplier: 1, jobClass: "dailyJob", jobOrder: 10)]
        weeklyJobs = [JobsAndHabits(jobName: "sweep porch", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 1),
                      JobsAndHabits(jobName: "weed garden", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 2),
                      JobsAndHabits(jobName: "wash windows", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 3),
                      JobsAndHabits(jobName: "dusting & cobwebs", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 4),
                      JobsAndHabits(jobName: "mop floors", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 5),
                      JobsAndHabits(jobName: "clean cabinets", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 6),
                      JobsAndHabits(jobName: "clean fridge", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 7),
                      JobsAndHabits(jobName: "wash car", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 8),
                      JobsAndHabits(jobName: "mow lawn", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 9),
                      JobsAndHabits(jobName: "babysit (per hour)", jobMultiplier: 1, jobClass: "weeklyJob", jobOrder: 10)]
        //        dailyHabits = [JobsAndHabits(jobName: "get ready for day by 10:am", jobMultiplier: 5, jobClass: "dailyHabit"),      // This is bonus habit **
        //                       JobsAndHabits(jobName: "personal meditation (10 min)", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "daily exercise", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "develop talents (20 min)", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "homework done by 5:pm", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "good manners", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "peacemaking (no fighting)", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "helping hands / obedience", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "write in journal", jobMultiplier: 1, jobClass: "dailyHabit"),
        //                       JobsAndHabits(jobName: "bed by 8:pm", jobMultiplier: 1, jobClass: "dailyHabit")]
        
    }
    
    @IBAction func questionButtonTapped(_ sender: UIButton) {
        disableTableEdit()
    }
    
    func addJobButtonTapped() {
        disableTableEdit()
        if dailyJobs.count >= 20 {
            addTooManyJobsAlert()
        } else {
            performSegue(withIdentifier: "AddJob", sender: self)
        }
    }
    
    
    // ----------------------------------------------------------
    // MARK: Dismiss keyboard if user taps outside of text fields
    // ----------------------------------------------------------
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        disableTableEdit()
        view.endEditing(true)
    }
    
    
    // ------
    // Alerts
    // ------
    
    func questionButtonAlert() {
        let alert = UIAlertController(title: "Daily Jobs", message: "Use this page to make a wish list of all the jobs that need to be done on a daily and weekly basis in your home. Select, add, or modify the existing default list to fit your family's needs. You can add up to 20 daily jobs and 20 weekly jobs.\n\nNOTE: each daily job will pay the same, and each weekly job will pay the same; so do your best to distribute the assignments equally.\n\nDo NOT include jobs that need to be done less frequently (do not include monthly or yearly jobs). Also, do NOT include daily habits. Daily habits will be reviewed in the upcoming screens.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletedTooManyRowsAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.jobsTableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTooManyJobsAlert() {
        let alert = UIAlertController(title: "Add Job", message: "You have reached your limit of 20 daily jobs. If you have more jobs to create, try combining multiple jobs into one.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}





