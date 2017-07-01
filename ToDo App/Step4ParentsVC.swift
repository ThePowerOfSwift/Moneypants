import UIKit

class Step4ParentsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // ---------
    // Variables
    // ---------
    
    // Table data is as follows: chore name, chore multiplier, chore Consistency Bonus, chore editable?
    
    //10 daily chores
    let dailyChores = [
        ("bedroom", 1, false, true),
        ("bathrooms", 1, false, true),
        ("laundry", 1, false, true),
        ("living room", 1, false, true),
        ("sweep & vacuum", 1, false, true),
        ("wipe table", 1, false, true),
        ("counters", 1, false, true),
        ("dishes", 1, false, true),
        ("meal prep", 1, false, true),
        ("feed pet / garbage", 1, false, true)
    ]
    
    let parentDailyChores = [
        ("job inspections", 1, false, true)
        //("kid 1-on-1 time", 1, false, true)
    ]
    
    //10 weekly chores
    let weeklyChores = [
        ("sweep porch",	2.5, false, true),
        ("weed garden",	5, false, true),
        ("wash windows", 5, false, true),
        ("dusting & cobwebs", 5, false, true),
        ("mop floors", 5, false, true),
        ("clean cabinets", 5, false, true),
        ("clean fridge", 10, false, true),
        ("wash car", 17.5, false, true),
        ("mow lawn", 25, false, true),
        ("babysit (per hour)", 25, false, true)
    ]
    
    let parentWeeklyChores = [
        //("spouse 1-on-1 time", 1, false, false),
        ("Payday", 1, false, false)
        //("planning meeting", 1, false, false)
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        header.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 16.0)
        header.textLabel?.textColor = UIColor.white
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



















