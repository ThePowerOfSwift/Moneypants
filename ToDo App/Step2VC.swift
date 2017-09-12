import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class Step2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var users = [User]()        // create variable called 'users' which is an array of type User
    var userList: [String] = []

    var firebaseUser: FIRUser!
    var firebaseStorage: FIRStorage!
    
    
    // ----------
    // ATTEMPT #2
    // ----------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        firebaseUser = FIRAuth.auth()?.currentUser
        firebaseStorage = FIRStorage.storage()
        
        loadUsers()
    }
    
    func loadUsers() {
        FIRDatabase.database().reference().child("users").child(firebaseUser.uid).child("members").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            if let dict = snapshot.value as? [String : Any] {
                let userPhotoUrl = dict["profileImageUrl"] as! String
                let userFirstName = dict["firstName"] as! String
                let userBirthday = dict["birthday"] as! String
                let userPasscode = dict["passcode"] as! Int
                let userGender = dict["gender"] as! String
                let isUserChildOrParent = dict["childParent"] as! String
                
                let storageRef = FIRStorage.storage().reference(forURL: userPhotoUrl)
                storageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
                    let pic = UIImage(data: data!)
                    let user = User(profilePhoto: pic!, userFirstName: userFirstName, userBirthday: userBirthday, userPasscode: userPasscode, userGender: userGender, isUserChildOrParent: isUserChildOrParent)
                    self.users.append(user)
                    
                    self.tableView.reloadData()
                })
                
                
            }
        }
    }
    
    
    // ----------
    // Table View
    // ----------
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step2Cell
        cell.myLabel.text = users[indexPath.row].firstName
        cell.myImage.image = users[indexPath.row].photo
        return cell
    }

   
    // ------------------
    // MARK: - Navigation
    // ------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "addUser" {
            print("addUserSegue")
        } else if segue.identifier == "ShowDetail" {
            let userDetailViewController = segue.destination as? Step2UsersVC
            let selectedUserCell = sender as? Step2Cell
            let indexPath = tableView.indexPath(for: selectedUserCell!)
            let selectedUser = users[(indexPath?.row)!]
            userDetailViewController?.user = selectedUser
        }
    }
    
    
    // MARK: Actions
    @IBAction func unwindToUserList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? Step2UsersVC, let user = sourceViewController.user {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing user.
                users[selectedIndexPath.row] = user
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new user.
                let newIndexPath = IndexPath(row: users.count, section: 0)
                
                users.append(user)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
