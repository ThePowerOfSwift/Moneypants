import UIKit
import Firebase

class Step2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var addMemberButton: UIButton!
    
    var firebaseUser: FIRUser!
    var firebaseStorage: FIRStorage!
    var ref: FIRDatabaseReference!
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finalUsersArray.sort(by: {$0.birthday < $1.birthday})       // sort users by birthday in descending order
        
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
        
        firebaseUser = FIRAuth.auth()?.currentUser
        firebaseStorage = FIRStorage.storage()
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
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
        return finalUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step2Cell
        cell.myLabel.text = finalUsersArray[indexPath.row].firstName
        cell.userImage.image = finalUsersArray[indexPath.row].photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteUserConfirmationAlert(tableViewIndexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditUser", sender: finalUsersArray[indexPath.row])
    }
    
    
    // ----------
    // Navigation
    // ----------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditUser" {
            let nextContoller = segue.destination as! Step2UsersVC
            
            // 'sender' is retrieved from 'didSelectRow' function above
            nextContoller.user = sender as? User
            nextContoller.navBarTitle = "edit user"
        } else if segue.identifier == "AddUser" {
            let nextController = segue.destination as! Step2UsersVC
            // send users array over to Step2UsersVC to check for name duplicates
            nextController.users = finalUsersArray
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
            finalUsersArray[selectedIndexPath.row] = updatedUser!
            finalUsersArray.sort(by: {$0.birthday < $1.birthday})
            usersTableView.reloadData()
            saveUsersToFirebase()
        } else {
            // Add a new user
            let newIndexPath = IndexPath(row: finalUsersArray.count, section: 0)
            finalUsersArray.append(updatedUser!)
            usersTableView.insertRows(at: [newIndexPath], with: .automatic)
            finalUsersArray.sort(by: {$0.birthday < $1.birthday})
            usersTableView.reloadData()
            saveUsersToFirebase()
        }
    }
    
    @IBAction func addMemberButtonTapped(_ sender: UIButton) {
        usersTableView.setEditing(false, animated: true)
        if finalUsersArray.count >= 20 {
            createAlert(alertTitle: "Users", alertMessage: "You have reached your maximum number of users (20).")
        } else {
            performSegue(withIdentifier: "AddUser", sender: self)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        usersTableView.setEditing(false, animated: true)
        // check for at least two users
        if finalUsersArray.count < 2 {
            createAlert(alertTitle: "Users", alertMessage: "You have not created enough users. Please enter in at least two users.")
        } else {
            // check for at least one parent
            if numberOfParents() < 1 {
                createAlert(alertTitle: "Users", alertMessage: "You must have at least one parent. Please enter in a parent.")
            } else {
//                saveUsersToFirebase()
                performSegue(withIdentifier: "GoToStep3", sender: self)
            }
        }
    }
    
    
    // ---------
    // Functions
    // ---------
    
    func saveUsersToFirebase() {
        for user in finalUsersArray {
            self.ref?.child("members").child(user.firstName).updateChildValues(["firstName" : user.firstName,
                                                                                "birthday" : user.birthday,
                                                                                "passcode" : user.passcode,
                                                                                "gender" : user.gender,
                                                                                "childParent" : user.childParent])
            
            
            let storageRef = FIRStorage.storage().reference().child("users").child(firebaseUser.uid).child("members").child(user.firstName)
            let profileImg = user.photo
            let imageData = UIImageJPEGRepresentation(profileImg, 0.1)      // compress photos
            storageRef.put(imageData!, metadata: nil, completion: { (metadata, error) in
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
        if finalUsersArray[tableViewIndexPath.row].gender == "male" {
            gender = "his"
        } else {
            gender = "her"
        }
        // create alert for user to confirm user deletion
        let alert = UIAlertController(title: "Delete User", message: "Are you sure you want to delete \(finalUsersArray[tableViewIndexPath.row].firstName)? This will remove all of \(gender!) saved information and cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            // remove user from Firebase
            self.ref.child("members").child(finalUsersArray[tableViewIndexPath.row].firstName).removeValue()
            self.ref.child("dailyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: finalUsersArray[tableViewIndexPath.row].firstName).observe(.childAdded, with: { (snapshot) in
                snapshot.ref.updateChildValues(["assigned" : "none"])
            })
            
            self.ref.child("weeklyJobs").queryOrdered(byChild: "assigned").queryEqual(toValue: finalUsersArray[tableViewIndexPath.row].firstName).observe(.childAdded, with: { (snapshot) in
                snapshot.ref.updateChildValues(["assigned" : "none"])
            })
            finalUsersArray.remove(at: tableViewIndexPath.row)
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
        for user in finalUsersArray {
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
        for user in finalUsersArray {
            self.ref.child("members").child(user.firstName).removeAllObservers()
        }
    }
}





