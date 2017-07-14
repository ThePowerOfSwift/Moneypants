import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tempUsers = [
        ("Dad", #imageLiteral(resourceName: "Dad"), 41.05),
        ("Mom", #imageLiteral(resourceName: "Mom"), 47.32),
        ("Savannahlongname", #imageLiteral(resourceName: "Savannah"), 22.21),
        ("Aiden", #imageLiteral(resourceName: "Aiden"), 23.98),
        ("Sophie", #imageLiteral(resourceName: "Sophie.jpg"), 14.67)
    ]
    
    let tempUserIncome = ["41.05", "47.32", "22.20", "23.98", "14.67"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

}
