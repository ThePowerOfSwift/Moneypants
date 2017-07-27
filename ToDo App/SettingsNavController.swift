import UIKit

class SettingsNavController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("gray")
        
        UINavigationBar.appearance().barTintColor = UIColor.gray
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Arista2.0", size: 26)!
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
