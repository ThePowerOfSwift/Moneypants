import UIKit
import Firebase

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MPUser.usersArray.sort(by: {$0.birthday < $1.birthday})       // sort array with oldest users first

        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        checkForIncome()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MPUser.usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailCell", for: indexPath) as! HomeCustomCell
        cell.userName.text = MPUser.usersArray[indexPath.row].firstName
        cell.userImage.image = MPUser.usersArray[indexPath.row].photo
        
        // WORKS but with odd delay on tableview refresh
        let currentUser = Income.currentIncomeArray.filter({ $0.user == cell.userName.text })
        cell.userIncome.text = "$\(String(format: "%.2f", Double(currentUser[0].currentPoints) / 100))"
        // END WORKS but with odd delay
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MPUser.currentUser = indexPath.row
        performSegue(withIdentifier: "DetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func printIncomeButtonTapped(_ sender: UIBarButtonItem) {
        print("\nINCOME:\n\n",Income.currentIncomeArray)
    }
    
    @IBAction func printPointsButtonTapped(_ sender: UIBarButtonItem) {
        print("\nPOINTS:\n\n",Points.pointsArray)
    }
    
    // ---------
    // functions
    // ---------
    
    func checkForIncome() {
        for user in MPUser.usersArray {
            let isoArray = Income.currentIncomeArray.filter({ $0.user == user.firstName })
            if isoArray.isEmpty {
                let newUser = Income(user: user.firstName, currentPoints: 0)
                Income.currentIncomeArray.append(newUser)
            } else {
                print("\(user.firstName) already has income")
            }
        }
    }
}







