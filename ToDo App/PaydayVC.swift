import UIKit

class PaydayVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! PaydayCell
        let (userName, userImage, _) = tempUsers[indexPath.row]
        cell.userImage.image = userImage
        cell.userName.text = userName

        // customize the image with rounded corners
        cell.userImage.layer.cornerRadius = tableView.rowHeight / 6.4
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.borderWidth = 0.5
        cell.userImage.layer.borderColor = UIColor.black.cgColor
        
        cell.goView.layer.cornerRadius = cell.goView.bounds.height / 6.4
        cell.goView.layer.masksToBounds = true
        cell.goView.layer.borderColor = UIColor.black.cgColor
        cell.goView.layer.borderWidth = 0.5
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeIndex = indexPath.row     // was paydayIndex
        performSegue(withIdentifier: "DetailSegue", sender: self)
    }
}
