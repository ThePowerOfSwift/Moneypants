import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {


    let tempUsers: [(String, UIImage, String)] = [
        ("Dad", #imageLiteral(resourceName: "Dad"), "41.05"),
        ("Mom", #imageLiteral(resourceName: "Mom"), "47.32"),
        ("Savannah", #imageLiteral(resourceName: "Savannah"), "22.01"),
        ("Aiden", #imageLiteral(resourceName: "Aiden"), "23.98"),
        ("Sophie", #imageLiteral(resourceName: "Sophie.jpg"), "14.67")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("HOME: yearly income MPS: \(yearlyIncomeMPS!)")
        print("HOME: yearly income outside: \(yearlyIncomeOutside!)")
        print("HOME: calculated income: \(String(format: "%.02f", (Double(yearlyIncomeMPS) * 0.021) + Double(yearlyIncomeOutside)))")
        

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
        
        // customize the image with rounded corners
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








