import UIKit

class ReportsCBVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationBar.topItem?.title = userName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    // ----------------
    // Setup Table View
    // ----------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily jobs"
        } else {
            return "daily habits"
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyJobs.count
        } else {
            return dailyHabits.count
        }
    }
    
    
    // Hide rows that don't have any consistency bonuses
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            let number = tempJobsCB[indexPath.row]
//            if number == 0 {
//                return 0
//            } else {
//                return 50
//            }
//        } else {
//            let number = tempHabitsCB[indexPath.row]
//            if number == 0 {
//                return 0
//            } else {
//                return 50
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! ReportsCBCell
        if indexPath.section == 0 {
            let (jobName, _, _, _) = dailyJobs[indexPath.row]
            let cbNumber = tempJobsCB[indexPath.row]
            cell.jobHabitLabel.text = jobName
            cell.jobHabitCBCount.text = "\(tempJobsCB[indexPath.row])"
            cell.coloredBar.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1)
            if cbNumber < 26 {
                cell.coloredBarWidthConstraint.constant = cell.grayGrid.bounds.width * CGFloat(cbNumber) / 26
            } else {
                cell.coloredBarWidthConstraint.constant = cell.grayGrid.bounds.width        //keeps bars from extending past 26 little squares
            }
            if cbNumber >= 26 {
                cell.numberOfWeeksBox.backgroundColor = UIColor(red: 0/255, green: 153/255, blue: 255/255, alpha: 1)
            }
        } else {
            let (jobName, _, _, _) = dailyHabits[indexPath.row]
            let cbNumber = tempHabitsCB[indexPath.row]
            cell.jobHabitLabel.text = jobName
            cell.jobHabitCBCount.text = "\(tempHabitsCB[indexPath.row])"
            cell.coloredBar.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1)
            if cbNumber < 26 {
                cell.coloredBarWidthConstraint.constant = cell.grayGrid.bounds.width * CGFloat(cbNumber) / 26
            } else {
                cell.coloredBarWidthConstraint.constant = cell.grayGrid.bounds.width
            }
            if cbNumber >= 26 {
                cell.numberOfWeeksBox.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1)
            }
        }
        return cell
    }
    
    
    // If user taps on cell, refresh table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    
    // -------------
    // Alert Message
    // -------------
    
    @IBAction func definitionButtonTapped(_ sender: UIButton) {
        
        // Left justify the alert bubble
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        // Lengthy alert bubble
        let messageText = NSMutableAttributedString(
            string: "The purpose of this tool is to make sure children have mastered all the skills necessary to be independent by the time they leave home.\n\nEach time an individual does their job or habit for an entire week without missing a day, they achieve one 'consistency bonus'.\n\nEach bonus is represented by a progress bar below the job or habit and is tallied in the box on the right.\n\nOnce a user has earned 26 consistency bonuses in a particular job or habit, they have officially 'mastered' that job or habit, and they can then get a new job assignment or change what habits they are working on.\n\nIt means they have gone 26 weeks (or half a year) earning their consistency bonus, and they have mastered that particular job or skill.\n\nParents may wish to attach extra rewards for children achieving job or habit mastery within a year.",
            attributes: [
                NSParagraphStyleAttributeName : paragraphStyle,
                NSFontAttributeName : UIFont.systemFont(ofSize: 13.0),
                NSForegroundColorAttributeName : UIColor.black
            ]
        )
        
        // Not sure what this does,  but it works
        let alert = UIAlertController(title: "Consistency Bonus", message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        // Button one: "okay"
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}





