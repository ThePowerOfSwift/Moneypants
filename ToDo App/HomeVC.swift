import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavBarImage()
        tableView.delegate = self
        tableView.dataSource = self
        print("HOME: yearly income MPS: \(yearlyIncomeMPS!)")
        print("HOME: yearly income outside: \(yearlyIncomeOutside!)")
        print("HOME: calculated income: \(String(format: "%.02f", (Double(yearlyIncomeMPS) * 0.021) + Double(yearlyIncomeOutside)))")
    }
    
    
    // ----------
    // Table View
    // ----------
    
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
        homeIndex = indexPath.row
        tableView.reloadData()
        performSegue(withIdentifier: "DetailSegue", sender: self)
    }
    
    
    func addNavBarImage() {
        let navController = navigationController!
        let barImage = #imageLiteral(resourceName: "MPS logo white")
        let imageView = UIImageView(image: barImage)
        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height
        let bannerX = bannerWidth / 2 - barImage.size.width / 2
        let bannerY = bannerHeight / 2 - barImage.size.height / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth * 0.75, height: bannerHeight * 0.75)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}








