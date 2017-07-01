import UIKit

class Step4ParentHabitVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // ---------
    // Variables
    // ---------
    
    // Table data is as follows: habit name, habit multiplier, habit Consistency Bonus, habit editable?
    
    //10 daily habits
    let dailyHabits = [
        ("get self ready for day", 1, false, true),
        ("personal meditation (10 min)", 1, false, true),
        ("daily exercise", 1, false, true),
        ("develop personal talents (20 min)", 1, false, true),
        ("1-on-1 with child", 1, false, true),
        ("update finances", 1, false, true),
        ("on time to events", 1, false, true),
        ("family devotional", 1, false, true),
        ("write in journal", 1, false, true),
        ("bed by 10:pm", 1, false, true)
    ]


    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // ---------------
    // Setup TableView
    // ---------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyHabits.count
    }
    
    // Give section a title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "daily habits"
    }
    
    // customize title look
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Helvetica-Bold", size: 16)
        header.textLabel?.textColor = UIColor.white
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    // what are contents of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step4ParentHabitCell
        let (dailyHabitName, _, _, _) = dailyHabits[indexPath.row]
        cell.habitLabel.text = dailyHabitName
        return cell
    }



}
