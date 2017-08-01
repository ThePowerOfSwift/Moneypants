import UIKit

class ChoreSummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let sectionTitle: [String] = ["Dad", "Mom", "Savannah", "Aiden", "Sophie"]
    let sectionImages: [UIImage] = [#imageLiteral(resourceName: "Dad"), #imageLiteral(resourceName: "Mom"), #imageLiteral(resourceName: "Savannah.jpg"), #imageLiteral(resourceName: "Aiden"), #imageLiteral(resourceName: "Sophie")]
    let s1Data: [String] = ["meal prep",
                            "job inspections",
                            "get self ready for day",
                            "personal meditation",
                            "develop talent",
                            "1-on-1 with child",
                            "payday"]
    let s2Data: [String] = ["counters",
                            "feed pet",
                            "get self ready for day",
                            "personal meditation",
                            "develop talent",
                            "1-on-1 with child",
                            "clean fridge"]
    let s3Data: [String] = ["bedroom",
                            "bathrooms",
                            "get self & buddy ready for day",
                            "personal meditation / prayer",
                            "daily exercise (20 min)",
                            "wash & vacuum 1 car"]
    let s4Data: [String] = ["bedroom",
                            "laundry",
                            "living room",
                            "get self & buddy ready for day",
                            "personal meditation / prayer",
                            "daily exercise (20 min)",
                            "wash & vacuum 1 car"]
    let s5Data: [String] = ["bedroom",
                            "sweep & vacuum",
                            "dishes",
                            "get self & buddy ready for day",
                            "personal meditation / prayer",
                            "daily exercise (20 min)",
                            "mop floors",
                            "mow lawn"]

    
    var sectionData: [Int: [String]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sectionData = [0 : s1Data, 1 : s2Data, 2 : s3Data, 3 : s4Data, 4 : s5Data]
    }
    
    
    // --------------------
    // Customize Table View
    // --------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return s1Data.count
        } else if section == 1 {
            return s2Data.count
        } else if section == 2 {
            return s3Data.count
        } else if section == 3 {
            return s4Data.count
        } else {
            return s5Data.count
        }
    }
    
    // Custom header sections
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! ChoreSummaryCell
        cell.headerImage.image = sectionImages[section]
        cell.headerLabel.text = sectionTitle[section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        }
        
        cell!.textLabel?.text = sectionData[indexPath.section]![indexPath.row]
        cell?.contentView.backgroundColor = UIColor.yellow
        return cell!
    }
}

