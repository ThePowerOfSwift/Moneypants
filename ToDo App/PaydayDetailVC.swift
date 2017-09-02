import UIKit

class PaydayDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBOutlet weak var totalEarningsLabel: UILabel!
    @IBOutlet weak var questionMark: UIButton!
    
    let (userName, _, userIncome) = tempUsers[homeIndex]
    
    let customCell1Height: CGFloat = 60
    let customCell2Height: CGFloat = 139
    var tableViewRowCount: Int?
    
    var dailyJobsReviewed: Bool!
    var dailyHabitsReviewed: Bool!
    var weeklyJobsReviewed: Bool!
    
    var tableViewData: [(String, String, String, String, String, String, String, String, Int)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionMark.layer.cornerRadius = questionMark.bounds.height / 6.4
        questionMark.layer.masksToBounds = true
        
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
        totalEarningsLabel.text = "\(userIncome)"
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
        
        // ---------------------
        // DAILY JOBS TABLE VIEW
        // ---------------------
        
        if (tableView == self.dailyJobsTableView) {
            let (jobName, day1, day2, day3, day4, day5, day6, day7, jobNumber) = tempPaydayDailyJobs[indexPath.row]
            if indexPath.section == 0 {
                let cell = dailyJobsTableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! PaydayDetailCellA1
                cell.jobDesc.text = jobName
                cell.jobSubtotal.text = "\(jobNumber)"
                
//                for index in 1...5 {
//                    switch day[index] {
//                    case "1":
//                        cell.tallyDay[index].text = ""
//                        cell.tallyDay[index].backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
//                    case "X":
//                        cell.tallyDay[index].text = ""
//                        cell.tallyDay[index].backgroundColor = UIColor.red
//                    case "E":
//                        cell.tallyDay[index].backgroundColor = UIColor.lightGray
//                    default:
//                        cell.tallyDay[index].backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
//                    }
//                }
                
                
                cell.tallyDay1.text = day1
                switch day1 {
                case "":
                    cell.tallyDay1.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay1.text = ""
                    cell.tallyDay1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay1.text = ""
                    cell.tallyDay1.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay1.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay2.text = day2
                switch day2 {
                case "":
                    cell.tallyDay2.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay2.text = ""
                    cell.tallyDay2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay2.text = ""
                    cell.tallyDay2.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay2.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay3.text = day3
                switch day3 {
                case "":
                    cell.tallyDay3.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay3.text = ""
                    cell.tallyDay3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay3.text = ""
                    cell.tallyDay3.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay3.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay4.text = day4
                switch day4 {
                case "":
                    cell.tallyDay4.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay4.text = ""
                    cell.tallyDay4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay4.text = ""
                    cell.tallyDay4.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay4.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay5.text = day5
                switch day5 {
                case "":
                    cell.tallyDay5.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay5.text = ""
                    cell.tallyDay5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay5.text = ""
                    cell.tallyDay5.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay5.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay6.text = day6
                switch day6 {
                case "":
                    cell.tallyDay6.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay6.text = ""
                    cell.tallyDay6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay6.text = ""
                    cell.tallyDay6.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay6.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay7.text = day7
                switch day7 {
                case "":
                    cell.tallyDay7.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay7.text = ""
                    cell.tallyDay7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay7.text = ""
                    cell.tallyDay7.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay7.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                return cell
                
            } else {
                let cell = dailyJobsTableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! PaydayDetailCellA2
                cell.dailyJobsNumber.text = "170"
                cell.jobBonusNumber.text = "700"
                cell.dailyJobsSubtotal.text = "$8.70"
                return cell
            }
            
            
        
        // -----------------------
        // DAILY HABITS TABLE VIEW
        // -----------------------
        
        } else if (tableView == dailyHabitsTableView) {
            let (jobName, day1, day2, day3, day4, day5, day6, day7, jobNumber) = tempPaydayDailyHabits[indexPath.row]
            if indexPath.section == 0 {
                let cell = dailyHabitsTableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! PaydayDetailCellB1
                cell.jobDesc.text = jobName
                cell.jobSubtotal.text = "\(jobNumber)"
                
                cell.tallyDay1.text = day1
                switch day1 {
                case "":
                    cell.tallyDay1.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay1.text = ""
                    cell.tallyDay1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay1.text = ""
                    cell.tallyDay1.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay1.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay2.text = day2
                switch day2 {
                case "":
                    cell.tallyDay2.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay2.text = ""
                    cell.tallyDay2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay2.text = ""
                    cell.tallyDay2.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay2.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay3.text = day3
                switch day3 {
                case "":
                    cell.tallyDay3.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay3.text = ""
                    cell.tallyDay3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay3.text = ""
                    cell.tallyDay3.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay3.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay4.text = day4
                switch day4 {
                case "":
                    cell.tallyDay4.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay4.text = ""
                    cell.tallyDay4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay4.text = ""
                    cell.tallyDay4.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay4.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay5.text = day5
                switch day5 {
                case "":
                    cell.tallyDay5.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay5.text = ""
                    cell.tallyDay5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay5.text = ""
                    cell.tallyDay5.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay5.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay6.text = day6
                switch day6 {
                case "":
                    cell.tallyDay6.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay6.text = ""
                    cell.tallyDay6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay6.text = ""
                    cell.tallyDay6.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay6.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay7.text = day7
                switch day7 {
                case "":
                    cell.tallyDay7.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay7.text = ""
                    cell.tallyDay7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay7.text = ""
                    cell.tallyDay7.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay7.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                return cell
            } else {
                let cell = dailyHabitsTableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! PaydayDetailCellB2
                return cell
            }
            
            
        
        // ----------------------
        // WEEKLY JOBS TABLE VIEW
        // ----------------------
            
        } else {
            let (jobName, day1, day2, day3, day4, day5, day6, day7, jobNumber) = tempPaydayWeeklyJobs[indexPath.row]
            if indexPath.section == 0 {
                let cell = weeklyJobsTableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! PaydayDetailCellC1
                cell.jobDesc.text = jobName
                cell.jobSubtotal.text = "\(jobNumber)"
                
                switch day1 {
                case "":
                    cell.tallyDay1.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay1.text = ""
                    cell.tallyDay1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay1.text = ""
                    cell.tallyDay1.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay1.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay2.text = day2
                switch day2 {
                case "":
                    cell.tallyDay2.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay2.text = ""
                    cell.tallyDay2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay2.text = ""
                    cell.tallyDay2.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay2.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay3.text = day3
                switch day3 {
                case "":
                    cell.tallyDay3.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay3.text = ""
                    cell.tallyDay3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay3.text = ""
                    cell.tallyDay3.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay3.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay4.text = day4
                switch day4 {
                case "":
                    cell.tallyDay4.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay4.text = ""
                    cell.tallyDay4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay4.text = ""
                    cell.tallyDay4.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay4.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay5.text = day5
                switch day5 {
                case "":
                    cell.tallyDay5.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay5.text = ""
                    cell.tallyDay5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay5.text = ""
                    cell.tallyDay5.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay5.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay6.text = day6
                switch day6 {
                case "":
                    cell.tallyDay6.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay6.text = ""
                    cell.tallyDay6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay6.text = ""
                    cell.tallyDay6.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay6.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                cell.tallyDay7.text = day7
                switch day7 {
                case "":
                    cell.tallyDay7.backgroundColor = UIColor.lightGray
                case "1":
                    cell.tallyDay7.text = ""
                    cell.tallyDay7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                case "X":
                    cell.tallyDay7.text = ""
                    cell.tallyDay7.backgroundColor = UIColor.red
                case "E":
                    cell.tallyDay7.backgroundColor = UIColor.lightGray
                default:
                    cell.tallyDay7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0)
                }
                
                return cell
            } else {
                let cell = weeklyJobsTableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! PaydayDetailCellC2
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
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReportsPointsVC")
        navigationController?.present(vc, animated: true)
        tableView.reloadData()
    }
    
    
    // -----------
    // Button Taps
    // -----------
    
    // -----------------
    // Daily Jobs Button
    // -----------------
    
    @IBAction func dailyJobsButtonTapped(_ sender: UIButton) {
        tableViewRowCount = tempPaydayDailyJobs.count
        tableViewData = tempPaydayDailyJobs
        dailyJobsButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor
        dailyJobsReviewed = true                                // user has now reviewed the daily jobs
        dailyJobsTableView.reloadData()
        
        if dailyJobsTableView.isHidden {
            dailyJobsTableView.isHidden = false
            dailyJobsTableViewTop.constant = 0
            
            dailyJobsTableViewHeight.constant = dailyJobsTableView.contentSize.height       // show tapped table
            dailyHabitsTableViewTop.constant = -(dailyHabitsTableView.bounds.height)        // hide other tables
            weeklyJobsTableViewTop.constant = -(weeklyJobsTableView.bounds.height)
            UIView.animate(withDuration: 0.25) {                                            // fade all subtotals out
                self.dailyJobsSubtotalLabel.alpha = 0.0
                self.dailyHabitsSubtotalLabel.alpha = 0.0
                self.weeklyJobsSubtotalLabel.alpha = 0.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyHabitsTableView.isHidden = true
                self.weeklyJobsTableView.isHidden = true
            }
        } else {
            dailyJobsTableViewTop.constant = -(dailyJobsTableView.bounds.height)        // move table back up
            UIView.animate(withDuration: 0.25) {                                        // fade subtotals back in
                self.dailyJobsSubtotalLabel.alpha = 1.0
                self.dailyHabitsSubtotalLabel.alpha = 1.0
                self.weeklyJobsSubtotalLabel.alpha = 1.0
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
    
    // -------------------
    // Daily Habits Button
    // -------------------
    
    @IBAction func dailyHabitsButtonTapped(_ sender: UIButton) {
        tableViewRowCount = tempPaydayDailyHabits.count
        tableViewData = tempPaydayDailyHabits
        dailyHabitsButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor
        dailyHabitsReviewed = true
        dailyHabitsTableView.reloadData()
        
        if dailyHabitsTableView.isHidden {
            dailyHabitsTableView.isHidden = false
            dailyHabitsTableViewTop.constant = 0
            
            dailyJobsTableViewTop.constant = -(dailyJobsTableView.bounds.height)
            dailyHabitsTableViewHeight.constant = dailyHabitsTableView.contentSize.height
            weeklyJobsTableViewTop.constant = -(weeklyJobsTableView.bounds.height)
            UIView.animate(withDuration: 0.25) {                                            // fade all subtotals out
                self.dailyJobsSubtotalLabel.alpha = 0.0
                self.dailyHabitsSubtotalLabel.alpha = 0.0
                self.weeklyJobsSubtotalLabel.alpha = 0.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyJobsTableView.isHidden = true
                self.weeklyJobsTableView.isHidden = true
            }
        } else {
            dailyHabitsTableViewTop.constant = -(dailyHabitsTableView.bounds.height)
            UIView.animate(withDuration: 0.25) {                                        // fade subtotals back in
                self.dailyJobsSubtotalLabel.alpha = 1.0
                self.dailyHabitsSubtotalLabel.alpha = 1.0
                self.weeklyJobsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyHabitsTableView.isHidden = true
            }
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // ------------------
    // Weekly Jobs Button
    // ------------------
    
    @IBAction func weeklyJobsButtonTapped(_ sender: UIButton) {
        tableViewRowCount = tempPaydayWeeklyJobs.count
        tableViewData = tempPaydayWeeklyJobs
        weeklyJobsButton.layer.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1.0).cgColor
        weeklyJobsReviewed = true
        weeklyJobsTableView.reloadData()
        
        if weeklyJobsTableView.isHidden {
            weeklyJobsTableView.isHidden = false
            weeklyJobsTableViewTop.constant = 0
            
            dailyJobsTableViewTop.constant = -(dailyJobsTableView.bounds.height)
            dailyHabitsTableViewTop.constant = -(dailyHabitsTableView.bounds.height)
            weeklyJobsTableViewHeight.constant = weeklyJobsTableView.contentSize.height
            UIView.animate(withDuration: 0.25) {                                            // fade all subtotals out
                self.dailyJobsSubtotalLabel.alpha = 0.0
                self.dailyHabitsSubtotalLabel.alpha = 0.0
                self.weeklyJobsSubtotalLabel.alpha = 0.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.dailyJobsTableView.isHidden = true
                self.dailyHabitsTableView.isHidden = true
            }
        } else {
            weeklyJobsTableViewTop.constant = -(weeklyJobsTableView.bounds.height)
            UIView.animate(withDuration: 0.25) {                                        // fade subtotals back in
                self.dailyJobsSubtotalLabel.alpha = 1.0
                self.dailyHabitsSubtotalLabel.alpha = 1.0
                self.weeklyJobsSubtotalLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.weeklyJobsTableView.isHidden = true
            }
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    // ---------------
    // Question Button
    // ---------------
    
    @IBAction func questionButtonTapped(_ sender: UIButton) {
        
        // Left justify the alert bubble
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        // Lengthy alert bubble
        let messageText = NSMutableAttributedString(
            string: "What do the colors and numbers mean?\n\n\tGreen: completed\n\tGray: excused (or not completed)\n\tRed: unexcused\n\nJobs and habits will be green if they have been completed once. If they are completed more than once per day, they will be green and have a number for times completed.",
            attributes: [
                NSParagraphStyleAttributeName : paragraphStyle,
                NSFontAttributeName : UIFont.systemFont(ofSize: 13.0),
                NSForegroundColorAttributeName : UIColor.black
            ]
        )
        
        // Not sure what this does,  but it works
        let alert = UIAlertController(title: "Color Code", message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        // Button one: "okay"
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // ----------
    // Pay Button
    // ----------
    
    @IBAction func payButtonTapped(_ sender: UIButton) {
        
        // Don't allow user to proceed unless they're reviewed the jobs and habits
        if (!dailyJobsReviewed || !dailyHabitsReviewed || !weeklyJobsReviewed) {
            let alert = UIAlertController(title: "Payday Error", message: "Before paying \(userName), please review the daily jobs, daily habits, and weekly jobs first. You can review jobs and habits by tapping on the icons above.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "okay", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // If user has reviewed the daily jobs and habits, then proceed
        // Collapse all tableviews and then hide them
        dailyJobsTableViewTop.constant = -(dailyJobsTableView.bounds.height)
        dailyHabitsTableViewTop.constant = -(dailyHabitsTableView.bounds.height)
        weeklyJobsTableViewTop.constant = -(weeklyJobsTableView.bounds.height)
        UIView.animate(withDuration: 0.25) {                                        // fade subtotals back in
            self.dailyJobsSubtotalLabel.alpha = 1.0
            self.dailyHabitsSubtotalLabel.alpha = 1.0
            self.weeklyJobsSubtotalLabel.alpha = 1.0
            self.view.layoutIfNeeded()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.dailyJobsTableView.isHidden = true
            self.dailyHabitsTableView.isHidden = true
            self.weeklyJobsTableView.isHidden = true
        }
        
        // First, format the numbers to be called inside the alert dialogue box
        let tenPercent = String(format: "%.2f", (Double(userIncome)! * 0.1))
        let seventyPercent = String(format: "%.2f", (Double(userIncome)! * 0.7))
        
        // Left justify the alert bubble
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        // Lengthy alert bubble
        let messageText = NSMutableAttributedString(
            string: "\(userName) earned $\(userIncome) this week. \n \nBe sure to compliment progress. \n \n\(userName)'s money will be allocated like this: \n \n$\(tenPercent) (10% charity) \n$\(tenPercent) (10% personal money) \n$\(tenPercent) (10% long-term savings) \n \n$\(seventyPercent) (70% expenses) \n \nWhen you are done paying \(userName), tap 'okay'. This will zero out the account to start a new week. You can still see all \(userName)'s transactions on the 'reports' page.",
            attributes: [
                NSParagraphStyleAttributeName : paragraphStyle,
                NSFontAttributeName : UIFont.systemFont(ofSize: 13.0),
                NSForegroundColorAttributeName : UIColor.black
            ]
        )
        
        // Not sure what this does,  but it works
        let alert = UIAlertController(title: "\(userName)'s Payday", message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        // Button one: "pay user $x.xx"
        alert.addAction(UIAlertAction(title: "pay \(userName) $\(userIncome)", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // ---------------------
            // Second Alert for Fees
            // ---------------------
            
            let feesAlert = UIAlertController(title: "\(self.userName)'s Fees", message: "\(self.userName) incurred one or more fees this week, totalling $1.50:\n\n$1.00 fighting\n$0.50 broken fence\n\n\(self.userName) should pay any fees immediately with the payday money just earned.", preferredStyle: .alert)
            feesAlert.addAction(UIAlertAction(title: "collect $1.50 from \(self.userName)", style: .default, handler: {_ in
                CATransaction.setCompletionBlock({
                    let _ = self.navigationController?.popViewController(animated: true)        // return to previous screen
                })
                feesAlert.dismiss(animated: true, completion: nil)
            }))
            feesAlert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                feesAlert.dismiss(animated: true, completion: nil)
            }))
            self.present(feesAlert, animated: true, completion: nil)
        }))
        
        // Button two: "cancel"
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
        
    }
}
