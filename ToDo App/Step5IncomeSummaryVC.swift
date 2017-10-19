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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        let yearlyTotal = Int(Double(FamilyData.yearlyIncome) * 0.021) + yearlyIncomeOutside        // need to change this eventually
        let weeklyTotal = Int(yearlyTotal / 52)
        
        weeklyIncomeTotalLabel.text = "potential weekly income: $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!)"
        homeIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: Int(Double(FamilyData.yearlyIncome) * 0.021)))!) / year"
        outsideIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyIncomeOutside))!) / year"
        totalIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) / year"
        summaryLabel.text = "Savannah's total estimated yearly income is $\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) (about $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!) per week.)"
        
        
        showDetailsButton.setTitle("show details", for: .normal)
        viewTop.constant = -(detailsView.bounds.height)
        detailsView.isHidden = true
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
