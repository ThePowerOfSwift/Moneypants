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
        
//        Points.pointsArray = [Moneypants.Points(user: "Father", itemName: "habit bonus", itemCategory: "daily habits", code: "B", valuePerTap: 0, itemDate: 1512073689.087625), Moneypants.Points(user: "Father", itemName: "habit bonus", itemCategory: "daily habits", code: "B", valuePerTap: 0, itemDate: 1511728096.253648), Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511728098.289304), Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511641699.1189201), Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511555299.9187191), Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "E", valuePerTap: -71, itemDate: 1511468900.357163), Moneypants.Points(user: "Mother", itemName: "feed pet / garbage (sub)", itemCategory: "other jobs", code: "S", valuePerTap: 125, itemDate: 1511468900.357163), Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511382507.4392161), Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511296108.255002), Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511209709.4551439), Moneypants.Points(user: "Father", itemName: "good language", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511209709.9601619), Moneypants.Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511209710.3196321), Moneypants.Points(user: "Father", itemName: "good language", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511296111.9512661), Moneypants.Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511296112.4152179), Moneypants.Points(user: "Father", itemName: "good language", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511382513.9271021), Moneypants.Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511382514.183821), Moneypants.Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511382514.479625), Moneypants.Points(user: "Father", itemName: "good language", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511468916.0149989), Moneypants.Points(user: "Father", itemName: "journal", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511468916.503978), Moneypants.Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511468917.367306), Moneypants.Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511555319.143285), Moneypants.Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511641722.7275071), Moneypants.Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511641723.07932), Moneypants.Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511728124.6152501), Moneypants.Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511728124.9946241), Moneypants.Points(user: "Father", itemName: "journal", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511728125.4083319), Moneypants.Points(user: "Father", itemName: "1-on-1 time with kid", itemCategory: "daily habits", code: "N", valuePerTap: 0, itemDate: 1511728125.4083319), Moneypants.Points(user: "Father", itemName: "wash car", itemCategory: "weekly jobs", code: "C", valuePerTap: 302, itemDate: 1511641732.4749169)]
//        
//        Income.currentIncomeArray = [Moneypants.Income(user: "Father", currentPoints: 723), Moneypants.Income(user: "Mother", currentPoints: 125), Moneypants.Income(user: "Allan", currentPoints: 0), Moneypants.Income(user: "Sophie", currentPoints: 0), Moneypants.Income(user: "Savannah", currentPoints: 0), Moneypants.Income(user: "Flower", currentPoints: 0)]
        
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







