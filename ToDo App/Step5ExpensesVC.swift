import UIKit

class Step5ExpensesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser: Int!               // passed from Step5VC
    var currentUserName: String!        // passed from Step5VC
    var yearlyOutsideIncome: Int!       // passed from Step5VC
    
    @IBOutlet weak var sportsArrow: UIImageView!
    @IBOutlet weak var sportsTableTop: NSLayoutConstraint!
    @IBOutlet weak var sportsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var sportsTableView: UITableView!
    
    @IBOutlet weak var musicArtArrow: UIImageView!
    @IBOutlet weak var musicArtTableTop: NSLayoutConstraint!
    @IBOutlet weak var musicArtTableHeight: NSLayoutConstraint!
    @IBOutlet weak var musicArtTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sportsTableView.delegate = self
        sportsTableView.dataSource = self
        sportsTableTop.constant = -(sportsTableView.bounds.height)
        
        musicArtTableView.delegate = self
        musicArtTableView.dataSource = self
        musicArtTableTop.constant = -(musicArtTableView.bounds.height)
        
        currentUserName = User.usersArray[currentUser].firstName
        navigationItem.title = User.usersArray[currentUser].firstName
    }
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sportsTableView {
            let cell = sportsTableView.dequeueReusableCell(withIdentifier: "sportsExpensesCell", for: indexPath) as! Step5ExpensesCell
            cell.expensesLabel.text = "item \(indexPath.row)"
            cell.expenseValue.text = "34"
            return cell
        } else {
            let cell = musicArtTableView.dequeueReusableCell(withIdentifier: "sportsExpensesCell", for: indexPath) as! Step5ExpensesCell
            cell.expensesLabel.text = "music item \(indexPath.row)"
            cell.expenseValue.text = "\(indexPath.row * 10)"
            return cell
        }
    }
    
    @IBAction func sportsDanceButtonTapped(_ sender: UIButton) {
        if sportsTableTop.constant == -(sportsTableView.bounds.height) {
            sportsTableHeight.constant = sportsTableView.contentSize.height
            revealTable(table: sportsTableView, arrow: sportsArrow, topConstraint: sportsTableTop)
        } else {
            hideTable(table: sportsTableView, arrow: sportsArrow, topConstraint: sportsTableTop)
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func revealTable(table: UITableView, arrow: UIImageView, topConstraint: NSLayoutConstraint) {
        table.isHidden = false
        // rotate the arrown down
        UIView.animate(withDuration: 0.25) {
            arrow.transform = CGAffineTransform(rotationAngle: (90.0 * .pi) / 180.0)
        }
        // show the table
        UIView.animate(withDuration: 0.25, animations: {
            topConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
    func hideTable(table: UITableView, arrow: UIImageView, topConstraint: NSLayoutConstraint) {
        // rotate the right arrow back up
        UIView.animate(withDuration: 0.25) {
            arrow.transform = CGAffineTransform(rotationAngle: (0 * .pi) / 180.0)
        }
        // hide the table from view
        UIView.animate(withDuration: 0.25, animations: {
            topConstraint.constant = -(table.bounds.height)
            self.view.layoutIfNeeded()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            table.isHidden = true
        }
    }
}





















