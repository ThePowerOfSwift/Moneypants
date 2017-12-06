import UIKit
import Firebase

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var window: UIWindow?
    var firebaseUser: User!
    var ref: DatabaseReference!

    let settingsList: [(String, String)] = [("change household income", "Step1"),
                                            ("add / remove family members", "Users"),
                                            ("modify individual account details", "IndividualChores"),
                                            ("modify jobs & habits", "Chores"),
                                            ("reassign jobs & habits", "IndividualHabits"),
                                            ("change passwords", "IndividualIncomeSummary"),
                                            ("sign out", "LoginVC")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        tableView.tableFooterView = UIView()
        
        addNavBarImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Parental Passcode Required", message: "You must enter a parental passcode to access the settings page:", preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "enter passcode"
                textField.isSecureTextEntry = true
                textField.keyboardType = .numberPad
            })
            // Button ONE: "okay"
            alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default , handler: { (action) in
                // get passcodes for just parents, not kids
                let parentalPasscodeArray = MPUser.usersArray.filter({ $0.childParent == "parent" })
                if parentalPasscodeArray.contains(where: { "\($0.passcode)" == alert.textFields![0].text }) {
                    alert.dismiss(animated: true, completion: nil)
                } else {
                    self.incorrectPasscodeAlert()
                }
            }))
            // Button TWO: "cancel"
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in
                alert.dismiss(animated: true, completion: nil)
                // send user back to home page
                CATransaction.setCompletionBlock({
                    self.tabBarController?.selectedIndex = 0
                })
            }))
            present(alert, animated: true, completion: nil)
    }
    
    // ----------------
    // Setup Table View
    // ----------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        let (settingDescription, _) = settingsList[indexPath.row]
        cell.textLabel?.text = settingDescription
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let (settingDescription, _) = settingsList[indexPath.row]
        if indexPath.row == 0 {
            let alert = UIAlertController(title: "Change Household Income", message: "You have chosen 'change household income'. This will affect all of your settings and will require you to review the entire setup process and update users' budgets after you modify your income.\n\nDo you wish to proceed?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "continue", style: .default, handler: { _ in
                let storyboard = UIStoryboard(name: "Setup", bundle: nil)
                let navController: UINavigationController = storyboard.instantiateViewController(withIdentifier: "SetupNavController") as! UINavigationController
                self.navigationController?.present(navController, animated: true, completion: nil)
                FamilyData.setupProgress = 1
                self.ref.updateChildValues(["setupProgress" : 1])
            }))
            alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            }))
            present(alert, animated: true, completion: nil)
            
            
            // WORKS KIND OF
            /*
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Setup", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "LoadingVC")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            */
            // END WORKS KIND OF
            
            
        } else if indexPath.row == 1 {
            print(settingDescription)
        } else if indexPath.row == 2 {
            print(settingDescription)
        } else if indexPath.row == 3 {
            print(settingDescription)
        } else if indexPath.row == 4 {
//            let newViewController = Step4VC.self()
//            self.navigationController?.pushViewController(newViewController, animated: true)
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
                    try Auth.auth().signOut()
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Setup", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") // as! LoginVC
                    self.present(newViewController, animated: true, completion: nil)
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
        tableView.reloadData()
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

    func incorrectPasscodeAlert() {
        let wrongPasscodeAlert = UIAlertController(title: "Incorrect Passcode", message: "", preferredStyle: .alert)
        wrongPasscodeAlert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
            wrongPasscodeAlert.dismiss(animated: true, completion: nil)
            // send user back to home page
            CATransaction.setCompletionBlock({
                self.tabBarController?.selectedIndex = 0
            })
        }))
        self.present(wrongPasscodeAlert, animated: true, completion: nil)
    }
}
