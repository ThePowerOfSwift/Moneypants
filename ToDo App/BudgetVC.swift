import UIKit

class BudgetVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView1: UITableView!
    @IBOutlet weak var tableView1Top: NSLayoutConstraint!
    @IBOutlet weak var tableView1Height: NSLayoutConstraint!

    @IBOutlet weak var funMoneyButton: UIButton!
    @IBOutlet weak var savingsButton: UIButton!
    @IBOutlet weak var donationsButton: UIButton!
    @IBOutlet weak var clothingButton: UIButton!
    @IBOutlet weak var accessoriesButton: UIButton!
    @IBOutlet weak var sportsDanceButton: UIButton!
    
    var tableView1RowCount: Int?
    var tableView1Data: [String]?
    
    let (userName, userPicture, userIncome) = tempUsers[homeIndex]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView1.delegate = self
        tableView1.dataSource = self
//        tableView1.isHidden = true
        
        navigationItem.title = userName
//        tableView1Top.constant = -(tableView1.bounds.height)
    }
    
    
    // ----------
    // Table View
    // ----------
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
//        header.textLabel?.textColor = UIColor.white
//        header.textLabel?.textAlignment = .center
//        header.contentView.backgroundColor = UIColor.lightGray
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView1RowCount ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! BudgetCell
        cell.dollarLabel.text = "$43"
        cell.envelopeLabel.text = tableView1Data?[indexPath.row]
        return cell
    }
    
   
    
    // -----------
    // Button Taps
    // -----------
    
    // Button Taps
    @IBAction func funMoneyButtonTapped(_ sender: UIButton) {
        tableView1RowCount = accessoriesEnvelope.count
        tableView1Data = accessoriesEnvelope
        tableView1.reloadData()
        
        funMoneyButton.isSelected = true
        savingsButton.isSelected = false
        donationsButton.isSelected = false
        
        
        //        tableView1Height.constant = tableView1.contentSize.height
        //        if tableView1.isHidden == true {
        //            tableView1.isHidden = false
        //            tableView1Top.constant = 0
        //            UIView.animate(withDuration: 0.25) {
        //                self.view.layoutIfNeeded()
        //            }
        //        } else {
        //            tableView1Top.constant = -(tableView1.bounds.height)
        //            funMoneyButton.isSelected = false
        //            UIView.animate(withDuration: 0.25, animations: {
        //                self.view.layoutIfNeeded()
        //            })
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        //                self.tableView1.isHidden = true
        //            }
        //        }
    }
    
    @IBAction func savingsButtonTapped(_ sender: UIButton) {
        tableView1RowCount = clothingEnvelope.count
        tableView1Data = clothingEnvelope
        tableView1.reloadData()
        
        funMoneyButton.isSelected = false
        savingsButton.isSelected = true
        donationsButton.isSelected = false
        
        
        //        if tableView1.isHidden {
        //            tableView1.isHidden = false
        //        }
        //check if tableview is hidden or not. If it's hidden, show it with the updated data. If it's not hidden, hide it, then show it again with the updated data
        
        
        
    }
    
    @IBAction func donationsButton(_ sender: UIButton) {
        tableView1RowCount = sportsEnvelope.count
        tableView1Data = sportsEnvelope
        tableView1.reloadData()
        
        funMoneyButton.isSelected = false
        savingsButton.isSelected = false
        donationsButton.isSelected = true
        
        
    }
    

    
    
    
    
    
    
    
    
    
    
    // -----------
    // Home Button
    // -----------
    
    @IBAction func homeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
