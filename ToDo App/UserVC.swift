import UIKit

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLower: UILabel!
    
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]
    
    var currentUserName: String! = "Savannah"
    var currentUserImage: UIImage! = #imageLiteral(resourceName: "Savannah.jpg")
    var currentUserIncome: String! = String(format: "%.02f", ((Double(yearlyIncomeMPS) * 0.021) + Double(yearlyIncomeOutside)) / 52)
    
    // Table data is as follows: chore name, chore multiplier, chore Consistency Bonus, chore editable?
    
    //10 daily chores
    let dailyChores = [
        ("bedroom", 1, false, true),
        ("bathrooms", 1, false, true),
    ]
    
    //10 daily habits
    let dailyHabits = [
        ("get self & buddy ready for day", 1, false, true),
        ("personal meditation (10 min)", 1, false, true),
        ("daily exercise", 1, false, true),
        ("develop talents (20 min)", 1, false, true),
        ("homework done by 5:pm", 1, false, true),
        ("good manners", 1, false, true),
        ("peacemaking (no fighting)", 1, false, true),
        ("helping hands / obedience", 1, false, true),
        ("write in journal", 1, false, true),
        ("bed by 8:pm", 1, false, true)
    ]
    
    //10 weekly chores
    let weeklyChores = [
        ("sweep porch",	2.5, false, true),
        ("weed garden",	5, false, true),
        ("babysit (per hour)", 25, false, true)
    ]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ------
        // badges
        // ------
        
        tabBarController?.tabBar.items?[2].badgeValue = "1"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = userName
        userImage.image = userPicture
        incomeLabel.text = "$\(userIncome)"
        
        userImage.layer.cornerRadius = topView.bounds.height / 6.4
        userImage.layer.masksToBounds = true
        userImage.layer.borderWidth = 0.5
        userImage.layer.borderColor = UIColor.black.cgColor
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d"        // day of year
        let result = formatter.string(from: date)
        
        // ---------------
        // Date calculator
        // ---------------
        
        func dayDifference(from interval : TimeInterval) -> String
        {
            let calendar = NSCalendar.current
            let date = Date(timeIntervalSince1970: interval)
            if calendar.isDateInYesterday(date) { return "Yesterday" }
            else if calendar.isDateInToday(date) { return "Today" }
            else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
            else {
                let startOfNow = calendar.startOfDay(for: Date())
                let startOfTimeStamp = calendar.startOfDay(for: date)
                let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
                let day = components.day!
                if day < 1 { return "\(abs(day)) days ago" }
                else { return "In \(day) days" }
            }
        }
    }
    
    
    // ----------------
    // Setup Table View
    // ----------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dailyChores.count
        } else if section == 1 {
            return dailyHabits.count
        } else {
            return weeklyChores.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily chores"
        } else if section == 1 {
            return "daily habits"
        } else {
            return "weekly chores"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
//        header.textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! UserCell
        if indexPath.section == 0 {
            let (choreHabitName, pointsLabelValue, _, _) = dailyChores[indexPath.row]
            cell.choreHabitLabel.text = choreHabitName
            cell.pointsLabel.text = "\(pointsLabelValue * 15)"
        } else if indexPath.section == 1 {
            let (choreHabitName, pointsLabelValue, _, _) = dailyHabits[indexPath.row]
            cell.choreHabitLabel.text = choreHabitName
            cell.pointsLabel.text = "\(Int(pointsLabelValue * 15))"
        } else {
            let (choreHabitName, pointsLabelValue, _, _) = weeklyChores[indexPath.row]
            cell.choreHabitLabel.text = choreHabitName
            cell.pointsLabel.text = "\(Int(pointsLabelValue * 15))"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.reloadData()
    }
    
    // -----------
    // Home Button
    // -----------
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}






