import UIKit

class HomeNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------------
        // Customize Nav Bar
        // -----------------
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 15/255, green: 131/255, blue: 254/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Arista2.0", size: 26)!
        ]

    }

}
