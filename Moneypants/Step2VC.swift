import UIKit
import Firebase

class Step2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var addMemberButton: UIButton!
    
    var firebaseUser: User!
    var firebaseStorage: Storage!
    var ref: DatabaseReference!
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "users"
        
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.tableFooterView = UIView()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(activityIndicator)
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = Auth.auth().currentUser
        firebaseStorage = Storage.storage()
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(editButtonTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        usersTableView.reloadData()
    }
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MPUser.usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step2Cell
        cell.myLabel.text = MPUser.usersArray[indexPath.row].firstName
        cell.userImage.image = MPUser.usersArray[indexPath.row].photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteUserConfirmationAlert(tableViewIndexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditUser", sender: MPUser.usersArray[indexPath.row])
    }
    
    // ----------
    // Navigation
    // ----------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUser" {
            let nextContoller = segue.destination as! Step2UsersVC
            
            // 'sender' is retrieved from 'didSelectRow' function above
            nextContoller.user = sender as? MPUser
            nextContoller.navBarTitle = "edit user"
        } else if segue.identifier == "AddUser" {
            let nextController = segue.destination as! Step2UsersVC
            // send users array over to Step2UsersVC to check for name duplicates
            nextController.navBarTitle = "add user"
        } else if segue.identifier == "GoToStep3" {
//            print("on to step 3!")
        } else {
//            print("segue from Step 2 initiated")
        }
    }
    
    @IBAction func unwindToStep2VC(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as! Step2UsersVC
        let updatedUser = sourceVC.user
        if let selectedIndexPath = usersTableView.indexPathForSelectedRow {
            // Update an existing user
            MPUser.usersArray[selectedIndexPath.row] = updatedUser!
            MPUser.usersArray.sort(by: {$0.birthday < $1.birthday})       // resort array before displaying tableview data
            usersTableView.reloadData()
            saveUsersToFirebase()
        } else {
            // Add a new user
            let newIndexPath = IndexPath(row: MPUser.usersArray.count, section: 0)
            MPUser.usersArray.append(updatedUser!)
            usersTableView.insertRows(at: [newIndexPath], with: .automatic)
            MPUser.usersArray.sort(by: {$0.birthday < $1.birthday})       // resort array before displaying tableview data
            usersTableView.reloadData()
            saveUsersToFirebase()
            
            // create income array item for them (with value of zero)
            let newUserIncome = Income(user: (updatedUser?.firstName)!, currentPoints: 0)
            Income.currentIncomeArray.append(newUserIncome)
        }
    }
    
    @IBAction func addMemberButtonTapped(_ sender: UIButton) {
        usersTableView.setEditing(false, animated: true)
        if MPUser.usersArray.count >= 20 {
            createAlert(alertTitle: "Users", alertMessage: "You have reached your maximum number of users (20).")
        } else {
            performSegue(withIdentifier: "AddUser", sender: self)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        usersTableView.setEditing(false, animated: true)
        // check for at least two users
        if MPUser.usersArray.count < 2 {
            createAlert(alertTitle: "Users", alertMessage: "You have not created enough users. Please enter in at least two users.")
        } else {
            // check for at least one parent
            if numberOfParents() < 1 {
                createAlert(alertTitle: "Users", alertMessage: "You must have at least one parent. Please enter in a parent.")
            } else {
                performSegue(withIdentifier: "GoToStep3", sender: self)
                if FamilyData.setupProgress <= 2 {
                    FamilyData.setupProgress = 2
                    ref.updateChildValues(["setupProgress" : 2])
                }
            }
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func saveUsersToFirebase() {
        for user in MPUser.usersArray {
            self.ref?.child("members").child(user.firstName).updateChildValues(["firstName" : user.firstName,
                                                                                "birthday" : user.birthday,
                                                                                "passcode" : user.passcode,
                                                                                "gender" : user.gender,
                                                                                "childParent" : user.childParent])
            
            let storageRef = Storage.storage().reference().child("users").child(firebaseUser.uid).child("members").child(user.firstName)
            let profileImg = user.photo
            let imageData = UIImageJPEGRepresentation(profileImg, 0.1)      // compress photos
            storageRef.putData(imageData!, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                // get Firebase image location and return the URL as a string
                let profileImageUrl = (metadata?.downloadURL()?.absoluteString)!
                // save user data to Firebase
                self.ref?.child("members").child(user.firstName).updateChildValues(["profileImageUrl" : profileImageUrl])
            })
        }
    }
    
    func editButtonTapped() {
        if cellStyleForEditing == .none {
            cellStyleForEditing = .delete
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(editButtonTapped))
        } else {
            cellStyleForEditing = .none
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(editButtonTapped))
        }
        usersTableView.setEditing(cellStyleForEditing != .none, animated: true)
    }
    
    var gender: String!
    
    func deleteUserConfirmationAlert(tableViewIndexPath: IndexPath) {
        if MPUser.usersArray[tableViewIndexPath.row].gender == "male" {
            gender = "his"
        } else {
            gender = "her"
        }
        // create alert for user to confirm user deletion
        let alert = UIAlertController(title: "Delete User", message: "Are you sure you want to delete \(MPUser.usersArray[tableViewIndexPath.row].firstName)? This will remove all of \(gender!) saved information and cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            
            // remove user from Firebase
            self.ref.child("members").child(MPUser.usersArray[tableViewIndexPath.row].firstName).removeValue()
            // remove all users's daily job assignments from Firebase
            self.ref.child("dailyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: MPUser.usersArray[tableViewIndexPath.row].firstName).observe(.childAdded, with: { (snapshot) in
                snapshot.ref.updateChildValues(["assigned" : "none"])
            })
            // remove all user's weekly job assignments from Firebase
            self.ref.child("weeklyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: MPUser.usersArray[tableViewIndexPath.row].firstName).observe(.childAdded, with: { (snapshot) in
                snapshot.ref.updateChildValues(["assigned" : "none"])
            })
            // remove all user's daily and weekly job assignments from local array
            let deletedUser = MPUser.usersArray[tableViewIndexPath.row].firstName
            for (index, job) in JobsAndHabits.finalDailyJobsArray.enumerated() {
                if job.assigned == deletedUser {
                    JobsAndHabits.finalDailyJobsArray[index].assigned = "none"
                }
            }
            for (index, job) in JobsAndHabits.finalWeeklyJobsArray.enumerated() {
                if job.assigned == deletedUser {
                    JobsAndHabits.finalWeeklyJobsArray[index].assigned = "none"
                }
            }
            
            
            // MARK: TODO - need to check if user is a parent, and if so, remove their parental assignments from Firebase and from local array
            self.ref.queryOrdered(byChild: "inspectionParent").queryEqual(toValue: MPUser.usersArray[tableViewIndexPath.row].firstName).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                snapshot.ref.updateChildValues(["inspectionParent" : "none"])
            })
            self.ref.queryOrdered(byChild: "paydayParent").queryEqual(toValue: MPUser.usersArray[tableViewIndexPath.row].firstName).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                snapshot.ref.updateChildValues(["paydayParent" : "none"])
            })
            
            
            
            
            
            
            
            
            
            
            
            // ...remove user from local array
            MPUser.usersArray.remove(at: tableViewIndexPath.row)
            self.usersTableView.deleteRows(at: [tableViewIndexPath], with: .fade)
            
            
            
            
            
            
            
            
            
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.usersTableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func numberOfParents() -> Int {
        var parentCount = 0
        for user in MPUser.usersArray {
            if user.childParent == "parent" {
                parentCount += 1
            }
        }
        return parentCount
    }
    
    func createAlert(alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    deinit {
        ref.child("dailyJobs").removeAllObservers()
        ref.child("weeklyJobs").removeAllObservers()
        ref.child("members").removeAllObservers()
        ref.child("paydayAndInspections").child("inspectionParent").removeAllObservers()
        ref.child("paydayAndInspections").child("paydayParent").removeAllObservers()
        for user in MPUser.usersArray {
            self.ref.child("members").child(user.firstName).removeAllObservers()
        }
    }
}





