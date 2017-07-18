import UIKit

class Step5IncomeSummaryVC: UIViewController {
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var viewTop: NSLayoutConstraint!
    @IBOutlet weak var showDetailsButton: UIButton!
    @IBOutlet weak var yearlyIncomeTotalLabel: UILabel!
    @IBOutlet weak var weeklyIncomeTotalLabel: UILabel!
    @IBOutlet weak var homeIncomeLabel: UILabel!
    @IBOutlet weak var outsideIncomeLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    let numberFormatter = NumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        let yearlyTotal = Int(Double(yearlyIncomeMPS) * 0.021) + yearlyIncomeOutside        // need to change this eventually
        let weeklyTotal = Int(yearlyTotal / 52)
        
        yearlyIncomeTotalLabel.text = "\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!)"
        weeklyIncomeTotalLabel.text = "\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!)"
        homeIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: Int(Double(yearlyIncomeMPS) * 0.021)))!) / year"
        outsideIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyIncomeOutside))!) / year"
        totalIncomeLabel.text = "$\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) / year"
        summaryLabel.text = "Savannah's total estimated yearly income is $\(numberFormatter.string(from: NSNumber(value: yearlyTotal))!) (or about $\(numberFormatter.string(from: NSNumber(value: weeklyTotal))!) per week.)"
        
        
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
