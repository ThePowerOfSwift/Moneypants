import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let yearlyTotal = Int(Double(yearlyIncomeMPS) * 0.021) + yearlyIncomeOutside

    let tempUsers: [(String, UIImage, Double)] = [
        ("Dad", #imageLiteral(resourceName: "Dad"), 41.05),
        ("Mom", #imageLiteral(resourceName: "Mom"), 47.32),
        ("Savannah", #imageLiteral(resourceName: "Savannah"), 22.01),
        ("Aiden", #imageLiteral(resourceName: "Aiden"), 23.98),
        ("Sophie", #imageLiteral(resourceName: "Sophie.jpg"), 14.67)
    ]
    
    
    func formatCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: yearlyTotal))!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        // -----------------
        // Customize Nav Bar
        // -----------------
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 242/255, green: 101/255, blue: 34/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        // UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Arista2.0", size: 26)!
        ]

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeDetailCell", for: indexPath) as! HomeCustomCell
        
        let (userName, userImage, userIncome) = tempUsers[indexPath.row]
        
        cell.userName.text = userName
        cell.userImage.image = userImage
        cell.userIncome.text = "$\(userIncome)"
        
        cell.userImage.layer.cornerRadius = tableView.rowHeight / 6.4
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.borderWidth = 0.5
        cell.userImage.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToIndividualPageSegue", sender: self)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: "individual") as! IndividualMainVC
//        self.present(newViewController, animated: true, completion: nil)
    }
}


