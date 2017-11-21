import UIKit

class PaydayNavController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("green")
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1)
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
