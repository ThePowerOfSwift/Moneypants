import UIKit
import Firebase

class Step4BackupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    var users = [User]()        // create new instance of 'users' using Firebase to populate (not bringing it from prev VCs)
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var dailyJobs = [JobsAndHabits]()
    var weeklyJobs = [JobsAndHabits]()
    var selectedArray = [IndexPath]()       // for storing user selected cells
    var assignedArray = [Int]()       // for storing previously assigned jobs
    var maxDailyNumber = 3                  // max number of daily chores allowed
    var maxWeeklyNumber = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignedArray = [1,2,3,4,5,6,7,8,9,0]
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        jobsTableView.tableFooterView = UIView()
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        //        loadExistingJobs {
        // still not finished loading when this code gets called. aargh!
        //        }
        
        loadExistingUsers {
            print("users count:",self.users.count)
        }
        
        
        performSegue(withIdentifier: "ExplainerPopup", sender: self)
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        
        
        
        // TESTING
        // ================================================================
        
        //        testing { (dictionary) in
        //            for item in dictionary {
        //                print(item)
        //                let multiplier = item["multiplier"] as! Int
        //                let name = item["name"] as! String
        //                let assigned = item["assigned"] as! String
        //                let order = item["order"] as! Int
        //                let dailyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
        //                self.dailyJobs.append(dailyJob)
        //                //            }
        //                print(self.dailyJobs)
        //            }
        //        }
        
        // ATTEMPT #2
        getAllJobsAndHabits { (dailyJob) in
            self.dailyJobs.append(dailyJob)
            print(self.dailyJobs.count)
            //            print(dailyJob)
            self.jobsTableView.reloadData()
        }
        
        testing { (dictionary) in
            print("dictionary count:",dictionary.count)
        }
    }
    
    
    
    // TESTING
    // ================================================================
    
    func testing(completion: @escaping ([String : Any]) -> ()) {
        ref.child("weeklyJobs").observe(.childAdded, with: { (snapshot) in
            if let value = snapshot.value as? [String : Any] {
                completion(value as [String : Any])
                return
            }
            completion([:])
        })
    }
    
    // ATTEMPT #2
    func getAllJobsAndHabits(completion: @escaping (JobsAndHabits) -> ()) {
        ref.child("dailyJobs").observe(.childAdded, with: { (snapshot) in
            let receivedMessage = snapshot.value as! [String : Any]
            let name = receivedMessage["name"] as? String
            let multiplier = receivedMessage["multiplier"] as? Double
            let assigned = receivedMessage["assigned"] as? String
            let order = receivedMessage["order"] as? Int
            completion(JobsAndHabits(jobName: name!, jobMultiplier: multiplier!, jobAssign: assigned!, jobOrder: order!))
        })
    }
    
    // ================================================================
    // DONE TESTING
    
    
    
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        print("next button tapped")
        
        for user in users {
            print(user.firstName, user.childParent)
        }
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
        // popluate 2 sections with daily and weekly job names
        if indexPath.section == 0 {
            cell.jobLabel.text = dailyJobs[indexPath.row].name
            //            cell.backgroundColor = assignedArray[indexPath.row]
            
        } else {
            cell.jobLabel.text = weeklyJobs[indexPath.row].name
        }
        // change selection box if user taps on cell
        if (selectedArray.contains(indexPath)) {
            cell.selectionBoxImageView.image = UIImage(named: "checkmark white")
        } else {
            cell.selectionBoxImageView.image = UIImage(named: "blank")
        }
        return cell
    }
    
    // determine which cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // push daily jobs value to Firebase
            ref.child("dailyJobs")
                .child("dailyJob\(indexPath.row)")
                .updateChildValues(["assigned" : dailyJobs[indexPath.row].name])
        } else {
            // push weekly jobs value to Firebase
            ref.child("weeklyJobs")
                .child("weeklyJob\(indexPath.row)")
                .updateChildValues(["assigned" : weeklyJobs[indexPath.row].name])
        }
        
        // ----------------
        // INITIAL CELL TAP
        // ----------------
        
        if (!selectedArray.contains(indexPath)) {           // only add to array if it doesn't already exist
            selectedArray.append(indexPath)
            // print("Item Added",selectedArray)
            
            let dailyJobsCount = countJobs().dailyCount
            let weeklyJobsCount = countJobs().weeklyCount
            
            // ----------
            // DAILY JOBS
            // ----------
            
            // check if daily jobs is more than 3
            if dailyJobsCount > maxDailyNumber {
                let alert = UIAlertController(title: "Daily Jobs", message: "You have chosen \(dailyJobsCount) daily jobs. It is recommended that each individual only have three daily jobs max. Are you sure you want to assign 'USER' \(dailyJobsCount) daily jobs?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                    let index = self.selectedArray.index(of: indexPath)
                    
                    // update Firebase with 'none' in 'assigned' category...
                    self.ref.child("dailyJobs")
                        .child("dailyJob\(indexPath.row)")
                        .updateChildValues(["assigned" : "none"])
                    
                    // ... then remove value from array
                    self.selectedArray.remove(at: index!)
                    tableView.reloadData()
                    alert.dismiss(animated: true, completion: nil)
                }))
                
                alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                    self.maxDailyNumber = self.maxDailyNumber + 1
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            } else {
                
                // -----------
                // WEEKLY JOBS
                // -----------
                
                // check if weekly jobs is more than 2
                if weeklyJobsCount > maxWeeklyNumber {
                    let alert = UIAlertController(title: "Weekly Jobs", message: "You have chosen \(weeklyJobsCount) daily jobs. It is recommended that each individual only have 2 weekly jobs max. Are you sure you want to assign 'USER' \(weeklyJobsCount) daily jobs?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                        let index = self.selectedArray.index(of: indexPath)
                        
                        // update Firebase with 'none' in 'assigned' category...
                        self.ref.child("weeklyJobs")
                            .child("weeklyJob\(indexPath.row)")
                            .updateChildValues(["assigned" : "none"])
                        
                        // ... then remove value from array
                        self.selectedArray.remove(at: index!)
                        tableView.reloadData()
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    
                    alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                        self.maxWeeklyNumber = self.maxWeeklyNumber + 1
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            
            // ------------------
            // SECONDARY CELL TAP
            // ------------------
            
            // if user taps cell that's already been selected, remove the values
            let index = selectedArray.index(of: indexPath)
            
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
            selectedArray.remove(at: index!)
            // print("Item Removed",selectedArray)
        }
        
        print(countJobs().dailyCount,"daily jobs chosen")
        print(countJobs().weeklyCount,"weekly jobs chosen")
        
        tableView.reloadData()      // reloads table so checkmark will show up
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func countJobs() -> (dailyCount: Int, weeklyCount: Int) {
        var dailyJobsCount = 0
        var weeklyJobsCount = 0
        for index in selectedArray {
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
    
    func loadExistingJobs(_ completion: @escaping ([User]) -> ()) {
        ref.child("dailyJobs").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                completion([])
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
    
    func loadExistingUsers(_ completion: @escaping () -> ()) {
        ref.child("members").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let userPhotoUrl = dict["profileImageUrl"] as! String
                let userFirstName = dict["firstName"] as! String
                let userBirthday = dict["birthday"] as! Int
                let userPasscode = dict["passcode"] as! Int
                let userGender = dict["gender"] as! String
                let isUserChildOrParent = dict["childParent"] as! String
                
                let storageRef = FIRStorage.storage().reference(forURL: userPhotoUrl)
                storageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    let pic = UIImage(data: data!)
                    let user = User(profilePhoto: pic!,
                                    userFirstName: userFirstName,
                                    userBirthday: userBirthday,
                                    userPasscode: userPasscode,
                                    userGender: userGender,
                                    isUserChildOrParent: isUserChildOrParent)
                    self.users.append(user)
                    self.users.sort(by: {$0.birthday < $1.birthday})
                    completion()
                })
            }
        }
    }
    
    
    
    
    
    
    // OLD VERSION
    /*
     func loadExistingUsers(_ completion: @escaping () -> ()) {
     ref.child("members").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
     if let dict = snapshot.value as? [String : Any] {
     let userPhotoUrl = dict["profileImageUrl"] as! String
     let userFirstName = dict["firstName"] as! String
     let userBirthday = dict["birthday"] as! Int
     let userPasscode = dict["passcode"] as! Int
     let userGender = dict["gender"] as! String
     let isUserChildOrParent = dict["childParent"] as! String
     
     let storageRef = FIRStorage.storage().reference(forURL: userPhotoUrl)
     storageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
     let pic = UIImage(data: data!)
     let user = User(profilePhoto: pic!,
     userFirstName: userFirstName,
     userBirthday: userBirthday,
     userPasscode: userPasscode,
     userGender: userGender,
     isUserChildOrParent: isUserChildOrParent)
     self.users.append(user)
     self.users.sort(by: {$0.birthday < $1.birthday})
     completion()
     })
     }
     }
     }
     */
    
    
    // --------------------------------------------
    // Old function that took forever to figure out
    // --------------------------------------------
    
    func getChosenJobToFirebase() {
        // This function took me forever to figure out how to get selected table cells to firebase. LOL!
        ref.child("TESTING").removeValue()
        for index in selectedArray {
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






