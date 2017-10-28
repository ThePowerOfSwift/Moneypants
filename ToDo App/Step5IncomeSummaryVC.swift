import UIKit

class Step5IncomeSummaryVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var showDetailsButton: UIButton!
    @IBOutlet weak var weeklyIncomeTotalLabel: UILabel!
    @IBOutlet weak var homeIncomeLabel: UILabel!
    @IBOutlet weak var outsideIncomeLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    let numberFormatter = NumberFormatter()
    
    var currentUser: Int!               // passed from Step5VC
    var currentUserName: String!        // passed from Step5VC
    var yearlyOutsideIncome: Int!       // passed from Step5VC
    var censusKidsMultiplier: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateCensusFormulas()
        
        currentUserName = User.usersArray[currentUser].firstName
        userImage.image = User.usersArray[currentUser].photo
        navigationItem.title = User.usersArray[currentUser].firstName
        
        showDetailsButton.setTitle("show details", for: .normal)
        viewTop.constant = -(detailsView.bounds.height)
        detailsView.isHidden = true
    }
    
    // ----------
    // Navigation
    // ----------
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        // MARK: TODO - update setupProgress

        performSegue(withIdentifier: "MemberExpenses", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MemberExpenses" {
            let nextVC = segue.destination as! Step5ExpensesVC
            nextVC.currentUser = currentUser
            nextVC.currentUserName = currentUserName
        }
    }
    
    // ---------
    // Functions
    // ---------
    
    func calculateCensusFormulas() {
        let numberOfKidsCount = User.usersArray.filter({ return $0.childParent == "child" }).count          // get # of kids
        
        // adjust multiplier according to census data
        if numberOfKidsCount >= 3 {
            censusKidsMultiplier = 0.76
        } else if numberOfKidsCount == 2 {
            censusKidsMultiplier = 1
        } else if numberOfKidsCount <= 1 {
            censusKidsMultiplier = 1.27
        }
        
        // this formula calculates the custom census multiplier for calculating individual potential earnings
        let secretFormula = ((5.23788 * pow(0.972976, Double(FamilyData.yearlyIncome) / 1000) + 1.56139) / 100) as Double
        let yearlyHomeIncome = Int(secretFormula * Double(FamilyData.yearlyIncome) * censusKidsMultiplier)
        let yearlyTotal = yearlyHomeIncome + yearlyOutsideIncome
        let weeklyTotal = Int(yearlyTotal / 52)
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        weeklyIncomeTotalLabel.text = "\(currentUserName!)'s potential weekly income is $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!)."
        homeIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyHomeIncome))!) / year"
        outsideIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyOutsideIncome))!) / year"
        totalIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) / year"
        summaryLabel.text = "\(currentUserName!)'s total estimated yearly income is $\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) (about $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!) per week.)"
    }
    
    @IBAction func showDetailsButtonTapped(_ sender: UIButton) {
        if viewTop.constant == -(detailsView.bounds.height) {
            detailsView.isHidden = false
            showDetailsButton.setTitle("hide details", for: .normal)
            self.viewTop.constant = 0
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
            })
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
