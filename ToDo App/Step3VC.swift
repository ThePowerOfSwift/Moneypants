import UIKit
import Firebase

class Step3VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var dailyJobs: [JobsAndHabits]!       // create variable called 'daily jobs' which is an array of type JobsAndHabits
    var weeklyJobs: [JobsAndHabits]!      // create variable called 'weekly jobs' which is an array of type JobsAndHabits
    var dailyJobMin = 6
    let dailyJobMax = 20
    var weeklyJobMin = 6
    let weeklyJobMax = 20
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    var flag: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dailyJobs = [JobsAndHabits]()
        weeklyJobs = [JobsAndHabits]()

        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        getUserCountAndUpdateJobMinMax { (userCount) in
            self.dailyJobMin = userCount + 1
            self.weeklyJobMin = userCount + 1
            print("dailyMin",self.dailyJobMin)
            print("weeklyMin",self.weeklyJobMin)
        }
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        
        // Customize the question button
        questionButton.layer.cornerRadius = questionButton.bounds.height / 6.4
        questionButton.layer.masksToBounds = true
        
        // add + symbol in navbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJobButtonTapped))
        
        // MARK: need to load Firebase Data if it exists, then if not, load default jobs
        checkForFirebaseJobs { (answer) in
            if answer == true {
                self.loadFirebaseJobs()
                self.jobsTableView.reloadData()
            } else {
                self.loadDefaultJobs()
                self.createDefaultJobsOnFirebase()
                self.jobsTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        jobsTableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ref.child("dailyJobs").removeAllObservers()
        ref.child("weeklyJobs").removeAllObservers()
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
//            cell.backgroundColor = UIColor.white
        } else {
            cell.jobLabel.text = weeklyJobs[indexPath.row].name
//            cell.backgroundColor = UIColor.white
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
            
            // ----------
            // daily jobs
            // ----------
            
            let job = dailyJobs[sourceIndexPath.row]
            dailyJobs.remove(at: sourceIndexPath.row)
            dailyJobs.insert(job, at: destinationIndexPath.row)
            
            // MARK: TODO - need to update all jobs with new order
            // find job name at the tableview's index path, then update its job order to match the tableview's order (using tableview's index path)
            var jobOrder = 0
            for job in dailyJobs {
                changeJobOrderOnFirebase(dailyOrWeekly: "dailyJobs", jobName: job.name, newJobOrder: jobOrder, completion: {(snapshot) in
                })
                jobOrder += 1
            }
        } else {
            
            // -----------
            // weekly jobs
            // -----------
            
            let job = weeklyJobs[sourceIndexPath.row]
            weeklyJobs.remove(at: sourceIndexPath.row)
            weeklyJobs.insert(job, at: destinationIndexPath.row)
            var jobOrder = 0
            for job in weeklyJobs {
                changeJobOrderOnFirebase(dailyOrWeekly: "weeklyJobs", jobName: job.name, newJobOrder: jobOrder, completion: {(snapshot) in
                })
                jobOrder += 1
            }
        }
    }
    
    // don't allow rows to cross sections
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(jobsTableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    // allow deletion of rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                if dailyJobs.count <= dailyJobMin {           // check to make sure user isn't deleting too many jobs
                    deletedTooManyRowsAlert(alertTitle: "Daily Jobs", alertMessage: "You cannot delete this daily job. You must have at least \(dailyJobMin) daily jobs in your list.")
                } else {
                    
                    // need to find order of job at the index path and delete it.
                    ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                        snapshot.ref.removeValue()
                    })
                    
                    dailyJobs.remove(at: indexPath.row)
                    jobsTableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    
                    // MARK: TODO - need to reassign order
                    
                    var jobOrder = 0        // iterate over jobs in tableview, starting with first
                    for job in dailyJobs {
                        changeJobOrderOnFirebase(dailyOrWeekly: "dailyJobs", jobName: job.name, newJobOrder: jobOrder, completion: {(snapshot) in
                        })
                        jobOrder += 1
                    }
                }
            } else {
                if weeklyJobs.count <= weeklyJobMin {
                    deletedTooManyRowsAlert(alertTitle: "Weekly Jobs", alertMessage: "You cannot delete this weekly job. You must have at least \(weeklyJobMin) weekly jobs in your list.")
                } else {
                    
                    ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                        snapshot.ref.removeValue()
                    })
                    
                    weeklyJobs.remove(at: indexPath.row)
                    jobsTableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    
                    var jobOrder = 0        // iterate over jobs in tableview, starting with first
                    for job in weeklyJobs {
                        changeJobOrderOnFirebase(dailyOrWeekly: "weeklyJobs", jobName: job.name, newJobOrder: jobOrder, completion: {(snapshot) in
                        })
                        jobOrder += 1
                    }
                }
            }
        }
    }
    
    
    // ------------------
    // MARK: - Navigation
    // ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Edit Jobs
        if segue.identifier == "EditJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.dailyJobs = dailyJobs
            // 'sender' is retrieved from 'didSelectRow' function above
            nextController.job = sender as! JobsAndHabits?
            nextController.navBarTitle = "edit job"
            
        // Add Jobs
        } else if segue.identifier == "AddDailyJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.dailyJobs = dailyJobs
            nextController.navBarTitle = "add daily job"
            nextController.jobSection = 0
        } else if segue.identifier == "AddWeeklyJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.weeklyJobs = weeklyJobs
            nextController.navBarTitle = "add weekly job"
            nextController.jobSection = 1
        } else {
//            print("segue initiated")
        }
    }
    
    @IBAction func unwindToStep3VC(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as! Step3AddJobVC
        let updatedJob = sourceVC.job
        if let selectedIndexPathSection = jobsTableView.indexPathForSelectedRow?.section {      // if tableview cell was selected to begin with
            
            // --------------------
            // Update existing jobs
            // --------------------
            
            // update daily job
            if selectedIndexPathSection == 0 {
                let selectedIndexPathRow = jobsTableView.indexPathForSelectedRow
                dailyJobs[selectedIndexPathRow!.row] = updatedJob!
                
                // MARK: TODO - update daily job name on Firebase (find job with the selected index, and update the name for it)
                ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: selectedIndexPathRow?.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["name" : updatedJob!.name])
                })
                jobsTableView.reloadData()
                
            // update weekly job
            } else if selectedIndexPathSection == 1 {
                let selectedIndexPathRow = jobsTableView.indexPathForSelectedRow
                weeklyJobs[(selectedIndexPathRow?.row)!] = updatedJob!
                
                // MARK: TODO - update weekly job name on Firebase (find job with the selected index, and update the name for it)
                ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: selectedIndexPathRow?.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["name" : updatedJob!.name])
                })
                jobsTableView.reloadData()
            }
        } else {
            
            // ---------------
            // Create new jobs
            // ---------------
            
            // new daily jobs
            if sourceVC.jobSection == 0 {
                
                // MARK: TODO - create a new daily job in Firebase
                ref.child("dailyJobs").childByAutoId().setValue(["name" : updatedJob!.name,
                                                                 "multiplier" : 10 / Double(dailyJobs.count),       // MARK: TODO - need to get rid of 'multiplier' variable and replace
                                                                 "assigned" : "none",
                                                                 "order" : dailyJobs.count])
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
                
            // new weekly jobs
            } else if sourceVC.jobSection == 1 {
                
                // create a new weekly job in Firebase
                ref.child("weeklyJobs").childByAutoId().setValue(["name" : updatedJob!.name,
                                                                  "multiplier" : 10 / Double(weeklyJobs.count),
                                                                  "assigned" : "none",
                                                                  "order" : weeklyJobs.count])
                // Add a new weekly job in the weekly jobs array
                let newIndexPath = IndexPath(row: weeklyJobs.count, section: 1)
                weeklyJobs.append(updatedJob!)
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
            }
            
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
        performSegue(withIdentifier: "AssignJobs", sender: self)
    }
    
    @IBAction func questionButtonTapped(_ sender: UIButton) {
        // NOTE: Action on this button tap is handled in IB
        disableTableEdit()
    }
    
    func addJobButtonTapped() {
        disableTableEdit()
        chooseDailyOrWeeklyJob()
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func getUserCountAndUpdateJobMinMax(completion: @escaping (Int) -> ()) {
        ref.child("members").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            completion(Int(snapshot.childrenCount))
        }
    }
    
    func changeJobOrderOnFirebase(dailyOrWeekly: String, jobName: String, newJobOrder: Int, completion: @escaping (FIRDataSnapshot) -> ()) {
        ref.child(dailyOrWeekly).queryOrdered(byChild: "name").queryEqual(toValue: jobName).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            snapshot.ref.updateChildValues(["order" : newJobOrder])
            completion(snapshot)
        })
    }
    
    func checkForFirebaseJobs(completion: @escaping (Bool!) -> ()) {
        ref.child("dailyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            completion(snapshot.hasChildren())
        }
    }       // NOTE: no need to check for weekly jobs (if there are daily jobs, there will be weekly jobs, and vice versa)
    
    func loadFirebaseJobs() {
        ref.child("dailyJobs").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let multiplier = dictionary["multiplier"] as! Double
                let name = dictionary["name"] as! String
                let assigned = dictionary["assigned"] as! String
                let order = dictionary["order"] as! Int
                
                let dailyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
                self.dailyJobs.append(dailyJob)
                self.dailyJobs.sort(by: {$0.order < $1.order})
                
                self.jobsTableView.reloadData()
            }
        })
        
        ref.child("weeklyJobs").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                let multiplier = dictionary["multiplier"] as! Double
                let name = dictionary["name"] as! String
                let assigned = dictionary["assigned"] as! String
                let order = dictionary["order"] as! Int
                
                let weeklyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
                self.weeklyJobs.append(weeklyJob)
                self.weeklyJobs.sort(by: {$0.order < $1.order})
                
                self.jobsTableView.reloadData()
            }
        })
    }
    
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
//            print("nothing to see here...")
        } else {
            cellStyleForEditing = .none
            editButton.setTitle("edit", for: .normal)
        }
        jobsTableView.setEditing(cellStyleForEditing != .none, animated: true)
    }
    
    func loadDefaultJobs() {
        // create array of default daily jobs
        dailyJobs = [JobsAndHabits(jobName: "bedroom", jobMultiplier: 1, jobAssign: "none", jobOrder: 1),
                     JobsAndHabits(jobName: "bathrooms", jobMultiplier: 1, jobAssign: "none", jobOrder: 2),
                     JobsAndHabits(jobName: "laundry", jobMultiplier: 1, jobAssign: "none", jobOrder: 3),
                     JobsAndHabits(jobName: "living room", jobMultiplier: 1, jobAssign: "none", jobOrder: 4),
                     JobsAndHabits(jobName: "sweep & vacuum", jobMultiplier: 1, jobAssign: "none", jobOrder: 5),
                     JobsAndHabits(jobName: "wipe table", jobMultiplier: 1, jobAssign: "none", jobOrder: 6),
                     JobsAndHabits(jobName: "counters", jobMultiplier: 1, jobAssign: "none", jobOrder: 7),
                     JobsAndHabits(jobName: "dishes", jobMultiplier: 1, jobAssign: "none", jobOrder: 8),
                     JobsAndHabits(jobName: "meal prep", jobMultiplier: 1, jobAssign: "none",jobOrder: 9 ),
                     JobsAndHabits(jobName: "feed pet / garbage", jobMultiplier: 1, jobAssign: "none", jobOrder: 10)]
        
        // create array of default weekly jobs
        weeklyJobs = [JobsAndHabits(jobName: "sweep porch", jobMultiplier: 1, jobAssign: "none", jobOrder: 1),
                      JobsAndHabits(jobName: "weed garden", jobMultiplier: 1, jobAssign: "none", jobOrder: 2),
                      JobsAndHabits(jobName: "wash windows", jobMultiplier: 1, jobAssign: "none", jobOrder: 3),
                      JobsAndHabits(jobName: "dusting & cobwebs", jobMultiplier: 1, jobAssign: "none", jobOrder: 4),
                      JobsAndHabits(jobName: "mop floors", jobMultiplier: 1, jobAssign: "none", jobOrder: 5),
                      JobsAndHabits(jobName: "clean cabinets", jobMultiplier: 1, jobAssign: "none", jobOrder: 6),
                      JobsAndHabits(jobName: "clean fridge", jobMultiplier: 1, jobAssign: "none", jobOrder: 7),
                      JobsAndHabits(jobName: "wash car", jobMultiplier: 1, jobAssign: "none", jobOrder: 8),
                      JobsAndHabits(jobName: "mow lawn", jobMultiplier: 1, jobAssign: "none", jobOrder: 9),
                      JobsAndHabits(jobName: "babysit (hour #1)", jobMultiplier: 1, jobAssign: "none", jobOrder: 10)]
    }
    
    func createDefaultJobsOnFirebase() {
        var dailyCounter = 0
        var weeklyCounter = 0
        for dailyJob in dailyJobs {
            ref.child("dailyJobs").childByAutoId().setValue(["name" : dailyJob.name,
                                                             "multiplier" : 1,
                                                             "assigned" : "none",
                                                             "order" : dailyCounter])
            dailyCounter += 1
        }
        for weeklyJob in weeklyJobs {
            ref.child("weeklyJobs").childByAutoId().setValue(["name" : weeklyJob.name,
                                                              "multiplier" : 1,
                                                              "assigned" : "none",
                                                              "order" : weeklyCounter])
            weeklyCounter += 1
        }
    }
    
    /*
    func loadDefaultDailyHabits() {
        // create array of default daily habits
        dailyHabits = [JobsAndHabits(jobName: "get ready for day by 10:am", jobMultiplier: 5, jobAssign: "none", jobOrder: 1),     // This is bonus habit **
            JobsAndHabits(jobName: "personal meditation (10 min)", jobMultiplier: 1, jobAssign: "none", jobOrder: 2),
            JobsAndHabits(jobName: "daily exercise", jobMultiplier: 1, jobAssign: "none", jobOrder: 3),
            JobsAndHabits(jobName: "develop talents (20 min)", jobMultiplier: 1, jobAssign: "none", jobOrder: 4),
            JobsAndHabits(jobName: "homework done by 5:pm", jobMultiplier: 1, jobAssign: "none", jobOrder: 5),
            JobsAndHabits(jobName: "good manners", jobMultiplier: 1, jobAssign: "none", jobOrder: 6),
            JobsAndHabits(jobName: "peacemaking (no fighting)", jobMultiplier: 1, jobAssign: "none", jobOrder: 7),
            JobsAndHabits(jobName: "helping hands / obedience", jobMultiplier: 1, jobAssign: "none", jobOrder: 8),
            JobsAndHabits(jobName: "write in journal", jobMultiplier: 1, jobAssign: "none", jobOrder: 9),
            JobsAndHabits(jobName: "bed by 8:pm", jobMultiplier: 1, jobAssign: "none", jobOrder: 10)]
    }
    */
    
    // Dismiss keyboard if user taps outside of text fields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        disableTableEdit()
        view.endEditing(true)
    }
    
    
    // ------
    // Alerts
    // ------
    
    func chooseDailyOrWeeklyJob() {
        let alert = UIAlertController(title: "Add Job", message: "You have selected 'add a new job'. Would you like to add a daily job or a weekly job?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "add daily job", style: .default, handler: { (action) in
            
            // check to make sure user isn't adding more than 20 jobs
            if self.dailyJobs.count >= 20 {
                self.addTooManyJobsAlert(alertMessage: "You have reached your limit of 20 daily jobs. If you have more jobs to create, try combining multiple jobs into one.")
            } else {
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "AddDailyJob", sender: self)
            }
        }))
        alert.addAction(UIAlertAction(title: "add weekly job", style: .default, handler: { (action) in
            
            // check to make sure user isn't adding more than 20 jobs
            if self.weeklyJobs.count >= 20 {
                self.addTooManyJobsAlert(alertMessage: "You have reached your limit of 20 weekly jobs. If you have more jobs to create, try combining multiple jobs into one.")
            } else {
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "AddWeeklyJob", sender: self)
            }
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    func deletedTooManyRowsAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.jobsTableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTooManyJobsAlert(alertMessage: String) {
        let alert = UIAlertController(title: "Add Job", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        // MARK: TODO - Remove observers from 'getDailyJobs', 'loadFirebaseDailyJobs', 'getWeeklyJobs', and 'loadFirebaseWeeklyJobs' functions
        ref.child("dailyJobs").removeAllObservers()
        ref.child("weeklyJobs").removeAllObservers()
    }
}





