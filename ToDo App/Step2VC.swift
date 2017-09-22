import UIKit
import Firebase

class Step2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var users = [User]()        // create variable called 'users' which is an array of type User (which is a class we created)
    
    var firebaseUser: FIRUser!
    var firebaseStorage: FIRStorage!
    var ref: FIRDatabaseReference!
    
    var cellStyleForEditing: UITableViewCellEditingStyle = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
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
        tableView.reloadData()
    }
    
    func loadExistingUsers() {
//        ref.child("members").queryOrdered(byChild: "firstName").observe(.childAdded) { (snapshot) in
        
        ref.child("members").observe(.childAdded) { (snapshot: FIRDataSnapshot) in
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
                    let user = User(profilePhoto: pic!,
                                    userFirstName: userFirstName,
                                    userBirthday: userBirthday,
                                    userPasscode: userPasscode,
                                    userGender: userGender,
                                    isUserChildOrParent: isUserChildOrParent)
                    self.users.append(user)
                    self.users.sort(by: {$0.birthday < $1.birthday})
                    
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    
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
//            print(users[indexPath.row].firstName)
            FIRDatabase.database().reference().child("users").child(firebaseUser.uid).child("members").child(users[indexPath.row].firstName).removeValue()
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    func editButtonTapped() {
        if cellStyleForEditing == .none {
            cellStyleForEditing = .delete
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(editButtonTapped))
        } else {
            cellStyleForEditing = .none
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "edit", style: .plain, target: self, action: #selector(editButtonTapped))
        }
        tableView.setEditing(cellStyleForEditing != .none, animated: true)
    }

}





