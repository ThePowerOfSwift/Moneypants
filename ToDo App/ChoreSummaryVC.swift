import UIKit

class ChoreSummaryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sectionData: [Int: [String]] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        sectionData = [0 : assignedChoresHabitsDad,
                       1 : assignedChoresHabitsMom,
                       2 : assignedChoresHabitsSavannah,
                       3 : assignedChoresHabitsAiden,
                       4 : assignedChoresHabitsSophie]
    }
    
    
    // --------------------
    // Customize Table View
    // --------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return assignedChoresHabitsDad.count
        } else if section == 1 {
            return assignedChoresHabitsMom.count
        } else if section == 2 {
            return assignedChoresHabitsSavannah.count
        } else if section == 3 {
            return assignedChoresHabitsAiden.count
        } else {
            return assignedChoresHabitsSophie.count
        }
    }
    
    // Custom header sections
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! ChoreSummaryCell
        let (userName, userImage, _) = tempUsers[section]
        cell.headerImage.image = userImage
        cell.headerLabel.text = userName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tempUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell");
        }
        
        cell!.textLabel?.text = sectionData[indexPath.section]![indexPath.row]
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        if indexPath.section == 0 {
//            cell?.textLabel?.text = assignedChoresHabitsDad[indexPath.row]
//        } else if indexPath.section == 1 {
//            cell?.textLabel?.text = assignedChoresHabitsMom[indexPath.row]
//        } else if indexPath.section == 2 {
//            cell?.textLabel?.text = assignedChoresHabitsSavannah[indexPath.row]
//        } else if indexPath.section == 3 {
//            cell?.textLabel?.text = assignedChoresHabitsAiden[indexPath.row]
//        } else {
//            cell?.textLabel?.text = assignedChoresHabitsSophie[indexPath.row]
//        }
//        return cell!
        
        
        return cell!
    }
}

