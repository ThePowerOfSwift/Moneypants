import UIKit

class PaydayNewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dailyJobsTableView: UITableView!
    @IBOutlet weak var dailyJobsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dailyJobsTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var dailyJobsSubtotalLabel: UILabel!
    @IBOutlet weak var dailyJobsButton: UIButton!
    
    @IBOutlet weak var dailyHabitsTableView: UITableView!
    @IBOutlet weak var dailyHabitsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dailyHabitsTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var dailyHabitsSubtotalLabel: UILabel!
    @IBOutlet weak var dailyHabitsButton: UIButton!
    
    @IBOutlet weak var weeklyJobsTableView: UITableView!
    @IBOutlet weak var weeklyJobsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var weeklyJobsTableViewTop: NSLayoutConstraint!
    @IBOutlet weak var weeklyJobsSubtotalLabel: UILabel!
    @IBOutlet weak var weeklyJobsButton: UIButton!
    
    let (userName, _, _) = tempUsers[homeIndex]
    
    let customCell1Height: CGFloat = 60
    let customCell2Height: CGFloat = 139
    var tableViewRowCount: Int?
    
    var dailyJobsReviewed: Bool!
    var dailyHabitsReviewed: Bool!
    var weeklyJobsReviewed: Bool!
    
    var tableViewData: [(String, String, String, String, String, String, String, String, Int)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dailyJobsTableView.dataSource = self
        dailyJobsTableView.delegate = self
        dailyJobsTableViewTop.constant = -(dailyJobsTableView.bounds.height)
        dailyJobsTableView.isHidden = true
        dailyJobsTableView.isScrollEnabled = false
        
        dailyHabitsTableView.dataSource = self
        dailyHabitsTableView.delegate = self
        dailyHabitsTableViewTop.constant = -(dailyHabitsTableView.bounds.height)
        dailyHabitsTableView.isHidden = true
        dailyHabitsTableView.isScrollEnabled = false
        
        weeklyJobsTableView.dataSource = self
        weeklyJobsTableView.delegate = self
        weeklyJobsTableViewTop.constant = -(weeklyJobsTableView.bounds.height)
        weeklyJobsTableView.isHidden = true
        weeklyJobsTableView.isScrollEnabled = false
        
        self.navigationItem.title = userName
        dailyJobsReviewed = false
        dailyHabitsReviewed = false
        weeklyJobsReviewed = false
        
        tableViewData = tempPaydayDailyJobs
    }
    
    
    // ----------
    // Table View
    // ----------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tableViewRowCount ?? 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.dailyJobsTableView) {
            if indexPath.section == 0 {
                let cell = dailyJobsTableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! PaydayNewCellA1
                let (jobName, _, _, _, _, _, _, _, jobNumber) = (tableViewData?[indexPath.row])!
                cell.jobDesc.text = jobName
                cell.jobSubtotal.text = "\(jobNumber)"
                return cell
            } else {
                let cell = dailyJobsTableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! PaydayNewCellA2
                return cell
            }
        } else if (tableView == dailyHabitsTableView) {
            if indexPath.section == 0 {
                let cell = dailyHabitsTableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! PaydayNewCellB1
                let (jobName, _, _, _, _, _, _, _, jobNumber) = (tableViewData?[indexPath.row])!
                cell.jobDesc.text = jobName
                cell.jobSubtotal.text = "\(jobNumber)"
                return cell
            } else {
                let cell = dailyHabitsTableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! PaydayNewCellB2
                return cell
            }
        } else {
            if indexPath.section == 0 {
                let cell = weeklyJobsTableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! PaydayNewCellC1
                let (jobName, _, _, _, _, _, _, _, jobNumber) = (tableViewData?[indexPath.row])!
                cell.jobDesc.text = jobName
                cell.jobSubtotal.text = "\(jobNumber)"
                return cell
            } else {
                let cell = weeklyJobsTableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! PaydayNewCellC2
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return customCell1Height
        } else {
            return customCell2Height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
    
    
    // -----------
    // Button Taps
    // -----------
    
    // ---------------------
    // Daily Jobs Button Tap
    // ---------------------
    
    @IBAction func dailyJobsButtonTapped(_ sender: UIButton) {
        tableViewRowCount = tempPaydayDailyJobs.count
        tableViewData = tempPaydayDailyJobs
        dailyJobsReviewed = true                                // user has now reviewed the daily jobs
        dailyJobsTableView.reloadData()
        UIView.animate(withDuration: 0.25) {                    // fade subtotal out
            self.dailyJobsSubtotalLabel.alpha = 0.0
            self.dailyHabitsSubtotalLabel.alpha = 0.0
            self.weeklyJobsSubtotalLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        
        if dailyJobsTableView.isHidden {
            dailyJobsTableView.isHidden = false
            dailyJobsTableViewTop.constant = 0
            
            dailyJobsTableViewHeight.constant = dailyJobsTableView.contentSize.height
            dailyHabitsTableViewTop.constant = -(dailyHabitsTableView.bounds.height)
            weeklyJobsTableViewTop.constant = -(weeklyJobsTableView.bounds.height)
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.dailyHabitsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.weeklyJobsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyHabitsTableView.isHidden = true
                self.weeklyJobsTableView.isHidden = true
            }
        } else {
            dailyJobsTableViewTop.constant = -(dailyJobsTableView.bounds.height)        // move table back up
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.dailyJobsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyJobsTableView.isHidden = true
            }
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // -----------------------
    // Daily Habits Button Tap
    // -----------------------
    
    @IBAction func dailyHabitsButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {                    // fade subtotal out
            self.dailyJobsSubtotalLabel.alpha = 0.0
            self.dailyHabitsSubtotalLabel.alpha = 0.0
            self.weeklyJobsSubtotalLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        tableViewRowCount = tempPaydayDailyHabits.count
        tableViewData = tempPaydayDailyHabits
        dailyHabitsReviewed = true
        dailyHabitsTableView.reloadData()
        
        if dailyHabitsTableView.isHidden {
            dailyHabitsTableView.isHidden = false
            dailyHabitsTableViewTop.constant = 0
            
            dailyJobsTableViewTop.constant = -(dailyJobsTableView.bounds.height)
            dailyHabitsTableViewHeight.constant = dailyHabitsTableView.contentSize.height
            weeklyJobsTableViewTop.constant = -(weeklyJobsTableView.bounds.height)
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.dailyJobsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.weeklyJobsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyJobsTableView.isHidden = true
                self.weeklyJobsTableView.isHidden = true
            }
        } else {
            dailyHabitsTableViewTop.constant = -(dailyHabitsTableView.bounds.height)
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.dailyHabitsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyHabitsTableView.isHidden = true
                self.dailyHabitsSubtotalLabel.isHidden = false
            }
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // ----------------------
    // Weekly Jobs Button Tap
    // ----------------------
    
    @IBAction func weeklyJobsButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25) {                    // fade subtotals out
            self.dailyJobsSubtotalLabel.alpha = 0.0
            self.dailyHabitsSubtotalLabel.alpha = 0.0
            self.weeklyJobsSubtotalLabel.alpha = 0.0
            self.view.layoutIfNeeded()
        }
        tableViewRowCount = tempPaydayWeeklyJobs.count
        tableViewData = tempPaydayWeeklyJobs
        weeklyJobsReviewed = true
        weeklyJobsTableView.reloadData()
        
        if weeklyJobsTableView.isHidden {
            weeklyJobsTableView.isHidden = false
            weeklyJobsTableViewTop.constant = 0
            
            dailyJobsTableViewTop.constant = -(dailyJobsTableView.bounds.height)
            dailyHabitsTableViewTop.constant = -(dailyHabitsTableView.bounds.height)
            weeklyJobsTableViewHeight.constant = weeklyJobsTableView.contentSize.height
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.dailyJobsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.dailyHabitsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyJobsTableView.isHidden = true
                self.dailyHabitsTableView.isHidden = true
            }
        } else {
            weeklyJobsTableViewTop.constant = -(weeklyJobsTableView.bounds.height)
            UIView.animate(withDuration: 0.25) {                        // fade subtotal back in
                self.weeklyJobsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.weeklyJobsTableView.isHidden = true
                self.weeklyJobsSubtotalLabel.isHidden = false
            }
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // --------------
    // Pay Button Tap
    // --------------
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        if (!dailyJobsReviewed || !dailyHabitsReviewed || !weeklyJobsReviewed) {
            let alert = UIAlertController(title: "Premature Payment", message: "Before paying \(userName), please review daily jobs, daily habits, and weekly jobs first. You can review jobs and habits by tapping on the icons above.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}
