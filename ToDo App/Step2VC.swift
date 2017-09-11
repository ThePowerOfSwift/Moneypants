import UIKit

class Step2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var users = [User]()        // create variable called 'users' which is an array of type User
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step2Cell
        let user = users[indexPath.row]
        cell.myImage.image = user.photo
        cell.myLabel.text = user.firstName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
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
        
        
//        switch(segue.identifier ?? "") {
//        case "addUser":
//            print("User added segue")
//        case "ShowDetail":
//            guard let userDetailViewController = segue.destination as? Step2UsersVC else {
//                fatalError("Unexpected destination: \(segue.destination)")
//            }
//            
//            guard let selectedUserCell = sender as? Step2Cell else {
//                fatalError("Unexpected sender: \(sender)")
//            }
//            
//            guard let indexPath = tableView.indexPath(for: selectedUserCell) else {
//                fatalError("The selected cell is not being displayed by the table")
//            }
//            
//            let selectedUser = users[indexPath.row]
//            userDetailViewController.user = selectedUser
//            
//        default:
//            fatalError("Unexpected Segue Identifier: \(segue.identifier)")
//        }
        
        
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
