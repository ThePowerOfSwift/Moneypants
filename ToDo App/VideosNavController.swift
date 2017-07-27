import UIKit

class VideosNavController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("purple")
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1)
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
