import UIKit

class JobSummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionData: [Int: [String]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.finalUsersArray.sort(by: {$0.birthday < $1.birthday})       // sort users by birthday in descending order
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sectionData = [0 : assignedJobsHabitsDad,
                       1 : assignedJobsHabitsMom,
                       2 : assignedJobsHabitsSavannah,
                       3 : assignedJobsHabitsAiden,
                       4 : assignedJobsHabitsSophie]
    }
        
    // --------------------
    // Customize Table View
    // --------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return assignedJobsHabitsDad.count
        } else if section == 1 {
            return assignedJobsHabitsMom.count
        } else if section == 2 {
            return assignedJobsHabitsSavannah.count
        } else if section == 3 {
            return assignedJobsHabitsAiden.count
        } else {
            return assignedJobsHabitsSophie.count
        }
    }
    
    // Custom header sections
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! JobSummaryCell
        cell.headerImage.image = User.finalUsersArray[section].photo
        cell.headerLabel.text = User.finalUsersArray[section].firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return User.finalUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        }
        
        cell!.textLabel?.text = sectionData[indexPath.section]![indexPath.row]
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if indexPath.section == 0 {
//            cell?.textLabel?.text = assignedJobsHabitsDad[indexPath.row]
//        } else if indexPath.section == 1 {
//            cell?.textLabel?.text = assignedJobsHabitsMom[indexPath.row]
//        } else if indexPath.section == 2 {
//            cell?.textLabel?.text = assignedJobsHabitsSavannah[indexPath.row]
//        } else if indexPath.section == 3 {
//            cell?.textLabel?.text = assignedJobsHabitsAiden[indexPath.row]
//        } else {
//            cell?.textLabel?.text = assignedJobsHabitsSophie[indexPath.row]
//        }
//        return cell!
        
        
        return cell!
    }
}

