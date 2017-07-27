import UIKit

class PaydayDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let (userName, _, userIncome) = tempUsers[paydayIndex]
        incomeLabel.text = "$\(userIncome)"
        
        self.navigationItem.title = userName
    }
    
    // ----------
    // Table View
    // ----------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tempPaydayDailyChores.count
        } else if section == 1 {
            return tempPaydayDailyHabits.count
        } else if section == 2 {
            return tempPaydayWeeklyChores.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "daily chores"
        } else if section == 1 {
            return "daily habits"
        } else if section == 2 {
            return "weekly chores"
        } else {
            return "consistency bonus"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! PaydayDetailCell
        
        cell.tallyView.layer.cornerRadius = cell.tallyView.bounds.height / 6.4
        cell.tallyView.layer.masksToBounds = true
        cell.tallyView.layer.borderColor = UIColor.lightGray.cgColor
        cell.tallyView.layer.borderWidth = 0.5
        
        if indexPath.section == 0 {
            let (choreDesc, lab1, lab2, lab3, lab4, lab5, lab6, lab7, choreNum) = tempPaydayDailyChores[indexPath.row]
            cell.choreHabitDesc.text = choreDesc
            cell.lab1.text = lab1
            cell.lab2.text = lab2
            cell.lab3.text = lab3
            cell.lab4.text = lab4
            cell.lab5.text = lab5
            cell.lab6.text = lab6
            cell.lab7.text = lab7
            cell.choreHabitTotal.text = "\(choreNum)"
        } else if indexPath.section == 1 {
            let (habitDesc, lab1, lab2, lab3, lab4, lab5, lab6, lab7, habitNum) = tempPaydayDailyHabits[indexPath.row]
            cell.choreHabitDesc.text = habitDesc
            cell.lab1.text = lab1
            cell.lab2.text = lab2
            cell.lab3.text = lab3
            cell.lab4.text = lab4
            cell.lab5.text = lab5
            cell.lab6.text = lab6
            cell.lab7.text = lab7
            cell.choreHabitTotal.text = "\(habitNum)"
        } else if indexPath.section == 2 {
            let (weeklyDesc, lab1, lab2, lab3, lab4, lab5, lab6, lab7, weeklyNum) = tempPaydayWeeklyChores[indexPath.row]
            cell.choreHabitDesc.text = weeklyDesc
            cell.lab1.text = lab1
            cell.lab2.text = lab2
            cell.lab3.text = lab3
            cell.lab4.text = lab4
            cell.lab5.text = lab5
            cell.lab6.text = lab6
            cell.lab7.text = lab7
            cell.choreHabitTotal.text = "\(weeklyNum)"
        } else {
            cell.choreHabitDesc.text = "consistency bonus"
            cell.choreHabitTotal.text = "1000"
            cell.tallyView.isHidden = true
        }
        return cell
    }
    
}




