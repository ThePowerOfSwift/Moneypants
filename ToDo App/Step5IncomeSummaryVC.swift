import UIKit

class Step5IncomeSummaryVC: UIViewController {
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var showDetailsButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showDetailsButton.setTitle("show details", for: .normal)
        viewTop.constant = -(detailsView.bounds.height)
        detailsView.isHidden = true
        print("Initial view height: \(detailsView.bounds.height)")          // check height of view BEFORE animation
        
    }
    
    
    @IBAction func showDetailsButtonTapped(_ sender: UIButton) {
        print("Button pressed view height: \(detailsView.bounds.height)")           // check height of view AFTER button press
        if viewTop.constant == -(detailsView.bounds.height) {
            detailsView.isHidden = false
            showDetailsButton.setTitle("hide details", for: .normal)
            self.viewTop.constant = 0
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            print("After animation view height: \(detailsView.bounds.height)")         // check height of view after animation
        } else {
            self.viewTop.constant = -(self.detailsView.bounds.height)
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
            showDetailsButton.setTitle("show details", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.detailsView.isHidden = true
            }
        }
    }
    
}
