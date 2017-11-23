import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MPUser.usersArray.sort(by: {$0.birthday < $1.birthday})       // sort array with oldest users first
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        
        
        
        
        
        
        // temp arrays for testing
        Points.pointsArray = [Points(user: "Father", itemName: "feed pet / garbage", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511333997.678102),
                              Points(user: "Father", itemName: "enter your top priority habit here", itemCategory: "daily habits", code: "C", valuePerTap: 24, itemDate: 1511333997.9687519),
                              Points(user: "Father", itemName: "wash car", itemCategory: "weekly jobs", code: "C", valuePerTap: 302, itemDate: 1511333999.4136181),
                              Points(user: "Father", itemName: "bad language", itemCategory: "fees", code: "F", valuePerTap: -71, itemDate: 1511395725.283673),
                              Points(user: "Mother", itemName: "living room", itemCategory: "daily jobs", code: "C", valuePerTap: 54, itemDate: 1511413767.8222201),
                              Points(user: "Mother", itemName: "meal prep", itemCategory: "daily jobs", code: "E", valuePerTap: -35, itemDate: 1511413773.4892831),
                              Points(user: "Allan", itemName: "meal prep (sub)", itemCategory: "daily jobs", code: "S", valuePerTap: 89, itemDate: 1511413773.4893231)]
        
        Income.currentIncomeArray = [Income(user: "Father", currentPoints: 309),
                                     Income(user: "Mother", currentPoints: 19),
                                     Income(user: "Allan", currentPoints: 89),
                                     Income(user: "Sophie", currentPoints: 0),
                                     Income(user: "Savannah", currentPoints: 0),
                                     Income(user: "Flower", currentPoints: 0)]
        
        print("Payday is: ",FamilyData.paydayTime)
        
        
        
        
        
        
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
            let temp = Income.currentIncomeArray.filter({ $0.user == user.firstName })
            if temp.isEmpty {
                let newUser = Income(user: user.firstName, currentPoints: 0)
                Income.currentIncomeArray.append(newUser)
            } else {
                print("\(user.firstName) already has income")
            }
        }
    }
}







