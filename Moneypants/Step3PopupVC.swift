import UIKit

class Step3PopupVC: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTop: UIView!
    @IBOutlet weak var popupViewTopWhite: UIView!
    @IBOutlet weak var watchVideoButton: UIButton!
    
    var infoPage: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 15
        popupView.layer.masksToBounds = true
        popupViewTop.layer.cornerRadius = 50
        popupViewTopWhite.layer.cornerRadius = 40
        
        watchVideoButton.isHidden = true        // hide video button to start
        watchVideoButton.titleLabel?.numberOfLines = 0
        watchVideoButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        watchVideoButton.titleLabel?.textAlignment = .center
    }
    
    // Keep view in portrait mode
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func bottomButtonTapped(_ sender: UIButton) {
        descriptionLabel.text = "NOTE: each daily job will pay the same, and each weekly job will pay the same; so do your best to distribute the assignments equally.\n\nDo NOT include jobs that need to be done less frequently (no monthly or yearly jobs). Also, do NOT include daily habits. Daily habits will be reviewed in the upcoming screens."
        bottomButton.isHidden = true
        watchVideoButton.isHidden = false
    }
    
    @IBAction func watchVideoButtonTapped(_ sender: UIButton) {
        print("watch video button tapped")
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func dismissPopupButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
