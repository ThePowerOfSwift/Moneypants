import UIKit

class PaydayDetailsPopup: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainPopupBG: UIView!
    @IBOutlet weak var topPopupBG: UIView!
    @IBOutlet weak var topPopupWhiteBG: UIView!
    @IBOutlet weak var topPopupImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    var categoryLabelText: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.tableFooterView = UIView()
        
        // all I need is the category and I can calculate everything else I need
        // I don't even need current user b/c it's global and I can just call currentUser
        categoryLabel.text = categoryLabelText
        
        switch categoryLabelText {
        case "daily jobs":
            topPopupImageView.image = UIImage(named: "broom black")
        case "daily habits":
            topPopupImageView.image = UIImage(named: "music white")
            topPopupImageView.tintColor = UIColor.black
        case "weekly jobs":
            topPopupImageView.image = UIImage(named: "lawnmower black")
        case "other jobs":
            topPopupImageView.image = UIImage(named: "broom plus white")
            topPopupImageView.tintColor = UIColor.black
        case "fees":
            topPopupImageView.image = UIImage(named: "dollar minus black")
        case "withdrawals":
            topPopupImageView.image = UIImage(named: "shopping cart black")
        case "unpaid":
            topPopupImageView.image = UIImage(named: "dollar black")
        default:
            topPopupImageView.image = UIImage(named: "broom black")
        }
        
        customizeBackground()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func customizeBackground() {
        mainPopupBG.layer.cornerRadius = 15
        mainPopupBG.layer.masksToBounds = true
        topPopupBG.layer.cornerRadius = 50
        topPopupWhiteBG.layer.cornerRadius = 40
    }
    
    // table view
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "detailsCell")
        cell?.textLabel?.text = "cheesy!"
        cell?.detailTextLabel?.text = "$1.30"
        cell?.imageView?.image = UIImage(named: "broom black")
        return cell!
    }
}
