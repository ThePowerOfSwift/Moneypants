import UIKit
import FirebaseAuth
import FirebaseDatabase

class Step3VC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var questionButton: UIButton!
    
    var dailyJobs = [JobsAndHabits]()       // create variable called 'daily jobs' which is an array of type JobsAndHabits
    var weeklyJobs = [JobsAndHabits]()      // create variable called 'weekly jobs' which is an array of type JobsAndHabits
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("TESTING").child(firebaseUser.uid)
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        
        // Customize the question button
        questionButton.layer.cornerRadius = questionButton.bounds.height / 6.4
        questionButton.layer.masksToBounds = true
        
        // add + symbol in navbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addJobButtonTapped))
                
        loadDefaultJobsAndHabits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        jobsTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                if dailyJobs.count <= 10 {           // check to make sure user isn't deleting too many jobs
                    deletedTooManyRowsAlert()
                } else {
                    dailyJobs.remove(at: indexPath.row)
                    // MARK: Need to update Firebase here
                    jobsTableView.deleteRows(at: [indexPath], with: .fade)
                }
                
            } else {
                print("trying to delete weekly jobs, huh? No can do, senor!")
            }
        }
    }

    
    
    // ------------------
    // MARK: - Navigation
    // ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditJob" {
            let nextController = segue.destination as! Step3AddJobVC
            // 'sender' is retrieved from 'didSelectRow' function above
            print("sender is: \(sender!)")
            nextController.job = sender as! JobsAndHabits?
            nextController.navBarTitle = "edit job"
        } else if segue.identifier == "AddJob" {
            let nextController = segue.destination as! Step3AddJobVC
            nextController.navBarTitle = "add job"
            print("add job segue initiated")
        } else {
            print("another segue initiated")
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
            jobsTableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        
        // MARK: save to Firebase here
        print(dailyJobs, weeklyJobs)
        print("time to update Firebase with ", updatedJob!.name)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        for dailyJob in dailyJobs {
            ref.child("dailyJobs").child(dailyJob.name).setValue(["name" : dailyJob.name,
                                                                  "multiplier" : dailyJob.multiplier,
                                                                  "classification" : dailyJob.classification])
            ref.child("dailyJobs").updateChildValues(["count" : dailyJobs.count])            // return number of daily jobs
        }
        
        for weeklyJob in weeklyJobs {
            ref.child("weeklyJobs").child(weeklyJob.name).setValue(["name" : weeklyJob.name,
                                                                    "multiplier" : weeklyJob.multiplier,
                                                                    "classification" : weeklyJob.classification])
        }
        
        
        
        
        
        performSegue(withIdentifier: "AssignJobs", sender: self)
    }
    
    
    
    // ---------
    // Functions
    // ---------
    
//    func saveToFirebase(array: Array<Any>, value1: String, value2: Double, value3: String) {
//        ref.child("TESTING").child(firebaseUser.uid).childByAutoId().setValue([array.value1,
//                                                                                  array.value2,
//                                                                                  array.value3)]
//    }
    
    func addJobButtonTapped() {
        performSegue(withIdentifier: "AddJob", sender: self)
    }
    
    
    func loadDefaultJobsAndHabits() {
        
        // create array of default jobs and habits
        dailyJobs = [JobsAndHabits(jobName: "bedroom", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "bathrooms", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "laundry", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "living room", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "sweep & vacuum", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "wipe table", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "counters", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "dishes", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "meal prep", jobMultiplier: 1, jobClass: "dailyJob"),
                     JobsAndHabits(jobName: "feed pet / garbage", jobMultiplier: 1, jobClass: "dailyJob")]
        weeklyJobs = [JobsAndHabits(jobName: "sweep porch", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "weed garden", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "wash windows", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "dusting & cobwebs", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "mop floors", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "clean cabinets", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "clean fridge", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "wash car", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "mow lawn", jobMultiplier: 1, jobClass: "weeklyJob"),
                      JobsAndHabits(jobName: "babysit (per hour)", jobMultiplier: 1, jobClass: "weeklyJob")]
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
        questionButtonAlert()
    }
    
    func questionButtonAlert() {
        let alert = UIAlertController(title: "Daily & Weekly Jobs", message: "Make a wish list of all the jobs that need to be done on a daily and weekly basis in your home. Do NOT include jobs that need to be done less frequently (do not include monthly or yearly jobs). Also, do NOT include daily habits. Those will be reviewed in the upcoming screens.\n\nDefault jobs are already listed, but you can change them to fit your family's needs. You can have up to 20 daily jobs and 10 weekly jobs. You cannot change the number of weekly jobs.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deletedTooManyRowsAlert() {
        let alert = UIAlertController(title: "Daily Jobs", message: "You cannot delete this daily job. You must have at least 10 daily jobs in your list.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.jobsTableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}





