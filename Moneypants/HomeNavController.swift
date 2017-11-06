import UIKit

class HomeNavController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        // -----------------
        // Customize Nav Bar
        // -----------------
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 242/255, green: 101/255, blue: 34/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "Arista2.0", size: 26)!
        ]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -----------------
        // Customize Tab Bar
        // -----------------
        
        tabBarController?.tabBar.tintColor = UIColor.black
        tabBarController?.tabBar.isTranslucent = false
        
        // ---------------------------------------------
        // hide text, only have back arrow on navigation
        // ---------------------------------------------
        
        let backImage = UIImage(named: "arrow left white")?.withRenderingMode(.alwaysOriginal)        // was "BackNavigation"
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80), for: .default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80), for: .compact)
    }
}
