import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    let settingsList = ["change household income",
                        "add / remove family members",
                        "modify individual account details",
                        "modify chores & habits",
                        "reassign chores & habits",
                        "change passwords",
                        "sign out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settingsList[indexPath.row]
        return cell
    }

}
