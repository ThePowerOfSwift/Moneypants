import UIKit
import Firebase

class Step2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var users = [User]()        // create variable called 'users' which is an array of type User (which is a class we created)
    
    var firebaseUser: FIRUser!
    var firebaseStorage: FIRStorage!
    var ref: FIRDatabaseReference!
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "users"
        
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.tableFooterView = UIView()
        
        // --------
        // Firebase
        // --------
        
        firebaseUser = FIRAuth.auth()?.currentUser
        firebaseStorage = FIRStorage.storage()
        ref = FIRDatabase.database().reference().child("users").child(firebaseUser.uid)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(editButtonTapped))
        
        loadExistingUsers()     // check to see if there are existing users, and if so, load them into tableview
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        usersTableView.reloadData()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        ref.child("members").removeAllObservers()
//    }
    
    
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step2Cell
        cell.myLabel.text = users[indexPath.row].firstName
        cell.userImage.image = users[indexPath.row].photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteUserConfirmationAlert(tableViewIndexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditUser", sender: users[indexPath.row])
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
            nextController.users = users
            nextController.navBarTitle = "add user"
        } else if segue.identifier == "GoToStep3" {
            print("on to step 3!")
        } else {
            print("segue from Step 2 initiated")
        }
    }
    
    @IBAction func unwindToStep2VC(sender: UIStoryboardSegue) {
        let sourceVC = sender.source as! Step2UsersVC
        let updatedUser = sourceVC.user
        if let selectedIndexPath = usersTableView.indexPathForSelectedRow {
            // Update an existing user
            users[selectedIndexPath.row] = updatedUser!
            usersTableView.reloadData()
        } else {
            // Add a new user
            let newIndexPath = IndexPath(row: users.count, section: 0)
            users.append(updatedUser!)
            usersTableView.insertRows(at: [newIndexPath], with: .automatic)
            users.sort(by: {$0.birthday < $1.birthday})
            usersTableView.reloadData()
        }
    }
    
    @IBAction func addMemberButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "AddUser", sender: self)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // check for at least two users
        if users.count < 2 {
            createAlert(alertTitle: "Users", alertMessage: "You have not created enough users. Please enter in at least two users.")
        } else {
            // check for at least one parent
            if numberOfParents() < 1 {
                createAlert(alertTitle: "Users", alertMessage: "You must have at least one parent. Please enter in a parent.")
            } else {
                saveUsersToFirebase()
                performSegue(withIdentifier: "GoToStep3", sender: self)
            }
        }
        ref.removeAllObservers()
    }
    
    
    // ---------
    // Functions
    // ---------
    
    // if users exist on Firebase, load them
    func loadExistingUsers() {
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
                    
                    self.usersTableView.reloadData()
                })
            }
        }
    }
    
    func saveUsersToFirebase() {
        for user in users {
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
                self.ref?.child("members").child(user.firstName).setValue(["profileImageUrl" : profileImageUrl,
                                                                           "firstName" : user.firstName,
                                                                           "birthday" : user.birthday,
                                                                           "passcode" : user.passcode,
                                                                           "gender" : user.gender,
                                                                           "childParent" : user.childParent])
            })
        }
        ref.child("members").removeAllObservers()
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
    
    func deleteUserConfirmationAlert(tableViewIndexPath: IndexPath) {
        // create alert for user to confirm user deletion
        let alert = UIAlertController(title: "Delete User", message: "Are you sure you want to delete \(users[tableViewIndexPath.row].firstName)? This cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            // remove user from Firebase
            self.ref.child("members").child(self.users[tableViewIndexPath.row].firstName).removeValue()
            self.users.remove(at: tableViewIndexPath.row)
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
        for user in users {
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
}





