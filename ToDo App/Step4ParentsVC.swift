import UIKit

class Step4ParentsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // ----------------
    // Table View Setup
    // ----------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyChores.count
        } else if section == 1 {
            return parentDailyChores.count
        } else if section == 2 {
            return weeklyChores.count
        } else {
            return parentWeeklyChores.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily chores"
        } else if section == 1 {
            return "parent daily chores"
        } else if section == 2 {
            return "weekly chores"
        } else {
            return "parent weekly chores"
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    // contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step4ParentCustomCell
        if indexPath.section == 0 {
            let (dailyChoreName, _, _, _) = dailyChores[indexPath.row]
            cell.choreLabel.text = dailyChoreName
        } else if indexPath.section == 1 {
            let (parentDailyChoreName, _, _, _) = parentDailyChores[indexPath.row]
            cell.choreLabel.text = parentDailyChoreName
        } else if indexPath.section == 2 {
            let (weeklyChoreName, _, _, _) = weeklyChores[indexPath.row]
            cell.choreLabel.text = weeklyChoreName
        } else {
            let (parentWeeklyChoreName, _, _, _) = parentWeeklyChores[indexPath.row]
            cell.choreLabel.text = parentWeeklyChoreName
        }
        return cell
    }
    
}

