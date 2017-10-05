import UIKit
import Firebase

class Step4VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    var users = [User]()
    
    var dailyJobs: [JobsAndHabits]!
    var weeklyJobs: [JobsAndHabits]!
    var selectedJobs = [IndexPath]()        // for storing user selected cells
    var maxDailyNumber = 3                  // max number of daily chores allowed
    var maxWeeklyNumber = 2                 // max number of weekly chores allowed
    
    var currentUserName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserName = ""
        //        instructionsLabel.text = "Choose daily and weekly job assignments for \(tempUserNamePadiddle!)"
        instructionsLabel.text = ""
        
        dailyJobs = [JobsAndHabits]()
        weeklyJobs = [JobsAndHabits]()
        
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
        
        loadDailyJobs { (dictionary) in
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
        
        loadWeeklyJobs { (dictionary) in
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
        
//        loadMembers { (dictionary) in
//            print(dictionary.count)
//            self.currentUserName = usersArray[0].firstName
//            self.instructionsLabel.text = "Choose daily and weekly job assignments for \(usersArray[0].firstName)."
//            self.userImage.image = usersArray[0].photo
//        }
        
//        loadMembers2 { (usersArray) in
//            print(usersArray.count)
//            for user in usersArray {
//                print(user.firstName)
//            }
//        }
        
//        loadMembers3 { (usersArray) in
//            print(usersArray.count)
//        }
        
//        loadMembers4 { (usersArray) in
//            self.currentUserName = usersArray[0].firstName
//            self.instructionsLabel.text = "Choose daily and weekly job assignments for \(usersArray[0].firstName)."
//            self.userImage.image = usersArray[0].photo
//            self.jobsTableView.reloadData()
        //        }
        
        // 5. KIND OF WORKS
        loadMembers5 { (usersArray) in
            for user in usersArray {
                self.loadMembersProfilePict5(userImageURL: user.imageURL, userFirstName: user.firstName, userBirthday: user.birthday, userPasscode: user.passcode, userGender: user.gender, userChildParent: user.childParent, completion: { (usersIntermediateArray) in
                    self.users = usersIntermediateArray
                })
            }
        }
    }
    
    // 5. KIND OF WORKS...
    func loadMembersProfilePict5(userImageURL: String, userFirstName: String, userBirthday: Int, userPasscode: Int, userGender: String, userChildParent: String, completion: @escaping ([User]) -> ()) {
        let storageRef = FIRStorage.storage().reference(forURL: userImageURL)
        storageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
            let pic = UIImage(data: data!)
            let user = User(profilePhoto: pic!,
                            userFirstName: userFirstName,
                            userBirthday: userBirthday,
                            userPasscode: userPasscode,
                            userGender: userGender,
                            isUserChildOrParent: userChildParent)
            self.users.append(user)
            self.users.sort(by: {$0.birthday > $1.birthday})
            completion(self.users)
        })
    }
 
    
    var userCount = 0
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        print("number of users",users.count)
        print("next button tapped")
        currentUserName = users[userCount].firstName
        userImage.image = users[userCount].photo
        instructionsLabel.text = "Choose daily and weekly job assignments for \(users[userCount].firstName)."
        
        if userCount == (users.count - 1) {
            userCount = 0
        } else {
            userCount += 1
        }
        jobsTableView.reloadData()
        
        
        
        
        /*
        ref.child("members").queryOrdered(byChild: "birthday").queryLimited(toLast: 2).observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            print("Snapshot:", snapshot.childrenCount)
            if let value = snapshot.value as? [String : Any] {
                let birthday = value["birthday"] as! Int
                let name = value["firstName"] as! String
                
                print(value.count)
            }
        }
        */
        
        
        
        
        
        // need to reset daily and weekly max values to 3 and 2, respectively (for new user)
        
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
            
            if dailyJobs[indexPath.row].assigned != "none" {        // 1. check if array has selected job at current location...
                if dailyJobs[indexPath.row].assigned == currentUserName {      // 2. ...and if it is current user...
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")        // 3. ...then show white/green checkmark, black text, job name
                    cell.jobLabel.textColor = UIColor.black
                    cell.jobLabel.text = dailyJobs[indexPath.row].name
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark gray")         // 4. ...otherwise show gray checkmark, gray text, assigned name
                    cell.jobLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
                    cell.jobLabel.text = dailyJobs[indexPath.row].name + " (\(dailyJobs[indexPath.row].assigned))"
                }
            } else {
                cell.selectionBoxImageView.image = UIImage(named: "blank")          // 5. if job isn't selected, show blank box, black text, job name
                cell.jobLabel.textColor = UIColor.black
                cell.jobLabel.text = dailyJobs[indexPath.row].name
            }
            
        // -----------
        // WEEKLY JOBS
        // -----------
            
        } else if indexPath.section == 1 {
            
            if weeklyJobs[indexPath.row].assigned != "none" {        // 1. check if array has selected job at current location...
                if weeklyJobs[indexPath.row].assigned == currentUserName {      // 2. ...and if it is current user...
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")        // 3. ...then show white/green checkmark and black text
                    cell.jobLabel.textColor = UIColor.black
                    cell.jobLabel.text = weeklyJobs[indexPath.row].name
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark gray")         // 4. ...otherwise show gray checkmark and gray text
                    cell.jobLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
                    cell.jobLabel.text = weeklyJobs[indexPath.row].name + " (\(weeklyJobs[indexPath.row].assigned))"
                }
            } else {
                cell.selectionBoxImageView.image = UIImage(named: "blank")          // 5. if job isn't selected, show blank box with black text
                cell.jobLabel.textColor = UIColor.black
                cell.jobLabel.text = weeklyJobs[indexPath.row].name
            }
        }
        return cell
    }
    
    
    
    func updateJobAssignmentsOnFirebase(dailyOrWeekly: String, selectedIndexPath: Int, assignment: String, completion: @escaping (FIRDataSnapshot) -> ()) {
        ref.child(dailyOrWeekly).queryOrdered(byChild: "order").queryEqual(toValue: selectedIndexPath).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            snapshot.ref.updateChildValues(["assigned" : assignment])
            completion(snapshot)
        })
    }
    
    func setJobAssignmentToNoneOnFirebase(indexPathRow: Int) {
        ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPathRow).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            snapshot.ref.updateChildValues(["assigned" : "none"])
            self.dailyJobs[indexPathRow].assigned = "none"     // update local array
            self.jobsTableView.reloadData()
        })
    }
    
    
    // determine which cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // ----------
        // DAILY JOBS
        // ----------
        
        if indexPath.section == 0 {
            
            // -----------------------------------------------------------------------
            // ...First check to see if the job is already assigned to current user...
            // -----------------------------------------------------------------------
            
            if dailyJobs[indexPath.row].assigned == currentUserName {
                // find job's order at the tableview's index path (query), then update its 'assigned' property to be 'none'
                ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : "none"])
                    self.dailyJobs[indexPath.row].assigned = "none"     // update local array
                    self.jobsTableView.reloadData()
                })
                
                // ----------------------------------------
                // ...then check if the job is available...
                // ----------------------------------------
                
            } else if dailyJobs[indexPath.row].assigned == "none" {
                ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : self.currentUserName])
                    self.dailyJobs[indexPath.row].assigned = self.currentUserName      // update local array
                    var dailyJobsCount = 0
                    for job in self.dailyJobs {
                        if job.assigned == self.currentUserName {
                            dailyJobsCount += 1
                        }
                    }
                    
                    // -----------------------------------------------------------------
                    // if job is available, check to see if user already has enough jobs
                    // -----------------------------------------------------------------
                    
                    if dailyJobsCount > self.maxDailyNumber {
                        let alert = UIAlertController(title: "Daily Jobs", message: "You have chosen more than 3 daily jobs for \(self.currentUserName!). This is not recommended because \(self.currentUserName!) won't be able to finish within the 30-minute time limit.\n\nAre you sure you want to assign \(self.currentUserName!) \(dailyJobsCount) daily jobs?", preferredStyle: .alert)
                        // if user taps cancel
                        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                            // update local array
                            self.dailyJobs[indexPath.row].assigned = "none"
                            // remove assignment from Firebase
                            self.ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                                snapshot.ref.updateChildValues(["assigned" : "none"])
                                self.jobsTableView.reloadData()
                            })
                        }))
                        // if user taps okay, dismiss alert and increase daily max
                        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                            self.maxDailyNumber = self.maxDailyNumber + 1
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.jobsTableView.reloadData()
                })
            } else {
                
                // -------------------------------------------------------
                // ...and finally check if job is assigned to another user
                // -------------------------------------------------------
                
                self.jobsTableView.reloadData()
                let alert = UIAlertController(title: "Job Selection", message: "The job you selected (\(dailyJobs[indexPath.row].name)) is already assigned to \(dailyJobs[indexPath.row].assigned).\n\nPlease choose another job.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
            
        // -----------
        // WEEKLY JOBS
        // -----------
            
        } else if indexPath.section == 1 {
            
            // -----------------------------------------------------------------------
            // ...First check to see if the job is already assigned to current user...
            // -----------------------------------------------------------------------
            
            if weeklyJobs[indexPath.row].assigned == currentUserName {
                // find job's order at the tableview's index path (query), then update its 'assigned' property to be 'none'
                ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : "none"])
                    self.weeklyJobs[indexPath.row].assigned = "none"     // update local array
                    self.jobsTableView.reloadData()
                })
                
                // ----------------------------------------
                // ...then check if the job is available...
                // ----------------------------------------
                
            } else if weeklyJobs[indexPath.row].assigned == "none" {
                ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : self.currentUserName])
                    self.weeklyJobs[indexPath.row].assigned = self.currentUserName      // update local array
                    var weeklyJobsCount = 0
                    for job in self.weeklyJobs {
                        if job.assigned == self.currentUserName {
                            weeklyJobsCount += 1
                        }
                    }
                    
                    // -----------------------------------------------------------------
                    // if job is available, check to see if user already has enough jobs
                    // -----------------------------------------------------------------
                    
                    if weeklyJobsCount > self.maxWeeklyNumber {
                        let alert = UIAlertController(title: "Weekly Jobs", message: "You have chosen more than 2 weekly jobs for \(self.currentUserName!). This is not recommended because \(self.currentUserName!) won't be able to finish within the 2-hour time limit.\n\nAre you sure you want to assign \(self.currentUserName!) \(weeklyJobsCount) weekly jobs?", preferredStyle: .alert)
                        // if user taps cancel
                        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                            // update local array
                            self.weeklyJobs[indexPath.row].assigned = "none"
                            // remove assignment from Firebase
                            self.ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                                snapshot.ref.updateChildValues(["assigned" : "none"])
                                self.jobsTableView.reloadData()
                            })
                        }))
                        // if user taps okay, dismiss alert and increase weekly max
                        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                            self.maxWeeklyNumber = self.maxWeeklyNumber + 1
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.jobsTableView.reloadData()
                })
            } else {
                
                // -------------------------------------------------------
                // ...and finally check if job is assigned to another user
                // -------------------------------------------------------
                
                self.jobsTableView.reloadData()
                let alert = UIAlertController(title: "Job Selection", message: "The job you selected (\(weeklyJobs[indexPath.row].name)) is already assigned to \(weeklyJobs[indexPath.row].assigned).\n\nPlease choose another job.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func loadDailyJobs(completion: @escaping ([[String : Any]]) -> ()) {
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
    
    func loadWeeklyJobs(completion: @escaping ([[String : Any]]) -> ()) {
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
    
    // cool unused function, returns two values like this: countJobs().dailyCount
    func countJobs() -> (dailyCount: Int, weeklyCount: Int) {
        var dailyJobsCount = 0
        var weeklyJobsCount = 0
        for job in dailyJobs {
            if job.assigned == currentUserName {
                dailyJobsCount += 1
            }
        }
        for job in weeklyJobs {
            if job.assigned == currentUserName {
                weeklyJobsCount += 1
            }
        }
        return (dailyJobsCount, weeklyJobsCount)
    }
    
    
    
    // ========================================================================================
    
    // 4. WORKS EXCEPT USER IMAGE DOESN'T SHOW
    /*
    func loadMembers4(completion: @escaping ([User]) -> ()) {
        var usersArray = [User]()
        ref.child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let birthday = value["birthday"] as! Int
                        let childParent = value["childParent"] as! String
                        let firstName = value["firstName"] as! String
                        let gender = value["gender"] as! String
                        let passcode = value["passcode"] as! Int
                        let profileImageUrl = value["profileImageUrl"] as! String
                        
                        // get image
                        
                        self.loadMemberProfilePict4(userProfileImageUrl: profileImageUrl, completion: { (userImage) in
                            print("3. user image in 'loadMembers4': ",userImage)
                            let user = User(profilePhoto: userImage, userFirstName: firstName, userBirthday: birthday, userPasscode: passcode, userGender: gender, isUserChildOrParent: childParent)
                            usersArray.append(user)
                            usersArray.sort(by: {$0.birthday > $1.birthday})
                        })
                    }
                }
            }
            completion(usersArray)
        })
    }
    
    // 4 WORKS EXCEPT USER IMAGE DOENS'T SHOW
    func loadMemberProfilePict4(userProfileImageUrl: String, completion: @escaping (UIImage) -> ()) {
        var userImage = UIImage()
        
        let storageRef = FIRStorage.storage().reference(forURL: userProfileImageUrl)
        storageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
            userImage = UIImage(data: data!)!
            print("1. user image inside closure: ",userImage)
        })
        completion(userImage)
        print("2. user image after completion: ",userImage)
    }
    */
 
    // ========================================================================================
    
    // WORKS EXCEPT FOR IMAGE DOESN'T SHOW (ALT TO #4)
    /*
    func loadMemberProfilePict4(userProfileImageUrl: String, completion: @escaping (UIImage) -> ()) {
        var userImage = UIImage()
        let storageRef = FIRStorage.storage().reference(forURL: userProfileImageUrl)
        storageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (imageData, error) in
            print(imageData ?? "no data")
            let profileImage = UIImage(data: imageData!)
            userImage = profileImage!
        })
        completion(userImage)
    }
    */
    // ========================================================================================

    
    // WORKS BEST, BUT IMAGES CYCLE THRU ALL USERS
    func loadMembers5(completion: @escaping ([UserClass]) -> ()) {
        var usersArray = [UserClass]()
        ref.child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let birthday = value["birthday"] as! Int
                        let childParent = value["childParent"] as! String
                        let firstName = value["firstName"] as! String
                        let gender = value["gender"] as! String
                        let passcode = value["passcode"] as! Int
                        let profileImageUrl = value["profileImageUrl"] as! String
                        
                        let user = UserClass(userProfileImageURL: profileImageUrl, userFirstName: firstName, userBirthday: birthday, userPasscode: passcode, userGender: gender, isUserChildOrParent: childParent)
                        usersArray.append(user)
                        usersArray.sort(by: {$0.birthday > $1.birthday})
                    }
                }
            }
            completion(usersArray)
        })
    }
    
    // WORKS BEST, BUT IMAGES CYCLE THRU ALL USERS
    func loadMemberProfilePict5(userProfileImageUrl: String, completion: @escaping (UIImage) -> ()) {
        var userImage = UIImage()
        let storageRef = FIRStorage.storage().reference(forURL: userProfileImageUrl)
        storageRef.data(withMaxSize: 1024 * 1024) { (imageData, error) in
            print(imageData ?? "no data found!")
            userImage = UIImage(data: imageData!)!
        }
        completion(userImage)
        print("1. user image: ",userImage)
    }
    
    
    // ========================================================================================

    
    // TESTING END
    
    
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






