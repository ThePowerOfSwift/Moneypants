import UIKit

class Step5ExpensesInputVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let sections: [String] = ["clothing", "accessories", "grooming", "sports & dance", "music & art", "school", "electronics", "summer camps", "transportation (teen car)", "other", "fun money (10%)", "donations (10%)", "savings (10%)"]
    let clothingSectionData: [String] = ["socks", "underwear", "shoes", "shirts & pants & other items", "coats", "dresses", "suits", "swimwear"]
    let accessoriesSectionData: [String] = ["hats", "jewelry", "purses / wallets", "scarfs", "ties"]
    let groomingSectionData: [String] = ["haircuts", "hair color", "nails", "eyebrows", "makeup", "hair tools &c"]
    let sportsSectionData: [String] = ["registration fees", "class tuition", "uniform", "team shirt", "equipment", "competitions", "performances", "costumes"]
    let musicSectionData: [String] = ["tuition", "supplies & tools"]
    let schoolSectionData: [String] = ["field trips", "clubs", "backpack", "supplies"]
    let electronicsSectionData: [String] = ["phone", "phone bill", "software", "games", "iPods, iPads, &c"]
    let summerCampSectionData: [String] = ["camp #1", "camp #2", "camp #3"]
    let transportationSectionData: [String] = ["gasoline", "car insurance", "car maintenance"]
    let otherSectionData: [String] = ["other 1", "other 2", "other 3", "other 4", "other 5"]
    let funMoneySectionData: [String] = []
    let donationsSectionData: [String] = []
    let savingsSectionData: [String] = []
    
    var sectionData: [Int: [String]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sectionData = [0 : clothingSectionData,
                       1 : accessoriesSectionData,
                       2 : groomingSectionData,
                       3 : sportsSectionData,
                       4 : musicSectionData,
                       5 : schoolSectionData,
                       6 : electronicsSectionData,
                       7 : summerCampSectionData,
                       8 : transportationSectionData,
                       9 : otherSectionData,
                       10 : funMoneySectionData,
                       11 : donationsSectionData,
                       12 : savingsSectionData]
    }
    
    // number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section]?.count)!
    }
    
    // custom header view
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! Step5HeaderCell
        cell.headerLabel.text = sections[section]
        return cell
    }
    
    // header height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // what's in each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "expensesCell") as! Step5ExpensesCell
        cell.expensesLabel.text = sectionData[indexPath.section]![indexPath.row]
        cell.expenseValue.text = "0.00"
        
        
//        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if cell == nil {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        }
//        cell!.textLabel?.text = sectionData[indexPath.section]![indexPath.row]
//        return cell!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ExpensesSegue", sender: self)
    }

}
