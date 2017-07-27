import UIKit

class UserNavController: UINavigationController {
        
    override func viewWillAppear(_ animated: Bool) {
        
        print("blue")
        
        // -----------------
        // Customize Nav Bar
        // -----------------
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Arista2.0", size: 26)!
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("tab bar gray for users")
        
        // -----------------
        // Customize Tab Bar
        // -----------------
        
        tabBarController?.tabBar.tintColor = UIColor.black
        tabBarController?.tabBar.isTranslucent = false
    }
}
