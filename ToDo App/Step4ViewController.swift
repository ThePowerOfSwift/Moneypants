import UIKit

class Step4ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // ----------------
    // Setup Table View
    // ----------------
    
    // Create array for table data
    // MARK: Data table for daily chores, etc.
    
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
    
    //set number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // set number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyChores.count
        } else {
            return weeklyChores.count
        }
    }
    
    //Give each table section a title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily chores"
        } else {
            return "weekly chores"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
        header.textLabel?.textColor = UIColor.white
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    
    // what are the contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell4", for: indexPath) as! Step4CustomCell
        if indexPath.section == 0 {
            let (dailyChoreName, _, _, _) = dailyChores[indexPath.row]
            cell.choreLabel.text = dailyChoreName
        } else {
            let (weeklyChoreName, _, _, _) = weeklyChores[indexPath.row]
            cell.choreLabel.text = weeklyChoreName
        }
        return cell
    }
    
    // ------------------------------
    // determine which cell is tapped
    // ------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section)")
        print("row: \(indexPath.row)")
    }

}






