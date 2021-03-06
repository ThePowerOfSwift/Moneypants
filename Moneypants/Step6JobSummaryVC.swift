import UIKit
import Firebase

class Step6JobSummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var oldestFirstArray: [MPUser]!
    
    var firebaseUser: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        ref = Database.database().reference().child("users").child(firebaseUser.uid)
        
        oldestFirstArray = MPUser.usersArray.sorted(by: { $0.birthday < $1.birthday })        // create array with oldest members first
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return oldestFirstArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dailyJobAssignments = JobsAndHabits.finalDailyJobsArray.filter({ return $0.assigned == oldestFirstArray[section].firstName }).count
        let weeklyJobAssignments = JobsAndHabits.finalWeeklyJobsArray.filter({ return $0.assigned == oldestFirstArray[section].firstName }).count
        let parentInspectionsAssignment = JobsAndHabits.parentalDailyJobsArray.filter({ return $0.assigned == oldestFirstArray[section].firstName }).count
        let parentPaydayAssignment = JobsAndHabits.parentalWeeklyJobsArray.filter({ return $0.assigned == oldestFirstArray[section].firstName }).count
        
        return dailyJobAssignments + weeklyJobAssignments + parentInspectionsAssignment + parentPaydayAssignment
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! Step6Step6JobSummaryCellB
        
        // get the job assignments in the 'finalDailyJobs' array that matches the current user in the tableview
        let dailyJobAssignments = JobsAndHabits.finalDailyJobsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == oldestFirstArray[indexPath.section].firstName })
        let weeklyJobAssignments = JobsAndHabits.finalWeeklyJobsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == oldestFirstArray[indexPath.section].firstName })
        let parentInspectionsAssignment = JobsAndHabits.parentalDailyJobsArray.sorted(by: { $0.order < $1.order }).filter({ return $0.assigned == oldestFirstArray[indexPath.section].firstName })
        let parentPaydayAssignment = JobsAndHabits.parentalWeeklyJobsArray.sorted(by: { $0.order < $1.order }).filter({ $0.assigned == oldestFirstArray[indexPath.section].firstName })
        let jobAssignments = dailyJobAssignments + parentInspectionsAssignment + weeklyJobAssignments + parentPaydayAssignment
        cell.userNameLabel.text = jobAssignments[indexPath.row].name
        
        
        let dailyJobsArray = JobsAndHabits.finalDailyJobsArray + JobsAndHabits.parentalDailyJobsArray       // combine the two daily jobs arrays
        
        if dailyJobsArray.contains(where: { $0.name == jobAssignments[indexPath.row].name }) {
            cell.dailyWeeklyLabel.text = "daily"
            cell.dailyWeeklyLabel.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0)
        } else {
            cell.dailyWeeklyLabel.text = "weekly"
            cell.dailyWeeklyLabel.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1.0)
        }
        cell.dailyWeeklyLabel.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! Step6JobSummaryCell
        cell.headerImage.image = oldestFirstArray[section].photo
        cell.headerLabel.text = oldestFirstArray[section].firstName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if FamilyData.setupProgress <= 6 {
            FamilyData.setupProgress = 6
            ref.updateChildValues(["setupProgress" : 6])
        }
        performSegue(withIdentifier: "DailyHabits", sender: self)
    }
}

