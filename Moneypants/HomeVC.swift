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
        checkForIncome()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        tableView.beginUpdates()
        tableView.setEditing(false, animated: false)
        tableView.reloadData()
        tableView.endUpdates()
        
//        var count = 0
//        for n in 0..<MPUser.usersArray.count {
//            tableView.reloadRows(at: [(0, count) as! IndexPath], with: .automatic)
//            count += 1
//        }
        //        tableView.reloadSections([0], with: .automatic)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        tableView.setEditing(false, animated: false)
//        tableView.reloadData()
//    }
    
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
        cell.paidBadge.isHidden = true
        
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let paydayAction = UITableViewRowAction(style: .default, title: "             ") { (action, indexPath) in
            MPUser.currentUser = indexPath.row
            self.performSegue(withIdentifier: "PaydayDetail", sender: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                tableView.setEditing(false, animated: true)
            }
        }
        
        paydayAction.backgroundColor = UIColor(patternImage: UIImage(named: "payday")!)
        
        return [paydayAction]
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







