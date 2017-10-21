import UIKit
import Firebase

class Step3VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var jobCountMin = User.usersArray.count           // there must be at least one daily job and one weekly job per user
    let jobCountMax = 20
    
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

        fetchJobs()
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
            return JobsAndHabits.finalDailyJobsArray.count
        } else {
            return JobsAndHabits.finalWeeklyJobsArray.count
        }
    }
    
    // populate rows with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = jobsTableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step3CustomCell
        if indexPath.section == 0 {
            cell.jobLabel.text = JobsAndHabits.finalDailyJobsArray[indexPath.row].name
//            cell.backgroundColor = UIColor.white
        } else {
            cell.jobLabel.text = JobsAndHabits.finalWeeklyJobsArray[indexPath.row].name
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
            performSegue(withIdentifier: "EditJob", sender: JobsAndHabits.finalDailyJobsArray[indexPath.row])
        } else {
            performSegue(withIdentifier: "EditJob", sender: JobsAndHabits.finalWeeklyJobsArray[indexPath.row])
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
            
            let job = JobsAndHabits.finalDailyJobsArray[sourceIndexPath.row]
            JobsAndHabits.finalDailyJobsArray.remove(at: sourceIndexPath.row)
            JobsAndHabits.finalDailyJobsArray.insert(job, at: destinationIndexPath.row)
            
            // MARK: TODO - need to update all jobs with new order
            // find job name at the tableview's index path, then update its job order to match the tableview's order (using tableview's index path)
            var jobOrder = 0
            for job in JobsAndHabits.finalDailyJobsArray {
                changeJobOrderOnFirebase(dailyOrWeekly: "dailyJobs", jobName: job.name, newJobOrder: jobOrder, completion: {(snapshot) in
                })
                jobOrder += 1
            }
        } else {
            
            // -----------
            // weekly jobs
            // -----------
            
            let job = JobsAndHabits.finalWeeklyJobsArray[sourceIndexPath.row]
            JobsAndHabits.finalWeeklyJobsArray.remove(at: sourceIndexPath.row)
            JobsAndHabits.finalWeeklyJobsArray.insert(job, at: destinationIndexPath.row)
            var jobOrder = 0
            for job in JobsAndHabits.finalWeeklyJobsArray {
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
                if JobsAndHabits.finalDailyJobsArray.count <= jobCountMin {           // check to make sure user isn't deleting too many jobs
                    deletedTooManyRowsAlert(alertTitle: "Daily Jobs", alertMessage: "You cannot delete this daily job. You must have at least \(jobCountMin) daily jobs in your list (one for each family member.)")
                } else {
                    
                    // need to find order of job at the index path and delete it.
                    ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                        snapshot.ref.removeValue()
                    })
                    
                    JobsAndHabits.finalDailyJobsArray.remove(at: indexPath.row)
                    jobsTableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    
                    // MARK: TODO - need to reassign order
                    
                    var jobOrder = 0        // iterate over jobs in tableview, starting with first
                    for job in JobsAndHabits.finalDailyJobsArray {
                        changeJobOrderOnFirebase(dailyOrWeekly: "dailyJobs", jobName: job.name, newJobOrder: jobOrder, completion: {(snapshot) in
                        })
                        jobOrder += 1
                    }
                }
            } else {
                if JobsAndHabits.finalWeeklyJobsArray.count <= jobCountMin {
                    deletedTooManyRowsAlert(alertTitle: "Weekly Jobs", alertMessage: "You cannot delete this weekly job. You must have at least \(jobCountMin) weekly jobs in your list (one for each family member.)")
                } else {
                    
                    ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                        snapshot.ref.removeValue()
                    })
                    
                    JobsAndHabits.finalWeeklyJobsArray.remove(at: indexPath.row)
                    jobsTableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                    
                    var jobOrder = 0        // iterate over jobs in tableview, starting with first
                    for job in JobsAndHabits.finalWeeklyJobsArray {
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
            // 'sender' is retrieved from 'didSelectRow' function above
            nextController.job = sender as! JobsAndHabits?
            // check if sender is from 'daily jobs', and if so, send 'daily job' info to next VC
            if JobsAndHabits.finalDailyJobsArray.contains(where: { $0.name == nextController.job?.name }) {
                nextController.navBarTitle = "edit daily job"
                nextController.jobSection = 0
                nextController.descriptionBodyText1 = "NOTE: as a rule of thumb, daily jobs should take between 10 and 30 minutes for an adult to complete."
                nextController.descriptionBodyText2 = "If a job takes less than 10 minutes, combine it with another job."
                nextController.descriptionBodyText3 = "If a job takes longer than 30 minutes, split it into multiple jobs."
            } else {
                nextController.navBarTitle = "edit weekly job"
                nextController.jobSection = 1
                nextController.descriptionBodyText1 = "NOTE: as a rule of thumb, weekly jobs should take between 30 and 60 minutes for an adult to complete."
                nextController.descriptionBodyText2 = "If a job takes less than 30 minutes, combine it with another job."
                nextController.descriptionBodyText3 = "If a job takes longer than 60 minutes, split it into multiple jobs."
            }
        // Add Jobs
        } else if segue.identifier == "AddDailyJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.navBarTitle = "add daily job"
            nextController.jobSection = 0
            nextController.descriptionBodyText1 = "NOTE: as a rule of thumb, daily jobs should take between 10 and 30 minutes for an adult to complete."
            nextController.descriptionBodyText2 = "If a job takes less than 10 minutes, combine it with another job."
            nextController.descriptionBodyText3 = "If a job takes longer than 30 minutes, split it into multiple jobs."
        } else if segue.identifier == "AddWeeklyJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.navBarTitle = "add weekly job"
            nextController.jobSection = 1
            nextController.descriptionBodyText1 = "NOTE: as a rule of thumb, weekly jobs should take between 30 and 60 minutes for an adult to complete."
            nextController.descriptionBodyText2 = "If a job takes less than 30 minutes, combine it with another job."
            nextController.descriptionBodyText3 = "If a job takes longer than 60 minutes, split it into multiple jobs."
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
                JobsAndHabits.finalDailyJobsArray[selectedIndexPathRow!.row] = updatedJob!
                
                // MARK: TODO - update daily job name on Firebase (find job with the selected index, and update the name for it)
                ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: selectedIndexPathRow?.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["name" : updatedJob!.name])
                })
                jobsTableView.reloadData()
                
            // update weekly job
            } else if selectedIndexPathSection == 1 {
                let selectedIndexPathRow = jobsTableView.indexPathForSelectedRow
                JobsAndHabits.finalWeeklyJobsArray[(selectedIndexPathRow?.row)!] = updatedJob!
                
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
                                                                 "description" : "job description",
                                                                 "assigned" : "none",
                                                                 "order" : JobsAndHabits.finalDailyJobsArray.count])
                // Add a new daily job in the daily jobs array
                let newIndexPath = IndexPath(row: JobsAndHabits.finalDailyJobsArray.count, section: 0)
                JobsAndHabits.finalDailyJobsArray.append(updatedJob!)
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
                                                                  "description" : "job description",
                                                                  "assigned" : "none",
                                                                  "order" : JobsAndHabits.finalWeeklyJobsArray.count])
                // Add a new weekly job in the weekly jobs array
                let newIndexPath = IndexPath(row: JobsAndHabits.finalWeeklyJobsArray.count, section: 1)
                JobsAndHabits.finalWeeklyJobsArray.append(updatedJob!)
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
        if FamilyData.setupProgress <= 30 {
            FamilyData.setupProgress = 30
            ref.updateChildValues(["setupProgress" : 30])      // setupProgress: each step is an increment of 10, with each substep being a single digit, so step 4 would be 40
        }
        disableTableEdit()
        performSegue(withIdentifier: "AssignJobs", sender: self)
    }
    
    @IBAction func questionButtonTapped(_ sender: UIButton) {
        // NOTE: Action on this button tap is handled in IB
        disableTableEdit()
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

    func addJobButtonTapped() {
        disableTableEdit()
        chooseDailyOrWeeklyJob()
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func fetchJobs() {
        // ----------
        // daily jobs
        // ----------
        
        // if there are no existing jobs on Firebase, then load the defaults
        if JobsAndHabits.finalDailyJobsArray.count == 0 {
            loadDefaultDailyJobs()
            createDefaultDailyJobsOnFirebase()
            
        // if there are existing jobs on Firebase but not enough for each family member, then create a few more jobs
        } else if JobsAndHabits.finalDailyJobsArray.count < self.jobCountMin {
            let jobMinimumConflict = self.jobCountMin - JobsAndHabits.finalDailyJobsArray.count
            var numberForNewJobName = 0
            for _ in 1...jobMinimumConflict {
                
                // check for duplicate names
                numberForNewJobName += 1
                var newDailyJobName = "custom daily job \(numberForNewJobName)"
                for item in JobsAndHabits.finalDailyJobsArray {
                    if item.name == newDailyJobName {
                        numberForNewJobName += 1
                        newDailyJobName = "custom daily job \(numberForNewJobName)"
                    }
                }
                
                let dailyJob = JobsAndHabits(name: newDailyJobName, description: "job description", assigned: "none", order: JobsAndHabits.finalDailyJobsArray.count)
                JobsAndHabits.finalDailyJobsArray.append(dailyJob)
                self.jobsTableView.reloadData()
                // append new jobs to Firebase
                self.ref.child("dailyJobs").childByAutoId().setValue(["name" : newDailyJobName, "description" : "job description", "assigned" : "none", "order" : JobsAndHabits.finalDailyJobsArray.count - 1])
            }
        }
        
        // -----------
        // weekly jobs
        // -----------
        
        if JobsAndHabits.finalWeeklyJobsArray.count == 0 {
            self.loadDefaultWeeklyJobs()
            self.createDefaultWeeklyJobsOnFirebase()
        } else if JobsAndHabits.finalWeeklyJobsArray.count < self.jobCountMin {
            let jobMinimumConflict = self.jobCountMin - JobsAndHabits.finalWeeklyJobsArray.count
            var numberForNewJobName = 0
            for _ in 1...jobMinimumConflict {
                
                // check for duplicate names
                numberForNewJobName += 1
                var newWeeklyJobName = "custom weekly job \(numberForNewJobName)"
                for item in JobsAndHabits.finalWeeklyJobsArray {
                    if item.name == newWeeklyJobName {
                        numberForNewJobName += 1
                        newWeeklyJobName = "custom weekly job \(numberForNewJobName)"
                    }
                }
                
                let weeklyJob = JobsAndHabits(name: newWeeklyJobName, description: "job description", assigned: "none", order: JobsAndHabits.finalWeeklyJobsArray.count)
                JobsAndHabits.finalWeeklyJobsArray.append(weeklyJob)
                self.jobsTableView.reloadData()
                // append new jobs to Firebase
                self.ref.child("weeklyJobs").childByAutoId().setValue(["name" : newWeeklyJobName, "description" : "job description", "assigned" : "none", "order" : JobsAndHabits.finalWeeklyJobsArray.count - 1])
            }
        }
    }
    
    func loadDefaultDailyJobs() {
        // create array of default daily jobs
        JobsAndHabits.finalDailyJobsArray = [JobsAndHabits(name: "bedroom", description: "job description", assigned: "none", order: 1),
                                             JobsAndHabits(name: "bathrooms", description: "job description", assigned: "none", order: 2),
                                             JobsAndHabits(name: "laundry", description: "job description", assigned: "none", order: 3),
                                             JobsAndHabits(name: "living room", description: "job description", assigned: "none", order: 4),
                                             JobsAndHabits(name: "sweep & vacuum", description: "job description", assigned: "none", order: 5),
                                             JobsAndHabits(name: "wipe table", description: "job description", assigned: "none", order: 6),
                                             JobsAndHabits(name: "counters", description: "job description", assigned: "none", order: 7),
                                             JobsAndHabits(name: "dishes", description: "job description", assigned: "none", order: 8),
                                             JobsAndHabits(name: "meal prep", description: "job description", assigned: "none",order: 9 ),
                                             JobsAndHabits(name: "feed pet / garbage", description: "job description", assigned: "none", order: 10)]
        jobsTableView.reloadData()
    }
    
    func loadDefaultWeeklyJobs() {
        // create array of default weekly jobs
        JobsAndHabits.finalWeeklyJobsArray = [JobsAndHabits(name: "sweep porch", description: "job description", assigned: "none", order: 1),
                                              JobsAndHabits(name: "weed garden", description: "job description", assigned: "none", order: 2),
                                              JobsAndHabits(name: "wash windows", description: "job description", assigned: "none", order: 3),
                                              JobsAndHabits(name: "dusting & cobwebs", description: "job description", assigned: "none", order: 4),
                                              JobsAndHabits(name: "mop floors", description: "job description", assigned: "none", order: 5),
                                              JobsAndHabits(name: "clean cabinets", description: "job description", assigned: "none", order: 6),
                                              JobsAndHabits(name: "clean fridge", description: "job description", assigned: "none", order: 7),
                                              JobsAndHabits(name: "wash car", description: "job description", assigned: "none", order: 8),
                                              JobsAndHabits(name: "mow lawn", description: "job description", assigned: "none", order: 9),
                                              JobsAndHabits(name: "babysit (hour #1)", description: "job description", assigned: "none", order: 10)]
        jobsTableView.reloadData()
    }
    
    func createDefaultDailyJobsOnFirebase() {
        var dailyCounter = 0
        for dailyJob in JobsAndHabits.finalDailyJobsArray {
            ref.child("dailyJobs").childByAutoId().setValue(["name" : dailyJob.name,
                                                             "description" : "job description",
                                                             "assigned" : "none",
                                                             "order" : dailyCounter])
            dailyCounter += 1
        }
    }
    
    func createDefaultWeeklyJobsOnFirebase() {
        var weeklyCounter = 0
        for weeklyJob in JobsAndHabits.finalWeeklyJobsArray {
            ref.child("weeklyJobs").childByAutoId().setValue(["name" : weeklyJob.name,
                                                              "description" : "job description",
                                                              "assigned" : "none",
                                                              "order" : weeklyCounter])
            weeklyCounter += 1
        }
    }
    
    func changeJobOrderOnFirebase(dailyOrWeekly: String, jobName: String, newJobOrder: Int, completion: @escaping (FIRDataSnapshot) -> ()) {
        ref.child(dailyOrWeekly).queryOrdered(byChild: "name").queryEqual(toValue: jobName).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            snapshot.ref.updateChildValues(["order" : newJobOrder])
            completion(snapshot)
        })
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
            if JobsAndHabits.finalDailyJobsArray.count >= self.jobCountMax {
                self.addTooManyJobsAlert(alertMessage: "You have reached your limit of \(self.jobCountMax) daily jobs. If you have more jobs to create, try combining multiple jobs into one.")
            } else {
                alert.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: "AddDailyJob", sender: self)
            }
        }))
        alert.addAction(UIAlertAction(title: "add weekly job", style: .default, handler: { (action) in
            
            // check to make sure user isn't adding more than 20 jobs
            if JobsAndHabits.finalWeeklyJobsArray.count >= self.jobCountMax {
                self.addTooManyJobsAlert(alertMessage: "You have reached your limit of \(self.jobCountMax) weekly jobs. If you have more jobs to create, try combining multiple jobs into one.")
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
        ref.child("dailyJobs").removeAllObservers()
        ref.child("weeklyJobs").removeAllObservers()
    }
    
    
    // -----------
    // Unused Code
    // -----------
    
    // OLD BUT GOOD ESCAPING CODE
    /*
    func loadExistingJobsFromFirebase(completion: @escaping () -> ()) {
        
        // ----------
        // Daily Jobs
        // ----------
        
        ref.child("dailyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let multiplier = value["multiplier"] as! Double
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let dailyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
                        JobsAndHabits.finalDailyJobsArray.append(dailyJob)
                        JobsAndHabits.finalDailyJobsArray.sort(by: {$0.order < $1.order})
                        
                        self.jobsTableView.reloadData()
                    }
                }
            }
            
            // -----------
            // Weekly Jobs
            // -----------
            
            self.ref.child("weeklyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                for item in snapshot.children {
                    if let snap = item as? FIRDataSnapshot {
                        if let value = snap.value as? [String : Any] {
                            let multiplier = value["multiplier"] as! Double
                            let name = value["name"] as! String
                            let assigned = value["assigned"] as! String
                            let order = value["order"] as! Int
                            
                            let weeklyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
                            JobsAndHabits.finalWeeklyJobsArray.append(weeklyJob)
                            JobsAndHabits.finalWeeklyJobsArray.sort(by: {$0.order < $1.order})
                            
                            self.jobsTableView.reloadData()
                        }
                    }
                }
                
                // --------------
                // Family Members
                // --------------
                
                self.ref.child("members").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                    self.jobCountMin = Int(snapshot.childrenCount)
                    completion()
                }
            }
        }
    }
     */
    // END OLD BUT GOOD CODE

}





