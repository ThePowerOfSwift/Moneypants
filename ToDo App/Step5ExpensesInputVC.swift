import UIKit

class Step5ExpensesInputVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionData: [Int: [String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sectionData = [0 : clothingEnvelope,
                       1 : personalCareEnvelope,
                       2 : sportsDanceEnvelope,
                       3 : musicArtEnvelope,
                       4 : schoolEnvelope,
                       5 : electronicsEnvelope,
                       6 : summerCampsEnvelope,
                       7 : transportationEnvelope,
                       8 : otherEnvelope,
                       9 : funMoneyEnvelope,
                       10 : donationsEnvelope,
                       11 : savingsEnvelope]
    }
    
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section]?.count)!
    }
    
    // custom header view
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! Step5HeaderCell
//        cell.headerLabel.text = expenseEnvelopes[section]
//        return cell
//    }
    
    // header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenseEnvelopes.count
    }
    
    // what's in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expensesCell") as! Step5ExpensesCell
        cell.expensesLabel.text = sectionData[indexPath.section]![indexPath.row]
        cell.expenseValue.text = "0.00"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ExpensesSegue", sender: self)
    }

}
