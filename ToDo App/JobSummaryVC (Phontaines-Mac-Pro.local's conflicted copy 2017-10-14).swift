import UIKit

class JobSummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionData: [Int: [String]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        User.finalUsersArray.sort(by: {$0.birthday < $1.birthday})       // sort users by birthday with oldest first
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for i in 1..<JobsAndHabits.finalDailyJobsArray.count {
            let jobAssignments2 = JobsAndHabits.finalDailyJobsArray.filter({ return $0.assigned == User.finalUsersArray[i].firstName }).sorted(by: { $0.assigned < $1.assigned })
            print(jobAssignments2)
        }
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return User.finalUsersArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1        // no idea how to calculate this
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! JobSummaryCellB
        
        
        cell.dailyWeeklyLabel.text = ""
        cell.dailyWeeklyLabel.backgroundColor = UIColor.white            // UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0)
        cell.dailyWeeklyLabel.textColor = UIColor.white
//        cell.userNameLabel.text = "job \(indexPath.row + 1)"
        
        
//        let jobAssignments2 = JobsAndHabits.finalDailyJobsArray.filter({ return $0.assigned == User.finalUsersArray[indexPath.section].firstName }).sorted(by: { $0.assigned < $1.assigned })
//        cell.userNameLabel.text = jobAssignments2[indexPath.row].name
        
        
        
        
        
        // works?
//        if User.finalUsersArray[indexPath.row].firstName == JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned {
//            cell.userNameLabel.text = JobsAndHabits.finalWeeklyJobsArray[indexPath.row].name
//        } else {
//            cell.userNameLabel.text = "HELP!"
//        }
        
        
        
        
        
        // DOESN'T WORK:
//        cell.userNameLabel.text = User.finalUsersArray.filter({ return $0.firstName == "Father" })
        
        // Also Doesn't work:
//        if JobsAndHabits.finalWeeklyJobsArray[indexPath.row].assigned == User.finalUsersArray[indexPath] {
//            cell.userNameLabel.text = JobsAndHabits.finalWeeklyJobsArray[indexPath.row].name

        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! JobSummaryCell
        cell.headerImage.image = User.finalUsersArray[section].photo
        cell.headerLabel.text = User.finalUsersArray[section].firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    
    
    
    
    
    
    
    
    
    
    // --------------------------------------------------------------------------------
    // OLD CODE BEGIN
    // --------------------------------------------------------------------------------
    /*
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
    */
    // --------------------------------------------------------------------------------
    // OLD CODE END
    // --------------------------------------------------------------------------------
    
}

