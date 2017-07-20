import UIKit

class SetupNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---------------------------------------------
        // hide text, only have back arrow on navigation
        // ---------------------------------------------
        
        let backImage = UIImage(named: "BackNavigation")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
        
    }

}
