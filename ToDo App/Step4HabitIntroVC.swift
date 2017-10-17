import UIKit

class Step4HabitIntroVC: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTop: UIView!
    @IBOutlet weak var popupViewTopWhite: UIView!
    @IBOutlet weak var watchVideoButton: UIButton!
    @IBOutlet weak var watchVideoButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var popupViewImage: UIImageView!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var mainLabelText: String!
    var bodyLabelText: String!
    var popupImage: UIImage!
    
    // these are default values unless otherwise called from Step4VC
    var watchVideoButtonHiddenStatus = false
    var watchVideoButtonHeightValue: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLabel.text = mainLabelText
        bodyLabel.text = bodyLabelText
        popupViewImage.image = popupImage
        watchVideoButtonHeight.constant = watchVideoButtonHeightValue
        watchVideoButton.isHidden = watchVideoButtonHiddenStatus
        
        popupView.layer.cornerRadius = 15
        popupView.layer.masksToBounds = true
        popupViewTop.layer.cornerRadius = 50
        popupViewTopWhite.layer.cornerRadius = 40
        popupViewImage.layer.cornerRadius = 35
        popupViewImage.layer.masksToBounds = true
        
        watchVideoButton.titleLabel?.numberOfLines = 0
        watchVideoButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        watchVideoButton.titleLabel?.textAlignment = .center
    }
    
    @IBAction func watchVideoButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "AgeAppropriatePopup", sender: self)
    }
    
    @IBAction func dismissPopupButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
