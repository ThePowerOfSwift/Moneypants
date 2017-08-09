import UIKit

class ReportsPointsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.title = userName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    // ----------
    // Table View
    // ----------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tempDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return date1Data.count
        } else if section == 1 {
            return date2Data.count
        } else if section == 2 {
            return date3Data.count
        } else {
            return date4Data.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tempDates[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.textAlignment = .center
        header.contentView.backgroundColor = UIColor.lightGray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! ReportsPointsCell
        if indexPath.section == 0 {
            let (time, chore, points) = date1Data[indexPath.row]
            cell.timeStampLabel.text = time
            cell.choreHabitLabel.text = chore
            cell.choreHabitPointValueLabel.text = "\(points)"
        } else if indexPath.section == 1 {
            let (time, chore, points) = date2Data[indexPath.row]
            cell.timeStampLabel.text = time
            cell.choreHabitLabel.text = chore
            cell.choreHabitPointValueLabel.text = "\(points)"
        } else if indexPath.section == 2 {
            let (time, chore, points) = date3Data[indexPath.row]
            cell.timeStampLabel.text = time
            cell.choreHabitLabel.text = chore
            cell.choreHabitPointValueLabel.text = "\(points)"
        } else {
            let (time, chore, points) = date4Data[indexPath.row]
            cell.timeStampLabel.text = time
            cell.choreHabitLabel.text = chore
            cell.choreHabitPointValueLabel.text = "\(points)"
        }
        return cell
    }
    
    // Enable deleting of rows
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Create alert requiring parental passcode before deleting
            
            let alert = UIAlertController(title: "Parental Unit Warning", message: "Only parents can modify the points transactions. Please enter your parental passcode.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                if indexPath.section == 0 {
                    date1Data.remove(at: indexPath.row)
                } else if indexPath.section == 1 {
                    date2Data.remove(at: indexPath.row)
                } else if indexPath.section == 2 {
                    date3Data.remove(at: indexPath.row)
                } else {
                    date4Data.remove(at: indexPath.row)
                }
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    
    // -----------
    // Done Button
    // -----------
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
