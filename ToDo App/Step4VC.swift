import UIKit
import Firebase

class Step4VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var jobsTableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var selectUsersButton: UIButton!
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var firebaseUser: FIRUser!
    var ref: FIRDatabaseReference!
    
    var currentMember = 0           // used for cycling through users when 'next' button is tapped
    var currentUserName: String!

    var dailyJobsMax = 3                  // max number of daily jobs allowed
    var weeklyJobsMax = 2                 // max number of weekly jobs allowed
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImage.layer.cornerRadius = userImage.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.black.cgColor
        
        User.finalUsersArray.sort(by: {$0.birthday > $1.birthday})       // sort users by birthday with youngest first
        
        currentUserName = ""
        instructionsLabel.text = ""
        selectUsersButton.isHidden = true
        
        jobsTableView.delegate = self
        jobsTableView.dataSource = self
        jobsTableView.tableFooterView = UIView()
        
        firebaseUser = FIRAuth.auth()?.currentUser
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        checkSetupNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        User.finalUsersArray.sort(by: {$0.birthday > $1.birthday})       // sort users by birthday with youngest first
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
            return JobsAndHabits.finalDailyJobsArray.count
        } else {
            return JobsAndHabits.finalWeeklyJobsArray.count
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
            
            if JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned != "none" {        // 1. check if array has selected job at current location...
                if JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned == currentUserName {      // 2. ...and if it is current user...
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")        // 3. ...then show white/green checkmark, black text, job name
                    cell.jobLabel.textColor = UIColor.black
                    cell.jobLabel.text = JobsAndHabits.finalDailyJobsArray[indexPath.row].name
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark gray")         // 4. ...otherwise show gray checkmark, gray text, assigned name
                    cell.jobLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
                    cell.jobLabel.text = JobsAndHabits.finalDailyJobsArray[indexPath.row].name + " (\(JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned))"
                }
            } else {
                cell.selectionBoxImageView.image = UIImage(named: "blank")          // 5. if job isn't selected, show blank box, black text, job name
                cell.jobLabel.textColor = UIColor.black
                cell.jobLabel.text = JobsAndHabits.finalDailyJobsArray[indexPath.row].name
            }
            
        // -----------
        // WEEKLY JOBS
        // -----------
            
        } else if indexPath.section == 1 {
            
            if JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned != "none" {        // 1. check if array has selected job at current location...
                if JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned == currentUserName {      // 2. ...and if it is current user...
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark white")        // 3. ...then show white/green checkmark and black text
                    cell.jobLabel.textColor = UIColor.black
                    cell.jobLabel.text = JobsAndHabits.finalWeeklyJobsArray[indexPath.row].name
                } else {
                    cell.selectionBoxImageView.image = UIImage(named: "checkmark gray")         // 4. ...otherwise show gray checkmark and gray text
                    cell.jobLabel.textColor = UIColor(white: 0.8, alpha: 1.0)
                    cell.jobLabel.text = JobsAndHabits.finalWeeklyJobsArray[indexPath.row].name + " (\(JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned))"
                }
            } else {
                cell.selectionBoxImageView.image = UIImage(named: "blank")          // 5. if job isn't selected, show blank box with black text
                cell.jobLabel.textColor = UIColor.black
                cell.jobLabel.text = JobsAndHabits.finalWeeklyJobsArray[indexPath.row].name
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
            JobsAndHabits.finalDailyJobsArray[indexPathRow].assigned = "none"     // update local array
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
            
            if JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned == currentUserName {
                JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned = "none"     // update local array
                self.jobsTableView.reloadData()
                // find job's order at the tableview's index path (query), then update its 'assigned' property to be 'none'
                ref.child("dailyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : "none"])
                })
                
                // ----------------------------------------
                // ...then check if the job is available...
                // ----------------------------------------
                
            } else if JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned == "none" {
                JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned = self.currentUserName      // update local array
                var selectedDailyJobsCount = 0
                for job in JobsAndHabits.finalDailyJobsArray {
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
                            JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned = "none"
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
                let alert = UIAlertController(title: "Job Selection", message: "The job you selected (\(JobsAndHabits.finalDailyJobsArray[indexPath.row].name)) is already assigned to \(JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned).\n\nDo you want to reassign it to \(User.finalUsersArray[currentMember].firstName) instead?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "reassign", style: .default, handler: { (action) in
                    
                    // check for number of currently assigned jobs for user
                    var selectedDailyJobsCount = 1      // currently selected job counts as 1 job even tho it hasn't been assigned yet...
                    for job in JobsAndHabits.finalDailyJobsArray {
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
                            JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned = User.finalUsersArray[self.currentMember].firstName
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
                        
                        JobsAndHabits.finalDailyJobsArray[indexPath.row].assigned = User.finalUsersArray[self.currentMember].firstName
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
            
            if JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned == currentUserName {
                JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned = "none"     // update local array
                self.jobsTableView.reloadData()
                // find job's order at the tableview's index path (query), then update its 'assigned' property to be 'none'
                ref.child("weeklyJobs").queryOrdered(byChild: "order").queryEqual(toValue: indexPath.row).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    snapshot.ref.updateChildValues(["assigned" : "none"])
                })
                
                // ----------------------------------------
                // ...then check if the job is available...
                // ----------------------------------------
                
            } else if JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned == "none" {
                JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned = self.currentUserName      // update local array
                var weeklyJobsCount = 0
                for job in JobsAndHabits.finalWeeklyJobsArray {
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
                            JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned = "none"
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
                let alert = UIAlertController(title: "Job Selection", message: "The job you selected (\(JobsAndHabits.finalWeeklyJobsArray[indexPath.row].name)) is already assigned to \(JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned).\n\nDo you want to reassign it to \(User.finalUsersArray[currentMember].firstName) instead?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }))
                alert.addAction(UIAlertAction(title: "reassign", style: .default, handler: { (action) in
                    
                    // check for number of currently assigned jobs for user
                    var selectedWeeklyJobsCount = 1      // currently selected job counts as 1 job even tho it hasn't been assigned yet...
                    for job in JobsAndHabits.finalWeeklyJobsArray {
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
                            JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned = User.finalUsersArray[self.currentMember].firstName
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
                        
                        JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned = User.finalUsersArray[self.currentMember].firstName
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
            nextViewContoller.popupImage = User.finalUsersArray[currentMember].photo
            nextViewContoller.mainLabelText = User.finalUsersArray[currentMember].firstName
            let age = calculateAge(birthday: "\(User.finalUsersArray[currentMember].birthday)")
            // determine if current user is child or parent
            if User.finalUsersArray[currentMember].childParent == "parent" {
                nextViewContoller.bodyLabelText = "\(User.finalUsersArray[currentMember].firstName) should assign \(determineGender().him_her.lowercased())self any jobs that were not assigned to the children. \(determineGender().he_she) can split the remaining jobs with \(determineGender().his_her.lowercased()) spouse.\n\nIn the next step, \(User.finalUsersArray[currentMember].firstName) will get the chance to assign \(determineGender().him_her.lowercased())self a couple additional duties that only parents can do."
                nextViewContoller.watchVideoButtonHiddenStatus = true
                nextViewContoller.watchVideoButtonHeightValue = 0
            } else {
                nextViewContoller.bodyLabelText = "Choose daily and weekly job assignments for \(User.finalUsersArray[currentMember].firstName), who is \(age) years old. For ideas on which jobs to select for \(determineGender().him_her.lowercased()), tap below to see a list of possible age-appropriate jobs."
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if FamilyData.setupProgress <= 40 {
            FamilyData.setupProgress = 40
            ref.updateChildValues(["setupProgress" : 40])
        }
        
        if selectUsersButton.isHidden == false {
            // user has already cycled through all users and made assignments. now still need to check for daily and weekly assignments
            reviewFamilyJobs()
        } else {
            // perform query on daily jobs to see how many jobs current user has assigned
            let userJobsList = JobsAndHabits.finalDailyJobsArray.filter({ return $0.assigned == User.finalUsersArray[self.currentMember].firstName })
            
            // -------------------------------------------------
            // 1. does current user have at least one DAILY job?
            // -------------------------------------------------
            
            // 1A. user has ZERO daily jobs assigned
            if userJobsList.count == 0 {
                self.zeroDailyJobsAssignedAlert()
                
                // 1B. user has at least one daily jobs assigned
            } else if userJobsList.count != 0 {
                
                // --------------------------------------------------
                // 2. does current user have at least one WEEKLY job?
                // --------------------------------------------------
                
                let userJobsList2 = JobsAndHabits.finalWeeklyJobsArray.filter({ return $0.assigned == User.finalUsersArray[self.currentMember].firstName })
                
                // 2A. user has ZERO weekly jobs assigned
                if userJobsList2.count == 0 {
                    let alert = UIAlertController(title: "Not Enough Jobs", message: "You have not chosen any weekly jobs for \(User.finalUsersArray[self.currentMember].firstName). Are you sure you want to continue?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        
                        // -------------------------------------------
                        // 3. is current user oldest member of family?
                        // -------------------------------------------
                        
                        // 3A. user is NOT oldest member of family
                        if self.currentMember != (User.finalUsersArray.count - 1) {
                            // 3A-1. go to next user
                            self.presentNextUser()
                            
                            // 3B. user is oldest member of family
                        } else if self.currentMember == (User.finalUsersArray.count - 1) {
                            self.reviewFamilyJobs()
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    
                    // -------------------------------------------
                    // 3. is current user oldest member of family?
                    // -------------------------------------------
                    
                    // current user is oldest member of family
                    if self.currentMember == (User.finalUsersArray.count - 1) {
                        self.reviewFamilyJobs()
                    } else if self.currentMember != (User.finalUsersArray.count - 1) {
                        self.presentNextUser()
                    }
                }
            }
        }
    }

    @IBAction func selectUsersButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select A User", message: "Please choose a family member to review their job assignments.", preferredStyle: .alert)
        for (index, user) in User.finalUsersArray.enumerated() {
            alert.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                self.currentMember = index
                self.userImage.image = User.finalUsersArray[self.currentMember].photo
                self.currentUserName = User.finalUsersArray[self.currentMember].firstName
                self.instructionsLabel.text = "Choose daily and weekly job assignments for \(User.finalUsersArray[self.currentMember].firstName)."
                self.navigationItem.title = User.finalUsersArray[self.currentMember].firstName
                self.jobsTableView.reloadData()
                alert.dismiss(animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    // ---------
    // Functions
    // ---------
    
    func checkSetupNumber() {
        if FamilyData.setupProgress >= 40 {
            // first view will be of youngest family member
            self.userImage.image = User.finalUsersArray[0].photo
            self.currentUserName = User.finalUsersArray[0].firstName
            self.instructionsLabel.text = "Choose daily and weekly job assignments for \(User.finalUsersArray[0].firstName)."
            self.navigationItem.title = User.finalUsersArray[0].firstName
            self.jobsTableView.reloadData()
            
            // show 'select user' button so user can review other members' assignments
            self.selectUsersButton.isHidden = false
            
        } else {
            
            // if user hasn't done setup yet, show the overlay
            self.performSegue(withIdentifier: "UserIntroPopup", sender: self)
            self.userImage.image = User.finalUsersArray[0].photo
            self.currentUserName = User.finalUsersArray[0].firstName
            self.instructionsLabel.text = "Choose daily and weekly job assignments for \(User.finalUsersArray[0].firstName)."
            self.navigationItem.title = User.finalUsersArray[0].firstName
            self.jobsTableView.reloadData()
        }
    }
    
    func zeroDailyJobsAssignedAlert() {
        let alert = UIAlertController(title: "Not Enough Jobs", message: "Please assign \(User.finalUsersArray[self.currentMember].firstName) at least one daily job.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reviewFamilyJobs() {
        
        // -------------------------------
        // 4. are all daily jobs assigned?
        // -------------------------------
        
        let unassignedDailyJobs = JobsAndHabits.finalDailyJobsArray.filter({ return $0.assigned == "none" })
        
        // 4A. all daily jobs are NOT assigned
        if unassignedDailyJobs.count > 0 {
            
            let alert = UIAlertController(title: "Unassigned Daily Jobs", message: "Please make sure all the daily jobs are assigned.\n\nIf a job is not going to be assigned, use the 'back' button to return to the job creation page and delete that job.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.selectUsersButton.isHidden = false
            }))
            present(alert, animated: true, completion: nil)
            
        // 4B. all daily job ARE assigned
        } else if unassignedDailyJobs.count == 0 {
            
            // -----------------------------------------------
            // 5. do all users have at least one job assigned?
            // -----------------------------------------------
            
            // 5A. at least one user does NOT have at least one daily job
            if checkIfAllUsersHaveDailyJobs() == false {
                let alert = UIAlertController(title: "Unassigned User", message: "Please assign at least one daily job to the following family members:\n\n\(whatUsersDontHaveJobs().minimalDescription)", preferredStyle: .alert)
                
                
                
                
                
                
                
                
                
                let magicString = "$$1234%^56()78*9££".components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
                print("Magic String:  ",magicString)
                
                
                
                
                
                
                
                
                alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    self.selectUsersButton.isHidden = false
                }))
                present(alert, animated: true, completion: nil)
                
            // 5B. all users have at least one daily job
            } else {
                
                // --------------------------------
                // 6. are all weekly jobs assigned?
                // --------------------------------
                
                let unassignedWeeklyJobs = JobsAndHabits.finalWeeklyJobsArray.filter({ return $0.assigned == "none" })
                
                // 6A. all weekly jobs are NOT assigned
                if unassignedWeeklyJobs.count > 0 {
                    let alert = UIAlertController(title: "Review Family Assignments", message: "Some weekly jobs remain unassigned.\n\nDo you want to go back and assign them, or do you want to leave them unassigned and continue with setup?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "continue", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "PaydayInspections", sender: self)
                    }))
                    alert.addAction(UIAlertAction(title: "assign", style: .cancel, handler: { (action) in
                        self.selectUsersButton.isHidden = false
                        // change 'next' button to allow users to go to next step and not have to cycle through all users again
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    present(alert, animated: true, completion: nil)
                    
                    // 6B. all weekly jobs ARE assigned
                } else if unassignedWeeklyJobs.count == 0 {
                    let alert = UIAlertController(title: "Review Family Assignments", message: "Do you wish to review any assigned habits, or continue with setup?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "review", style: .cancel, handler: { (actions) in
                        self.selectUsersButton.isHidden = false
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "continue", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        self.performSegue(withIdentifier: "PaydayInspections", sender: self)
                        self.selectUsersButton.isHidden = false
                    }))
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    func checkIfAllUsersHaveDailyJobs() -> Bool {
        var tempArray = [String]()
        for job in JobsAndHabits.finalDailyJobsArray {
            for user in User.finalUsersArray {
                if job.assigned == user.firstName {
//                    print(user.firstName,"has the job:",job.assigned)
                    tempArray.append(user.firstName)
                }
            }
        }
        
        for user in User.finalUsersArray {
            if !tempArray.contains(user.firstName) {
                return false
            }
        }
        return true
    }
    
    func whatUsersDontHaveJobs() -> [String] {
        var tempArray = [String]()
        for job in JobsAndHabits.finalDailyJobsArray {
            for user in User.finalUsersArray {
                if job.assigned == user.firstName {
//                    print(user.firstName,"has the job:",job.assigned)
                    tempArray.append(user.firstName)
                }
            }
        }
        
        var missingUser = [String]()
        for user in User.finalUsersArray {
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
        
        // filter jobs list to find how many daily jobs current user has
        let userJobsList = JobsAndHabits.finalDailyJobsArray.filter({ return $0.assigned == User.finalUsersArray[self.currentMember].firstName })
        if userJobsList.count > 0 {
            self.userImage.image = User.finalUsersArray[self.currentMember].photo
            self.currentUserName = User.finalUsersArray[self.currentMember].firstName
            self.instructionsLabel.text = "Choose daily and weekly job assignments for \(User.finalUsersArray[self.currentMember].firstName)."
            self.navigationItem.title = User.finalUsersArray[self.currentMember].firstName
            self.dailyJobsMax = 3
            self.weeklyJobsMax = 2
            self.jobsTableView.reloadData()
        } else {
            
            // ---------------------------------------------------------
            // if next user has NO jobs assigned, show their intro popup
            // ---------------------------------------------------------
            
            self.performSegue(withIdentifier: "UserIntroPopup", sender: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.userImage.image = User.finalUsersArray[self.currentMember].photo
                self.currentUserName = User.finalUsersArray[self.currentMember].firstName
                self.instructionsLabel.text = "Choose daily and weekly job assignments for \(User.finalUsersArray[self.currentMember].firstName)."
                self.navigationItem.title = User.finalUsersArray[self.currentMember].firstName
                self.dailyJobsMax = 3
                self.weeklyJobsMax = 2
                self.jobsTableView.reloadData()
            }
        }
    }

    // MARK: TODO - change all calls of this method in this VC to use the new User.determineGender method
    func determineGender() -> (he_she: String, him_her: String, his_her: String) {
        var he_she: String!
        var him_her: String!
        var his_her: String!
        if User.finalUsersArray[currentMember].gender == "male" {
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
        let age = calculateAge(birthday: "\(User.finalUsersArray[currentMember].birthday)")
        if age < 4 {
            return "Age appropriate jobs can include:\n\ndaily jobs:\n\n• straighten living room\n• clean bedroom\n\nweekly jobs:\n\n• sweep porch\n• clean backyard\n• weed garden & yard"
        } else if age < 6 {
            return "Age appropriate jobs can include:\n\ndaily jobs:\n\n• straighten living room\n• clean bedroom\n• clear & wipe table\n• sweep floors & vacuum rugs\n• feed pet\n• take out garbage\n\nweekly jobs:\n\n• sweep porch\n• clean backyard\n• weed garden & yard\n• wash windows"
        } else if age < 18 {
            return "\(determineGender().he_she) is old enough that all jobs would be appropriate to assign.\n\nIn addition to the regular jobs of basic cleaning and straightening up, \(determineGender().he_she.lowercased()) can also user power tools like the lawnmower or edger."
        } else if User.finalUsersArray[currentMember].childParent == "parent" {
            return "\(determineGender().he_she) jobs not assigned to children must be assigned to parents.\n\nIn the next step, \(User.finalUsersArray[currentMember].firstName) will get the chance to assign \(determineGender().him_her.lowercased())self a couple additional duties that only parents can do."
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
                ref.child("TESTING").child("dailyJob\(index.row)").updateChildValues(["assigned" : JobsAndHabits.finalDailyJobsArray[index.row].name])
                print(JobsAndHabits.finalDailyJobsArray[index.row].name)
            } else {
                ref.child("TESTING").child("weeklyJob\(index.row)").updateChildValues(["assigned" : JobsAndHabits.finalWeeklyJobsArray[index.row].name])
                print(JobsAndHabits.finalWeeklyJobsArray[index.row].name)
            }
        }
    }
    
    // cool unused function, returns two values like this: countJobs().dailyCount
    func countJobs() -> (dailyCount: Int, weeklyCount: Int) {
        var dailyJobsCount = 0
        var weeklyJobsCount = 0
        for job in JobsAndHabits.finalDailyJobsArray {
            if job.assigned == currentUserName {
                dailyJobsCount += 1
            }
        }
        for job in JobsAndHabits.finalWeeklyJobsArray {
            if job.assigned == currentUserName {
                weeklyJobsCount += 1
            }
        }
        return (dailyJobsCount, weeklyJobsCount)
    }

    
}

extension Sequence {
    var minimalDescription: String {
        return map { "\($0)" }.joined(separator: ", ")
    }
}





