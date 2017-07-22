import UIKit

class SetupNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ---------------------------------------------
        // hide text, only have back arrow on navigation
        // ---------------------------------------------
        
        let backImage = UIImage(named: "arrow left white")?.withRenderingMode(.alwaysOriginal)        // was "BackNavigation"
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -120.0), for: .default)       // was -80
        
    }

}
