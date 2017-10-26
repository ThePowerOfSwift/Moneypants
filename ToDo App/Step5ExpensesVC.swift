import UIKit

class Step5ExpensesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var sportsEnvelope: UIImageView!
    @IBOutlet weak var sportsArrow: UIImageView!
    @IBOutlet weak var sportsTableTop: NSLayoutConstraint!
    @IBOutlet weak var sportsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var sportsTableView: UITableView!
    
    @IBOutlet weak var musicArtEnvelope: UIImageView!
    @IBOutlet weak var musicArtArrow: UIImageView!
    @IBOutlet weak var musicArtTableTop: NSLayoutConstraint!
    @IBOutlet weak var musicArtTableHeight: NSLayoutConstraint!
    @IBOutlet weak var musicArtTableView: UITableView!
    
    @IBOutlet weak var schoolEnvelope: UIImageView!
    @IBOutlet weak var schoolArrow: UIImageView!
    @IBOutlet weak var schoolTableTop: NSLayoutConstraint!
    @IBOutlet weak var schoolTableHeight: NSLayoutConstraint!
    @IBOutlet weak var schoolTableView: UITableView!
    
    @IBOutlet weak var summerCampEnvelope: UIImageView!
    @IBOutlet weak var summerCampArrow: UIImageView!
    @IBOutlet weak var summerCampTableTop: NSLayoutConstraint!
    @IBOutlet weak var summerCampTableHeight: NSLayoutConstraint!
    @IBOutlet weak var summerCampTableView: UITableView!
    
    var currentUser: Int!               // passed from Step5VC
    var currentUserName: String!        // passed from Step5VC
    var yearlyOutsideIncome: Int!       // passed from Step5VC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDelegatesAndDataSources()
        
        currentUserName = User.usersArray[currentUser].firstName
        navigationItem.title = User.usersArray[currentUser].firstName
    }
    
    func tableViewDelegatesAndDataSources() {
        sportsTableView.delegate = self
        sportsTableView.dataSource = self
        sportsTableTop.constant = -(sportsTableView.bounds.height)
        
        musicArtTableView.delegate = self
        musicArtTableView.dataSource = self
        musicArtTableTop.constant = -(musicArtTableView.bounds.height)
        
        schoolTableView.delegate = self
        schoolTableView.dataSource = self
        schoolTableTop.constant = -(schoolTableView.bounds.height)
        
        summerCampTableView.delegate = self
        summerCampTableView.dataSource = self
        summerCampTableTop.constant = -(summerCampTableView.bounds.height)
    }
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sportsTableView {
            let cell = sportsTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! Step5ExpensesCell
            cell.expensesLabel.text = "sports item \(indexPath.row + 1)"
            cell.expenseValue.text = "34"
            return cell
        } else if tableView == musicArtTableView {
            let cell = musicArtTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! Step5ExpensesCell
            cell.expensesLabel.text = "music item \(indexPath.row + 1)"
            cell.expenseValue.text = "\((indexPath.row + 1) * 10)"
            return cell
        } else if tableView == schoolTableView {
            let cell = schoolTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! Step5ExpensesCell
            cell.expensesLabel.text = "school item \(indexPath.row + 4)"
            cell.expenseValue.text = "\((indexPath.row + 1) * 2)"
            return cell
        } else {
            let cell = summerCampTableView.dequeueReusableCell(withIdentifier: "expensesCell", for: indexPath) as! Step5ExpensesCell
            cell.expensesLabel.text = "school item \(indexPath.row + 4)"
            cell.expenseValue.text = "\((indexPath.row + 1) * 2)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditExpense", sender: self)
    }
    
    // ----------
    // Navigation
    // ----------
    
    // MARK: Can I combine all the button taps into one function like below? Just check to see which tableview is showing?
    
    @IBAction func sportsDanceButtonTapped(_ sender: UIButton) {
        if sportsTableTop.constant == -(sportsTableView.bounds.height) {
            revealTable(table: sportsTableView, height: sportsTableHeight, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
        } else {
            hideTable(table: sportsTableView, topConstraint: sportsTableTop, arrow: sportsArrow, envelope: sportsEnvelope)
        }
    }
    
    @IBAction func musicArtButtonTapped(_ sender: UIButton) {
        if musicArtTableTop.constant == -(musicArtTableView.bounds.height) {
            revealTable(table: musicArtTableView, height: musicArtTableHeight, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
        } else {
            hideTable(table: musicArtTableView, topConstraint: musicArtTableTop, arrow: musicArtArrow, envelope: musicArtEnvelope)
        }
    }
    
    @IBAction func schoolButtonTapped(_ sender: UIButton) {
        if schoolTableTop.constant == -(schoolTableView.bounds.height) {
            revealTable(table: schoolTableView, height: schoolTableHeight, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
        } else {
            hideTable(table: schoolTableView, topConstraint: schoolTableTop, arrow: schoolArrow, envelope: schoolEnvelope)
        }
    }
    
    @IBAction func summerCampButtonTapped(_ sender: UIButton) {
        if summerCampTableTop.constant == -(summerCampTableView.bounds.height) {
            revealTable(table: summerCampTableView, height: summerCampTableHeight, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
        } else {
            hideTable(table: summerCampTableView, topConstraint: summerCampTableTop, arrow: summerCampArrow, envelope: summerCampEnvelope)
        }
    }
    
    
    
    
    
    
    
    
    
    
    // ---------
    // Functions
    // ---------
    
    func revealTable(table: UITableView, height: NSLayoutConstraint, topConstraint: NSLayoutConstraint, arrow: UIImageView, envelope: UIImageView) {
        table.isHidden = false
        // make table size same as number of rows
        height.constant = table.contentSize.height
        // show the opened envelope
        envelope.image = UIImage(named: "envelope white open")
        // rotate the arrow down
        UIView.animate(withDuration: 0.25) { 
            arrow.transform = CGAffineTransform(rotationAngle: (90.0 * .pi) / 180.0)
        }
        // show the table
        UIView.animate(withDuration: 0.25) { 
            topConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func hideTable(table: UITableView, topConstraint: NSLayoutConstraint, arrow: UIImageView, envelope: UIImageView) {
        // rotate the right arrow back up
        UIView.animate(withDuration: 0.25) {
            arrow.transform = CGAffineTransform(rotationAngle: (0 * .pi) / 180.0)
        }
        // show the closed envelope
        envelope.image = UIImage(named: "envelope white")
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





















