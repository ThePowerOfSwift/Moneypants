import UIKit
import Firebase

class Step4VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var selectUsersButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var reviewAllButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var users = [User]()
    var currentMember = 0           // used for cycling through users when 'next' button is tapped
    var currentUserName: String!

    var dailyJobs: [JobsAndHabits]!
    var weeklyJobs: [JobsAndHabits]!
    var dailyJobsMax = 3                  // max number of daily chores allowed
    var weeklyJobsMax = 2                 // max number of weekly chores allowed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUserName = ""
        instructionsLabel.text = ""
        selectUsersButton.isHidden = true
        reviewAllButton.isHidden = true
        
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
        
        loadExistingDailyAndWeeklyJobs()
        
        loadMembers { (usersArray) in
            var memberImageCount = 0
            for user in usersArray {
                self.loadMemberProfilePict(userImageURL: user.imageURL, userFirstName: user.firstName, userBirthday: user.birthday, userPasscode: user.passcode, userGender: user.gender, userChildParent: user.childParent, completion: { (usersIntermediateArray) in
                    memberImageCount += 1
                    if memberImageCount == usersArray.count {
                        
                        // wait until all user images are loaded, then update view
                        self.users = usersIntermediateArray

                        // check to see if user has done this step yet
                        self.ref.child("setupProgress").observeSingleEvent(of: .value, with: { (snapshot) in
                            if let value = snapshot.value as? Int {
                                
                                // if user has already done setup, go right into setup page (no intro overlay)
                                if value >= 40 {
                                    self.userImage.image = self.users[0].photo
                                    self.currentUserName = self.users[0].firstName
                                    self.instructionsLabel.text = "Choose daily and weekly job assignments for \(self.users[0].firstName)."
                                    self.navigationItem.title = self.users[0].firstName
                                    self.jobsTableView.reloadData()
                                    self.reviewAllButton.isHidden = false
                                    self.nextButton.isEnabled = false
                                    self.selectUsersButton.isHidden = false
                                    
                                } else {
                                    
                                    // if user hasn't done setup yet, show the overlay
                                    self.performSegue(withIdentifier: "UserIntroPopup", sender: self)
                                    // wait half a second before updating images and tableview data
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        self.userImage.image = self.users[0].photo
                                        self.currentUserName = self.users[0].firstName
                                        self.instructionsLabel.text = "Choose daily and weekly job assignments for \(self.users[0].firstName)."
                                        self.navigationItem.title = self.users[0].firstName
                                        self.jobsTableView.reloadData()
                                    })
                                }
                            }
                        })
                    }
                })
            }
        }
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
                self.dailyJobs[indexPath.row].assigned = "none"     // update local array
                self.jobsTableView.reloadData()
                // find job's order at the tableview's index path (query), then update its 'assigned' property to be 'none'
                ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : "none"])
                })
                
                // ----------------------------------------
                // ...then check if the job is available...
                // ----------------------------------------
                
            } else if dailyJobs[indexPath.row].assigned == "none" {
                self.dailyJobs[indexPath.row].assigned = self.currentUserName      // update local array
                var selectedDailyJobsCount = 0
                for job in self.dailyJobs {
                    if job.assigned == self.currentUserName {
                        selectedDailyJobsCount += 1
                    }
                }
                ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : self.currentUserName])
                    
                    // -----------------------------------------------------------------
                    // if job is available, check to see if user already has enough jobs
                    // -----------------------------------------------------------------
                    
                    if selectedDailyJobsCount > self.dailyJobsMax {
                        let alert = UIAlertController(title: "Daily Jobs", message: "You have chosen more than 3 daily jobs for \(self.currentUserName!). This is not recommended because \(self.currentUserName!) won't be able to finish within the 30-minute time limit.\n\nAre you sure you want to assign \(self.currentUserName!) \(selectedDailyJobsCount) daily jobs?", preferredStyle: .alert)
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
                            self.dailyJobsMax = self.dailyJobsMax + 1
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.jobsTableView.reloadData()
                })
            } else {
                
                // --------------------------------------------------------
                // ...otherwise, if job is already assigned to another user
                // --------------------------------------------------------
                
                self.jobsTableView.reloadData()
                let alert = UIAlertController(title: "Job Selection", message: "The job you selected (\(dailyJobs[indexPath.row].name)) is already assigned to \(dailyJobs[indexPath.row].assigned).\n\nDo you want to reassign it to \(users[currentMember].firstName) instead?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "reassign", style: .default, handler: { (action) in
                    
                    // check for number of currently assigned jobs for user
                    var selectedDailyJobsCount = 1      // currently selected job counts as 1 job even tho it hasn't been assigned yet...
                    for job in self.dailyJobs {
                        if job.assigned == self.currentUserName {
                            selectedDailyJobsCount += 1
                        }
                    }
                    
                    // ------------------------------------------------------------------
                    // ...first check to see if current user already has too many jobs...
                    // ------------------------------------------------------------------
                    
                    if selectedDailyJobsCount > self.dailyJobsMax {
                        let alert = UIAlertController(title: "Daily Jobs", message: "You have chosen more than 3 daily jobs for \(self.currentUserName!). This is not recommended because \(self.currentUserName!) won't be able to finish within the 30-minute time limit.\n\nAre you sure you want to assign \(self.currentUserName!) \(selectedDailyJobsCount) daily jobs?", preferredStyle: .alert)
                        // if user taps cancel, dismiss the alert and do nothing else
                        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        // if user taps okay, dismiss alert, increase daily max, change job to new user, and reload table data
                        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                            self.dailyJobsMax = self.dailyJobsMax + 1
                            // update local array
                            self.dailyJobs[indexPath.row].assigned = self.users[self.currentMember].firstName
                            self.jobsTableView.reloadData()
                            // update firebase
                            self.ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                                snapshot.ref.updateChildValues(["assigned" : self.currentUserName])
                            })
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                        // ------------------------------------------------------------------
                        // ...if user doesn't have too many jobs, then assign the job to them
                        // ------------------------------------------------------------------
                        
                        self.dailyJobs[indexPath.row].assigned = self.users[self.currentMember].firstName
                        self.jobsTableView.reloadData()
                        // update firebase
                        self.ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                            snapshot.ref.updateChildValues(["assigned" : self.currentUserName])
                        })
                    }
                    self.jobsTableView.reloadData()
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
                self.weeklyJobs[indexPath.row].assigned = "none"     // update local array
                self.jobsTableView.reloadData()
                // find job's order at the tableview's index path (query), then update its 'assigned' property to be 'none'
                ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : "none"])
                })
                
                // ----------------------------------------
                // ...then check if the job is available...
                // ----------------------------------------
                
            } else if weeklyJobs[indexPath.row].assigned == "none" {
                self.weeklyJobs[indexPath.row].assigned = self.currentUserName      // update local array
                var weeklyJobsCount = 0
                for job in self.weeklyJobs {
                    if job.assigned == self.currentUserName {
                        weeklyJobsCount += 1
                    }
                }
                ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : self.currentUserName])
                    
                    // -----------------------------------------------------------------
                    // if job is available, check to see if user already has enough jobs
                    // -----------------------------------------------------------------
                    
                    if weeklyJobsCount > self.weeklyJobsMax {
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
                            self.weeklyJobsMax = self.weeklyJobsMax + 1
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    self.jobsTableView.reloadData()
                })
            } else {

                // ----------------------------------------------------
                // ...and then check if job is assigned to another user
                // ----------------------------------------------------
                
                self.jobsTableView.reloadData()
                let alert = UIAlertController(title: "Job Selection", message: "The job you selected (\(weeklyJobs[indexPath.row].name)) is already assigned to \(weeklyJobs[indexPath.row].assigned).\n\nDo you want to reassign it to \(users[currentMember].firstName) instead?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "reassign", style: .default, handler: { (action) in
                    
                    // check for number of currently assigned jobs for user
                    var selectedWeeklyJobsCount = 1      // currently selected job counts as 1 job even tho it hasn't been assigned yet...
                    for job in self.weeklyJobs {
                        if job.assigned == self.currentUserName {
                            selectedWeeklyJobsCount += 1
                        }
                    }
                    
                    // -----------------------------------------------------------------------------------------------------
                    // if job is already assigned to another user, check to see if current user already has too many jobs...
                    // -----------------------------------------------------------------------------------------------------
                    
                    if selectedWeeklyJobsCount > self.weeklyJobsMax {
                        let alert = UIAlertController(title: "Weekly Jobs", message: "You have chosen more than 2 weekly jobs for \(self.currentUserName!). This is not recommended because \(self.currentUserName!) won't be able to finish within the 2-hour time limit.\n\nAre you sure you want to assign \(self.currentUserName!) \(selectedWeeklyJobsCount) weekly jobs?", preferredStyle: .alert)
                        // if user taps cancel, dismiss the alert and do nothing else
                        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        // if user taps okay, dismiss alert, increase weekly max, change job to new user, and reload table data
                        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                            self.weeklyJobsMax = self.weeklyJobsMax + 1
                            // update local array
                            self.weeklyJobs[indexPath.row].assigned = self.users[self.currentMember].firstName
                            self.jobsTableView.reloadData()
                            // update firebase
                            self.ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                                snapshot.ref.updateChildValues(["assigned" : self.currentUserName])
                            })
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                        // ------------------------------------------------------------------
                        // ...if user doesn't have too many jobs, then assign the job to them
                        // ------------------------------------------------------------------
                        
                        self.weeklyJobs[indexPath.row].assigned = self.users[self.currentMember].firstName
                        self.jobsTableView.reloadData()
                        // update firebase
                        self.ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                            snapshot.ref.updateChildValues(["assigned" : self.currentUserName])
                        })
                    }
                    self.jobsTableView.reloadData()
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // ------------------
    // MARK: - Navigation
    // ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserIntroPopup" {
            let nextViewContoller = segue.destination as! Step4PopupVC
            nextViewContoller.popupImage = users[currentMember].photo
            nextViewContoller.mainLabelText = users[currentMember].firstName
            let age = calculateAge(birthday: "\(users[currentMember].birthday)")
            // determine if current user is child or parent
            if users[currentMember].childParent == "parent" {
                nextViewContoller.bodyLabelText = "\(users[currentMember].firstName) should assign \(determineGender().him_her.lowercased())self any jobs that were not assigned to the children. \(determineGender().he_she) can split the remaining jobs with \(determineGender().his_her.lowercased()) spouse.\n\nIn the next step, \(users[currentMember].firstName) will get the chance to assign \(determineGender().him_her.lowercased())self a couple additional duties that only parents can do."
                nextViewContoller.watchVideoButtonHiddenStatus = true
                nextViewContoller.watchVideoButtonHeightValue = 0
            } else {
                nextViewContoller.bodyLabelText = "Choose daily and weekly job assignments for \(users[currentMember].firstName), who is \(age) years old. For ideas on which jobs to select for \(determineGender().him_her.lowercased()), tap below to see a list of possible age-appropriate jobs."
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        ref.updateChildValues(["setupProgress" : 40])      // setupProgress: each step is an increment of 10, with each substep being a single digit, so step 4 would be 40
        
        // perform Firebase query on daily jobs to see how many jobs current user has assigned (snapshot returns count)
        ref.child("dailyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: users[currentMember].firstName).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            // -------------------------------------------------
            // 1. does current user have at least one daily job?
            // -------------------------------------------------
            
            // 1A. user has ZERO daily jobs assigned
            if snapshot.childrenCount == 0 {
                self.zeroDailyJobsAssignedAlert()
                
            // 1B. user has at least one daily jobs assigned
            } else if snapshot.childrenCount != 0 {
                
                // ---------------------------------------------------
                // 2. does current user have at least one weeklky job?
                // ---------------------------------------------------
                
                self.ref.child("weeklyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: self.users[self.currentMember].firstName).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                    
                    // 2A. user has ZERO weekly jobs assigned
                    if snapshot.childrenCount == 0 {
                        let alert = UIAlertController(title: "Not Enough Jobs", message: "You have not chosen any weekly jobs for \(self.users[self.currentMember].firstName). Are you sure you want to continue?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                        }))
                        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                            alert.dismiss(animated: true, completion: nil)
                            
                            // -------------------------------------------
                            // 3. is current user oldest member of family?
                            // -------------------------------------------
                            
                            // 3A. user is NOT oldest member of family
                            if self.currentMember != (self.users.count - 1) {
                                print("current family member:",self.currentMember, "users count:",self.users.count)
                                // 3A-1. go to next user
                                self.presentNextUser()
                                
                            // 3B. user is oldest member of family
                            } else if self.currentMember == (self.users.count - 1) {
                                self.reviewFamilyJobs()
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        
                        // -------------------------------------------
                        // 3. is current user oldest member of family?
                        // -------------------------------------------
                        
                        // current user is oldest member of family
                        if self.currentMember == (self.users.count - 1) {
                            self.reviewFamilyJobs()
                        } else if self.currentMember != (self.users.count - 1) {
                            self.presentNextUser()
                        }
                    }
                }
            }
        }
        //        ref.child("dailyJobs").removeAllObservers()
        //        ref.child("weeklyJobs").removeAllObservers()
    }
    
    @IBAction func selectUsersButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select A User", message: "Please choose a family member to review their job assignments", preferredStyle: .alert)
        for (index, user) in users.enumerated() {
            alert.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                self.currentMember = index
                self.userImage.image = self.users[self.currentMember].photo
                self.currentUserName = self.users[self.currentMember].firstName
                self.instructionsLabel.text = "Choose daily and weekly job assignments for \(self.users[self.currentMember].firstName)."
                self.navigationItem.title = self.users[self.currentMember].firstName
                self.jobsTableView.reloadData()
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reviewAllButtonTapped(_ sender: UIButton) {
        reviewFamilyJobs()
    }
    
    // ---------
    // Functions
    // ---------
    
    func loadExistingDailyAndWeeklyJobs() {
        ref.child("dailyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let multiplier = value["multiplier"] as! Double
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let dailyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
                        self.dailyJobs.append(dailyJob)
                        self.dailyJobs.sort(by: {$0.order < $1.order})
                        
                        self.jobsTableView.reloadData()
                    }
                }
            }
        }
        ref.child("weeklyJobs").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            for item in snapshot.children {
                if let snap = item as? FIRDataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let multiplier = value["multiplier"] as! Double
                        let name = value["name"] as! String
                        let assigned = value["assigned"] as! String
                        let order = value["order"] as! Int
                        
                        let weeklyJob = JobsAndHabits(jobName: name, jobMultiplier: multiplier, jobAssign: assigned, jobOrder: order)
                        self.weeklyJobs.append(weeklyJob)
                        self.weeklyJobs.sort(by: {$0.order < $1.order})
                        
                        self.jobsTableView.reloadData()
                    }
                }
            }
        }
    }
    
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
    
    // WORKS BEST, BUT IMAGES CYCLE THRU ALL USERS
    func loadMembers(completion: @escaping ([UserClass]) -> ()) {
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
    func loadMemberProfilePict(userImageURL: String, userFirstName: String, userBirthday: Int, userPasscode: Int, userGender: String, userChildParent: String, completion: @escaping ([User]) -> ()) {
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
    
    func zeroDailyJobsAssignedAlert() {
        let alert = UIAlertController(title: "Not Enough Jobs", message: "Please assign \(self.users[self.currentMember].firstName) at least one daily job.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reviewFamilyJobs() {
        
        // -------------------------------
        // 4. are all daily jobs assigned?
        // -------------------------------
        
        self.ref.child("dailyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: "none").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            
            // 4A. all daily jobs are NOT assigned
            if snapshot.childrenCount != 0 {
                let alert = UIAlertController(title: "Review Family Assignments", message: "There are some daily jobs that have not been assigned to any users. All daily jobs must be assigned to family members.\n\nIf a job is not going to be assigned, use the 'back' button to return to the job creation page and delete that job.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    self.selectUsersButton.isHidden = false
                    self.reviewAllButton.isHidden = false
                    self.nextButton.isEnabled = false
                }))
                self.present(alert, animated: true, completion: nil)
                
            // 4B. all daily job ARE assigned
            } else if snapshot.childrenCount == 0 {
                
                // -----------------------------------------------
                // 5. do all users have at least one job assigned?
                // -----------------------------------------------
                
                // 5A. at least one user does NOT have at least one daily job
                if self.checkIfAllUsersHaveDailyJobs() == false {
                    let alert = UIAlertController(title: "Unassigned User", message: "The following user(s) do not have at least one daily job assignment: \(self.whatUsersDontHaveJobs()).", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.selectUsersButton.isHidden = false
                        self.reviewAllButton.isHidden = false
                        self.nextButton.isEnabled = false
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                // 5B. all users have at least one daily job
                } else {
                    
                    // --------------------------------
                    // 6. are all weekly jobs assigned?
                    // --------------------------------
                    
                    self.ref.child("weeklyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: "none").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                        
                        // 6A. all weekly jobs are NOT assigned
                        if snapshot.childrenCount != 0 {
                            let alert = UIAlertController(title: "Review Family Assignments", message: "Some weekly jobs remain unassigned.\n\nDo you want to go back and assign them, or do you want to leave them unassigned and continue with setup?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "continue", style: .default, handler: { (action) in
                                alert.dismiss(animated: true, completion: nil)
                                self.performSegue(withIdentifier: "PaydayInspections", sender: self)
                            }))
                            alert.addAction(UIAlertAction(title: "assign", style: .cancel, handler: { (action) in
                                self.selectUsersButton.isHidden = false
                                self.reviewAllButton.isHidden = false
                                self.nextButton.isEnabled = false
                                // change 'next' button to allow users to go to next step and not have to cycle through all users again
                                alert.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            // 6B. all weekly jobs ARE assigned
                        } else if snapshot.childrenCount == 0 {
                            self.performSegue(withIdentifier: "PaydayInspections", sender: self)
                        }
                    }
                }
            }
        }
    }
    
    func checkIfAllUsersHaveDailyJobs() -> Bool {
        var tempArray = [String]()
        for job in self.dailyJobs {
            for user in self.users {
                if job.assigned == user.firstName {
//                    print(user.firstName,"has the job:",job.assigned)
                    tempArray.append(user.firstName)
                }
            }
        }
        
        for user in self.users {
            if !tempArray.contains(user.firstName) {
                return false
            }
        }
        return true
    }
    
    func whatUsersDontHaveJobs() -> [String] {
        var tempArray = [String]()
        for job in self.dailyJobs {
            for user in self.users {
                if job.assigned == user.firstName {
//                    print(user.firstName,"has the job:",job.assigned)
                    tempArray.append(user.firstName)
                }
            }
        }
        
        var missingUser = [String]()
        for user in self.users {
            if !tempArray.contains(user.firstName) {
                missingUser.append(user.firstName)
            }
        }
        return missingUser
    }

    func presentNextUser() {
        self.currentMember += 1
        
        // ----------------------------------------------------------------------------------
        // if next user already has jobs assigned, there's no need to show their popup again?
        // ----------------------------------------------------------------------------------
        
        self.ref.child("dailyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: self.users[self.currentMember].firstName).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            print("user has",snapshot.childrenCount,"jobs assigned")
            if snapshot.childrenCount > 0 {
                self.userImage.image = self.users[self.currentMember].photo
                self.currentUserName = self.users[self.currentMember].firstName
                self.instructionsLabel.text = "Choose daily and weekly job assignments for \(self.users[self.currentMember].firstName)."
                self.navigationItem.title = self.users[self.currentMember].firstName
                self.dailyJobsMax = 3
                self.weeklyJobsMax = 2
                self.jobsTableView.reloadData()
            } else {
                
                // ---------------------------------------------------------
                // if next user has NO jobs assigned, show their intro popup
                // ---------------------------------------------------------
                
                self.performSegue(withIdentifier: "UserIntroPopup", sender: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.userImage.image = self.users[self.currentMember].photo
                    self.currentUserName = self.users[self.currentMember].firstName
                    self.instructionsLabel.text = "Choose daily and weekly job assignments for \(self.users[self.currentMember].firstName)."
                    self.navigationItem.title = self.users[self.currentMember].firstName
                    self.dailyJobsMax = 3
                    self.weeklyJobsMax = 2
                    self.jobsTableView.reloadData()
                }
            }
        }
    }
    
    func determineGender() -> (he_she: String, him_her: String, his_her: String) {
        var he_she: String!
        var him_her: String!
        var his_her: String!
        if users[currentMember].gender == "male" {
            he_she = "He"
            him_her = "Him"
            his_her = "His"
        } else {
            he_she = "She"
            him_her = "Her"
            his_her = "Her"
        }
        return (he_she, him_her, his_her)
    }
    
    // old functions for later use
    func calculateAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyyMMdd"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calculatedAge = calendar.components(.year, from: birthdayDate!, to: now as Date, options: [])
        let age = calculatedAge.year
        return age!
    }
    
    func determineAgeAppropriateJobs() -> String {
        let age = calculateAge(birthday: "\(users[currentMember].birthday)")
        if age < 4 {
            return "Age appropriate jobs can include:\n\ndaily jobs:\n\n• straighten living room\n• clean bedroom\n\nweekly jobs:\n\n• sweep porch\n• clean backyard\n• weed garden & yard"
        } else if age < 6 {
            return "Age appropriate jobs can include:\n\ndaily jobs:\n\n• straighten living room\n• clean bedroom\n• clear & wipe table\n• sweep floors & vacuum rugs\n• feed pet\n• take out garbage\n\nweekly jobs:\n\n• sweep porch\n• clean backyard\n• weed garden & yard\n• wash windows"
        } else if age < 18 {
            return "\(determineGender().he_she) is old enough that all jobs would be appropriate to assign.\n\nIn addition to the regular jobs of basic cleaning and straightening up, \(determineGender().he_she.lowercased()) can also user power tools like the lawnmower or edger."
        } else if users[currentMember].childParent == "parent" {
            return "\(determineGender().he_she) chores not assigned to children must be assigned to parents.\n\nIn the next step, \(users[currentMember].firstName) will get the chance to assign \(determineGender().him_her.lowercased())self a couple additional duties that only parents can do."
        } else {
            return "nothing to see here"
        }
    }
    
    // ---------------------------------------------
    // Old function that took forever to figure out:
    // ---------------------------------------------
    
    var selectedJobs = [IndexPath]()        // for storing user selected cells
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

    
}






