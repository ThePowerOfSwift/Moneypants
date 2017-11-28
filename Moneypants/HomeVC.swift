import UIKit
import Firebase

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MPUser.usersArray.sort(by: {$0.birthday < $1.birthday})       // sort array with oldest users first

        
        
        
        
        
        
        
        
        // temp arrays for testing
//        Points.pointsArray = [Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511333997.678102),
//                              Points(user: "Father", itemName: "enter your top priority habit here", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511333997.9687519),
//                              Points(user: "Father", itemName: "wash car", itemCategory: "weekly jobs", code: "C", valuePerTap: 302, itemDate: 1511333999.4136181),
//                              Points(user: "Father", itemName: "bad language", itemCategory: "fees", code: "F", valuePerTap: -71, itemDate: 1511395725.283673),
//                              Points(user: "Mother", itemName: "living room", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511413767.8222201),
//                              Points(user: "Mother", itemName: "meal prep", itemCategory: "daily jobs", code: "E", valuePerTap: -35, itemDate: 1511413773.4892831),
//                              Points(user: "Allan", itemName: "meal prep (sub)", itemCategory: "daily jobs", code: "S", valuePerTap: 89, itemDate: 1511413773.4893231)]
//        
//        Income.currentIncomeArray = [Income(user: "Father", currentPoints: 309),
//                                     Income(user: "Mother", currentPoints: 19),
//                                     Income(user: "Allan", currentPoints: 89),
//                                     Income(user: "Sophie", currentPoints: 0),
//                                     Income(user: "Savannah", currentPoints: 0),
//                                     Income(user: "Flower", currentPoints: 0)]
        
//         temp array for testing habit bonus
        Points.pointsArray = [Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647885.722846),
                              Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647886.0822151),
                              Points(user: "Father", itemName: "journal", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647886.4109979),
                              Points(user: "Father", itemName: "1-on-1 time with kid", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647886.7559009),
                              Points(user: "Father", itemName: "practice talent (30 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647887.1063571),
                              Points(user: "Father", itemName: "good deed / service", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647888.402463),
                              Points(user: "Father", itemName: "family prayer & scriptures", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647888.7549281),
                              Points(user: "Father", itemName: "on time to events", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647889.114944),
                              Points(user: "Father", itemName: "read (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511647889.506494),
                              Points(user: "Father", itemName: "enter your top priority habit here", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511561491.9467549),
                              Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561492.3065529),
                              Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561492.6905971),
                              Points(user: "Father", itemName: "journal", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561493.0188999),
                              Points(user: "Father", itemName: "1-on-1 time with kid", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561493.370445),
                              Points(user: "Father", itemName: "practice talent (30 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561493.706208),
                              Points(user: "Father", itemName: "good deed / service", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561494.9703379),
                              Points(user: "Father", itemName: "family prayer & scriptures", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561495.2996531),
                              Points(user: "Father", itemName: "on time to events", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561495.627692),
                              Points(user: "Father", itemName: "read (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511561495.9800229),
                              Points(user: "Father", itemName: "enter your top priority habit here", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511475101.8270481),
                              Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475102.5862741),
                              Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475102.9062419),
                              Points(user: "Father", itemName: "journal", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475103.227443),
                              Points(user: "Father", itemName: "1-on-1 time with kid", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475103.5871649),
                              Points(user: "Father", itemName: "practice talent (30 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475103.9548769),
                              Points(user: "Father", itemName: "good deed / service", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475105.146647),
                              Points(user: "Father", itemName: "family prayer & scriptures", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475105.4754581),
                              Points(user: "Father", itemName: "on time to events", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475105.834533),
                              Points(user: "Father", itemName: "read (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511475106.1710129),
                              Points(user: "Father", itemName: "enter your top priority habit here", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511388711.171706),
                              Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388711.5952151),
                              Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388712.043932),
                              Points(user: "Father", itemName: "journal", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388712.405957),
                              Points(user: "Father", itemName: "1-on-1 time with kid", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388712.7825761),
                              Points(user: "Father", itemName: "practice talent (30 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388713.1786749),
                              Points(user: "Father", itemName: "good deed / service", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388713.5727069),
                              Points(user: "Father", itemName: "family prayer & scriptures", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388713.9802599),
                              Points(user: "Father", itemName: "on time to events", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388715.851033),
                              Points(user: "Father", itemName: "read (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511388716.2795501),
                              Points(user: "Father", itemName: "enter your top priority habit here", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511302319.7712111),
                              Points(user: "Father", itemName: "pray & scripture study", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511302321.155077),
                              Points(user: "Father", itemName: "exercise (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511302321.6023149),
                              Points(user: "Father", itemName: "journal", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511302322.0879591),
                              Points(user: "Father", itemName: "1-on-1 time with kid", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511313983.285332),
                              Points(user: "Father", itemName: "practice talent (30 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511313983.7765191),
                              Points(user: "Father", itemName: "good deed / service", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511313986.460258),
                              Points(user: "Father", itemName: "family prayer & scriptures", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511313987.2143409),
                              Points(user: "Father", itemName: "on time to events", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511313991.7086849),
                              Points(user: "Father", itemName: "read (20 min)", itemCategory: "daily habits", code: "C", valuePerTap: 6, itemDate: 1511313992.2569959)]

        Income.currentIncomeArray = [Income(user: "Father", currentPoints: 366),
                                     Income(user: "Mother", currentPoints: 0),
                                     Income(user: "Allan", currentPoints: 0),
                                     Income(user: "Sophie", currentPoints: 0),
                                     Income(user: "Savannah", currentPoints: 0),
                                     Income(user: "Flower", currentPoints: 0)]
        
        
        // testing pay period
//        Points.pointsArray = [Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "E", valuePerTap: -71, itemDate: 1511220335.44522), Moneypants.Points(user: "Mother", itemName: "feed pet / garbage (sub)", itemCategory: "daily jobs", code: "S", valuePerTap: 125, itemDate: 1511220335.44522), Moneypants.Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511306745.6326621)]
//        
//        Income.currentIncomeArray = [Moneypants.Income(user: "Father", currentPoints: -17), Moneypants.Income(user: "Mother", currentPoints: 125), Moneypants.Income(user: "Allan", currentPoints: 0), Moneypants.Income(user: "Sophie", currentPoints: 0), Moneypants.Income(user: "Savannah", currentPoints: 0), Moneypants.Income(user: "Flower", currentPoints: 0)]
        
        
        
        
        
        
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
//        cell.userIncome.text = "\(currentUser[0].currentPoints)"
        
        
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







