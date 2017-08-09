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
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
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






