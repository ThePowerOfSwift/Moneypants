import UIKit
import FirebaseAuth

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    let settingsList: [(String, String)] = [("change household income", "Step1"),
                                            ("add / remove family members", "Users"),
                                            ("modify individual account details", "IndividualChores"),
                                            ("modify chores & habits", "Chores"),
                                            ("reassign chores & habits", "IndividualHabits"),
                                            ("change passwords", "IndividualIncomeSummary"),
                                            ("sign out", "Login")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNavBarImage()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let (settingDescription, _) = settingsList[indexPath.row]
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
//        let newViewController = storyBoard.instantiateViewController(withIdentifier: settingDestination)
//        self.present(newViewController, animated: true, completion: nil)
        cell.textLabel?.text = settingDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (settingDescription, settingVC) = settingsList[indexPath.row]
        if indexPath.row == 0 {
            print(settingDescription)
            let storyBoard: UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: settingVC) // as! LoginViewController
            self.present(newViewController, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            print(settingDescription)
        } else if indexPath.row == 2 {
            print(settingDescription)
        } else if indexPath.row == 3 {
            print(settingDescription)
        } else if indexPath.row == 4 {
            print(settingDescription)
        } else if indexPath.row == 5 {
            print(settingDescription)
        } else {
            print(settingDescription)
            
            // Create alert and allow user to cancel
            let alert = UIAlertController(title: "Logout Warning", message: "All user data will be removed from this device. Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
            
            // Button ONE: "okay"
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                do {
                    try FIRAuth.auth()?.signOut()
                    let newViewController = Step1ViewController.self()
                    self.navigationController?.pushViewController(newViewController, animated: true)
                } catch let error {
                    assertionFailure("Error signing out: \(error)")
                }
                self.tableView.reloadData()
                print("okay")
            }))
            
            // Button TWO: "cancel"
            alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel , handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.tableView.reloadData()
                print("cancel")
            }))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    func createAlert (alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            do {
                try FIRAuth.auth()?.signOut()
                let storyBoard: UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                self.present(newViewController, animated: true, completion: nil)
            } catch let error {
                assertionFailure("Error signing out: \(error)")
            }
            self.tableView.reloadData()
            print("okay")
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel , handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
