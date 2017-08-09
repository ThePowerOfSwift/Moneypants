import UIKit

class Step3ViewController: UIViewController, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keep table view up high when nav controller loads
        self.automaticallyAdjustsScrollViewInsets = false
        
        /*
        // -------------------------
        // Check for installed fonts
        // -------------------------
        
        for family: String in UIFont.familyNames {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        */
        
    }

   
    // ----------------
    // Setup Table View
    // ----------------
    
    // Create array for table data
    // MARK: Data table for daily chores, etc.
    
    
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
        
        // Round corners on table view
        //let blackColor = UIColor.black
        //tableView.layer.borderColor = blackColor.withAlphaComponent(0.9).cgColor
        //tableView.layer.borderWidth = 0.5;
        //tableView.layer.cornerRadius = 10;
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! Step3CustomCell
        
        if indexPath.section == 0 {
            let (dailyChoreName, _, _, _) = dailyChores[indexPath.row]
            cell.choreLabel.text = dailyChoreName
        } else {
            let (weeklyChoreName, _, _, _) = weeklyChores[indexPath.row]
            cell.choreLabel.text = weeklyChoreName
        }
        return cell
    }
}





