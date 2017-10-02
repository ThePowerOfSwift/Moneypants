import UIKit
import Firebase

class Step4VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    var users = [User]()        // create new instance of 'users' using Firebase to populate (not bringing it from prev VCs)
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var dailyJobs = [JobsAndHabits]()
    var weeklyJobs = [JobsAndHabits]()
    var selectedJobs = [IndexPath]()       // for storing user selected cells
    var maxDailyNumber = 3                  // max number of daily chores allowed
    var maxWeeklyNumber = 2
    
    var user: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        jobsTableView.tableFooterView = UIView()
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        performSegue(withIdentifier: "ExplainerPopup", sender: self)
        self.automaticallyAdjustsScrollViewInsets = false
        
        getDailyJobs { (dictionary) in
            for item in dictionary {
                let name = item["name"] as! String
                let multiplier = item["multiplier"] as! Double
                let assigned = item["assigned"] as! String
                let order = item["order"] as! Int
                
                let dailyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
                self.dailyJobs.append(dailyJob)
                self.dailyJobs.sort(by: {$0.order < $1.order})
            }
            self.jobsTableView.reloadData()
        }
        
        getWeeklyJobs { (dictionary) in
            for item in dictionary {
                let name = item["name"] as! String
                let multiplier = item["multiplier"] as! Double
                let assigned = item["assigned"] as! String
                let order = item["order"] as! Int
                
                let weeklyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
                self.weeklyJobs.append(weeklyJob)
                self.weeklyJobs.sort(by: {$0.order < $1.order})
            }
            self.jobsTableView.reloadData()
        }
        
        getNextYoungestUserWithoutJobAssigned()
        
        user = "Sophie"
    }
    
    // Need to get youngest user who doesn't have any jobs assigned
    // need to get their name, gender, and profile pict
    func getNextYoungestUserWithoutJobAssigned() {
        // count number of jobs with
        
    }
    
    
   
    // ============================================================================
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print("next button tapped")
        
        // Need to validate if user has less than 2 daily jobs:
        // "You have not chosen enough jobs for Savannah. She should have at least one job in addition to clean bedroom. Are you sure you want to only assign Savannah one job?"
        
        // if user has less zero weekly jobs:
        // "You have not chosen any jobs for Savannah. Are you sure you don't want to assign her a weekly job?"
        
        // Need to remove all observers before proceeding to next VC
