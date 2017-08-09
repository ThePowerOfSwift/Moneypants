import UIKit

class Step2VC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempUsers.count        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step2Cell
        let (userName, userImage, _) = tempUsers[indexPath.row]
        cell.myImage.image = userImage
        cell.myLabel.text = userName
        
        cell.myImage.layer.cornerRadius = tableView.rowHeight / 6.4
        cell.myImage.layer.masksToBounds = true
        cell.myImage.layer.borderWidth = 0.5
        cell.myImage.layer.borderColor = UIColor.black.cgColor

        
        return cell
    }
}
