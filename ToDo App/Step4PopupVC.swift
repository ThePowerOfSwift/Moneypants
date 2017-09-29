import UIKit

class Step4PopupVC: UIViewController {

    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupViewTop: UIView!
    @IBOutlet weak var popupViewTopWhite: UIView!
    @IBOutlet weak var watchVideoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 15
        popupViewTop.layer.cornerRadius = 50
        popupViewTopWhite.layer.cornerRadius = 40
        
        watchVideoButton.titleLabel?.numberOfLines = 0
        watchVideoButton.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        watchVideoButton.titleLabel?.textAlignment = .center
    }
    
    @IBAction func watchVideoButtonTapped(_ sender: UIButton) {
        print("watch video button tapped")
    }
    
    @IBAction func dismissPopupButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