//        ref.child("dailyJobs").removeAllObservers()
//        ref.child("weeklyJobs").removeAllObservers()
    }
    
    
    // ----------------
    // Setup Table View
    // ----------------
    
    //set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyJobs.count
        } else {
            return weeklyJobs.count
        }
    }
    
    //Give each table section a title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily jobs"
        } else {
            return "weekly jobs"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    
    // what are the contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Step4CustomCell", for: indexPath) as! Step4CustomCell
        
        // ----------
        // DAILY JOBS
        // ----------
        
        if indexPath.section == 0 {
            cell.jobLabel.text = dailyJobs[indexPath.row].name
            
            if (selectedJobs.contains(indexPath)) {
                cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                cell.jobLabel.textColor = UIColor(white: 0.0, alpha: 1.0)
                // ... otherwise, check to see if job is already assigned. If so, show the light gray checkmark...
            } else if (dailyJobs[indexPath.row].assigned != "none") {
                cell.selectionBoxImageView.image = UIImage(named: "checkmark gray")
                cell.jobLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
                //... otherwise, the default is the regular black blank box
            } else {
                cell.selectionBoxImageView.image = UIImage(named: "blank")
                cell.jobLabel.textColor = UIColor(white: 0.0, alpha: 1.0)
            }
        } else {
            
            // -----------
            // WEEKLY JOBS
            // -----------
            
            cell.jobLabel.text = weeklyJobs[indexPath.row].name
            
            if (selectedJobs.contains(indexPath)) {
                cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
                cell.jobLabel.textColor = UIColor(white: 0.0, alpha: 1.0)
            } else if (weeklyJobs[indexPath.row].assigned != "none") {
                cell.selectionBoxImageView.image = UIImage(named: "checkmark gray")
                cell.jobLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
                //... otherwise, the default is the regular black blank box
            } else {
                cell.selectionBoxImageView.image = UIImage(named: "blank")
                cell.jobLabel.textColor = UIColor(white: 0.0, alpha: 1.0)
            }
        }
        return cell
    }
    
    // determine which cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // push daily jobs value to Firebase
            ref.child("dailyJobs")
                .child("dailyJob\(indexPath.row)")
                .updateChildValues(["assigned" : "current user"])
        } else {
            // push weekly jobs value to Firebase
            ref.child("weeklyJobs")
                .child("weeklyJob\(indexPath.row)")
                .updateChildValues(["assigned" : "current user"])
        }
        
        // ----------------
        // INITIAL CELL TAP
        // ----------------
        
        if (!selectedJobs.contains(indexPath)) {           // only add to array if it doesn't already exist
            selectedJobs.append(indexPath)
            // print("Item Added",selectedArray)
            
            let dailyJobsCount = countJobs().dailyCount
            let weeklyJobsCount = countJobs().weeklyCount
            
            // ----------
            // DAILY JOBS
            // ----------
            
            // check if daily jobs is more than 3
            if dailyJobsCount > maxDailyNumber {
                tooManyJobsSelectedAlert(messageTitle: "Daily Jobs", tableViewIndexPath: indexPath, jobCount: countJobs().dailyCount, recommendedNumberOfJobs: 3, dailyOrWeekly: "daily", timeframe: "30-minute")
            } else {
                
                // -----------
                // WEEKLY JOBS
                // -----------
                
                // check if weekly jobs is more than 2
                if weeklyJobsCount > maxWeeklyNumber {
                    tooManyJobsSelectedAlert(messageTitle: "Weekly Jobs", tableViewIndexPath: indexPath, jobCount: countJobs().weeklyCount, recommendedNumberOfJobs: 2, dailyOrWeekly: "weekly", timeframe: "2-hour")
                }
            }
            
        } else {
            
            // ------------------
            // SECONDARY CELL TAP
            // ------------------
            
            // if user taps cell that's already been selected, remove the values
            let index = selectedJobs.index(of: indexPath)
            
            if indexPath.section == 0 {
                // update daily jobs Firebase with 'none' in 'assigned' category...
                self.ref.child("dailyJobs")
                    .child("dailyJob\(indexPath.row)")
                    .updateChildValues(["assigned" : "none"])
            } else {
                // update weekly jobs Firebase with 'none' in 'assigned' category...
                self.ref.child("weeklyJobs")
                    .child("weeklyJob\(indexPath.row)")
                    .updateChildValues(["assigned" : "none"])
            }
            
            // ... then remove value from array
            selectedJobs.remove(at: index!)
            // print("Item Removed",selectedArray)
        }
        
        print(countJobs().dailyCount,"daily jobs chosen, and", countJobs().weeklyCount,"weekly jobs chosen")
        
        tableView.reloadData()      // reloads table so checkmark will show up
    }
    
    
    func tooManyJobsSelectedAlert(messageTitle: String, tableViewIndexPath: IndexPath, jobCount: Int, recommendedNumberOfJobs: Int, dailyOrWeekly: String, timeframe: String) {
        let alert = UIAlertController(title: messageTitle, message: "You have chosen more than \(jobCount) \(dailyOrWeekly) jobs for 'USER'. This is not recommended because 'USER' won't be able to finish within the \(timeframe) timer.\n\nAre you sure you want to assign 'USER' \(jobCount) \(dailyOrWeekly) jobs?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            let index = self.selectedJobs.index(of: tableViewIndexPath)
            
            // update Firebase with 'none' in 'assigned' category...
            self.ref.child("weeklyJobs")
                .child("weeklyJob\(tableViewIndexPath.row)")
                .updateChildValues(["assigned" : "none"])
            
            // ... then remove value from array
            self.selectedJobs.remove(at: index!)
            self.jobsTableView.reloadData()
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            self.maxWeeklyNumber = self.maxWeeklyNumber + 1
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // ---------
    // Functions
    // ---------
    
    func getDailyJobs(completion: @escaping ([[String : Any]]) -> ()) {
        var dictionary = [[String : Any]]()
        ref.child("dailyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                if let value = snap.value as? [String : Any] {
                    dictionary.append(value)
                }
            }
            completion(dictionary)
        }
    }
    
    func getWeeklyJobs(completion: @escaping ([[String : Any]]) -> ()) {
        var dictionary = [[String : Any]]()
        ref.child("weeklyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for child in snapshot.children {
                let snap = child as! FIRDataSnapshot
                if let value = snap.value as? [String : Any] {
                    dictionary.append(value)
                }
            }
            completion(dictionary)
        }
    }
    
    func countJobs() -> (dailyCount: Int, weeklyCount: Int) {
        var dailyJobsCount = 0
        var weeklyJobsCount = 0
        for index in selectedJobs {
            if index.section == 0 {
                dailyJobsCount += 1                     // count number of daily jobs
                //                print(dailyJobs[index.row].name)        // give names of daily jobs
            } else {
                weeklyJobsCount += 1                    // count number of weekly jobs
                //                print(weeklyJobs[index.row].name)       // give names of weekly jobs
            }
        }
        return (dailyJobsCount, weeklyJobsCount)
    }
    
    
    
    // ---------------------------------------------
    // Old function that took forever to figure out:
    // ---------------------------------------------
    
    func getChosenJobToFirebase() {
        // This function took me forever to figure out how to get selected table cells to firebase. LOL!
        ref.child("TESTING").removeValue()
        for index in selectedJobs {
            if index.section == 0 {
                ref.child("TESTING").child("dailyJob\(index.row)").updateChildValues(["assigned" : dailyJobs[index.row].name])
                print(dailyJobs[index.row].name)
            } else {
                ref.child("TESTING").child("weeklyJob\(index.row)").updateChildValues(["assigned" : weeklyJobs[index.row].name])
                print(weeklyJobs[index.row].name)
            }
        }
    }
    
}






