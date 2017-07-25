import UIKit

class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------------
        // Customize Toolbar (NOTE: nav bar customization goes in nav bar controller, toolbar customization goes in first (main) view controller in stack
        // -----------------

        addNavBarImage()
        tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray], for:.selected)
        tabBarController?.tabBar.tintColor = UIColor.black
        tabBarController?.tabBar.isTranslucent = false
        
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
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "DetailSegue", sender: self)
//    }
}








