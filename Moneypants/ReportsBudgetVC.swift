import UIKit

class ReportsBudgetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]
    var sectionData: [Int: [String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.topItem?.title = "\(userName)'s expenses"
        tableView.dataSource = self
        tableView.delegate = self
        
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
    
    // ----------
    // Table View
    // ----------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section]?.count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell1") as! ReportsBudgetCell1
        cell.itemCategory.text = expenseEnvelopes[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expenseEnvelopes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell2") as! ReportsBudgetCell2
        cell.itemSubcategory.text = sectionData[indexPath.section]![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}
