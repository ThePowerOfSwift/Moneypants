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
            return dailyJobs.count
        } else if section == 1 {
            return parentDailyJobs.count
        } else if section == 2 {
            return weeklyJobs.count
        } else {
            return parentWeeklyJobs.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily jobs"
        } else if section == 1 {
            return "parent daily jobs"
        } else if section == 2 {
            return "weekly jobs"
        } else {
            return "parent weekly jobs"
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
            let (dailyChoreName, _, _, _) = dailyJobs[indexPath.row]
            cell.jobLabel.text = dailyChoreName
        } else if indexPath.section == 1 {
            let (parentDailyJobName, _, _, _) = parentDailyJobs[indexPath.row]
            cell.jobLabel.text = parentDailyJobName
        } else if indexPath.section == 2 {
            let (weeklyJobName, _, _, _) = weeklyJobs[indexPath.row]
            cell.jobLabel.text = weeklyJobName
        } else {
            let (parentWeeklyJobName, _, _, _) = parentWeeklyJobs[indexPath.row]
            cell.jobLabel.text = parentWeeklyJobName
        }
        return cell
    }
    
}

