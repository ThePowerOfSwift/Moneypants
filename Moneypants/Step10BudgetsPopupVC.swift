import UIKit

class Step10BudgetsPopupVC: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTop: UIView!
    @IBOutlet weak var popupViewTopWhite: UIView!
    @IBOutlet weak var popupViewTopWhiteImage: UIImageView!
    @IBOutlet weak var watchVideoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 15
        popupView.layer.masksToBounds = true
        popupViewTop.layer.cornerRadius = 50
        popupViewTopWhite.layer.cornerRadius = 40
        popupViewTopWhiteImage.layer.cornerRadius = 10
        popupViewTopWhiteImage.layer.masksToBounds = true
        
        watchVideoButton.titleLabel?.numberOfLines = 0
        watchVideoButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        watchVideoButton.titleLabel?.textAlignment = .center
    }
    
    @IBAction func dismissPopupButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
