import UIKit

class Step4PopupVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTop: UIView!
    @IBOutlet weak var popupViewTopWhite: UIView!
    @IBOutlet weak var watchVideoButton: UIButton!
    @IBOutlet weak var watchVideoButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var popupViewImage: UIImageView!
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var mainLabelText: String! = "Assign Jobs"
    var bodyLabelText: String! = "You are now going to assign daily and weekly jobs to each family member, starting with the youngest child.\n\nParents will be assigned last."
    var popupImage: UIImage! = UIImage(named: "clipboard black")
    
    var isFirstUser = false
    var firstUserMainLabelText: String!
    var firstUserBodyLabelText: String!
    var firstUserPopupViewImage: UIImage!
    
    var shouldChangeWatchVideoButtonTitle = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainLabel.text = mainLabelText
        bodyLabel.text = bodyLabelText
        popupViewImage.image = popupImage
        
        popupView.layer.cornerRadius = 15
        popupView.layer.masksToBounds = true
        popupViewTop.layer.cornerRadius = 50
        popupViewTopWhite.layer.cornerRadius = 40
        popupViewImage.layer.cornerRadius = 35
        popupViewImage.layer.masksToBounds = true
        
        watchVideoButton.titleLabel?.numberOfLines = 0
        watchVideoButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        watchVideoButton.titleLabel?.textAlignment = .center
        
        if shouldChangeWatchVideoButtonTitle {
            watchVideoButton.setTitle("age-appropriate jobs list", for: .normal)
        } else {
            watchVideoButton.setTitle("click here to watch a short video", for: .normal)
        }
    }
    
    @IBAction func watchVideoButtonTapped(_ sender: UIButton) {
        if shouldChangeWatchVideoButtonTitle {
            performSegue(withIdentifier: "AgeAppropriatePopup", sender: self)
        } else {
            performSegue(withIdentifier: "VideoPopup", sender: self)
        }
    }
    
    @IBAction func dismissPopupButtonTapped(_ sender: UIButton) {
        if isFirstUser == true {
            mainLabel.text = firstUserMainLabelText
            bodyLabel.text = firstUserBodyLabelText
            popupViewImage.image = firstUserPopupViewImage
            watchVideoButton.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
            watchVideoButton.setTitle("age-appropriate jobs list", for: .normal)
            shouldChangeWatchVideoButtonTitle = true
            isFirstUser = false
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
