import UIKit

class PaydayDetailVC2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    let (userName, _, _) = tempUsers[homeIndex]
    let tempDailyChoresSummary = [("daily chores:", 1500),
                                  ("chore consistency bonus:", 1500),
                                  ("previous unpaid amounts:", 1500),
                                  ("subtotal:", 4500)]
    let standardRowHeight: CGFloat = 50
    let customRowHeight: CGFloat = 139
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.title = userName
        
        resizeTable()
    }
    
    
    // ----------
    // Table View
    // ----------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tempPaydayDailyChores.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // PART 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell1", for: indexPath) as! PaydayDetailCell1
            let (choreDescription, day1, day2, day3, day4, day5, day6, day7, _) = tempPaydayDailyChores[indexPath.row]
            
            cell.tallyView.layer.cornerRadius = cell.tallyView.bounds.height / 6.4
            cell.tallyView.layer.masksToBounds = true
            cell.tallyView.layer.borderColor = UIColor.lightGray.cgColor
            cell.tallyView.layer.borderWidth = 0.5
            
            cell.choreDesc.text = choreDescription
            
            cell.dayColor1.text = day1
            switch day1 {
            case "1":
                cell.dayColor1.text = ""
                cell.dayColor1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            case "X":
                cell.dayColor1.text = ""
                cell.dayColor1.backgroundColor = UIColor.red
            case "E":
                cell.dayColor1.backgroundColor = UIColor.lightGray
            default:
                cell.dayColor1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
                cell.dayColor1.textColor = UIColor.white
            }
            
            cell.dayColor2.text = day2
            switch day2 {
            case "1":
                cell.dayColor2.text = ""
                cell.dayColor2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            case "X":
                cell.dayColor2.text = ""
                cell.dayColor2.backgroundColor = UIColor.red
            case "E":
                cell.dayColor2.backgroundColor = UIColor.lightGray
            default:
                cell.dayColor2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
                cell.dayColor2.textColor = UIColor.white
            }
            
            cell.dayColor3.text = day3
            switch day3 {
            case "1":
                cell.dayColor3.text = ""
                cell.dayColor3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            case "X":
                cell.dayColor3.text = ""
                cell.dayColor3.backgroundColor = UIColor.red
            case "E":
                cell.dayColor3.backgroundColor = UIColor.lightGray
            default:
                cell.dayColor3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
                cell.dayColor3.textColor = UIColor.white
            }
            
            cell.dayColor4.text = day4
            switch day4 {
            case "1":
                cell.dayColor4.text = ""
                cell.dayColor4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            case "X":
                cell.dayColor4.text = ""
                cell.dayColor4.backgroundColor = UIColor.red
            case "E":
                cell.dayColor4.backgroundColor = UIColor.lightGray
            default:
                cell.dayColor4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
                cell.dayColor4.textColor = UIColor.white
            }
            
            cell.dayColor5.text = day5
            switch day5 {
            case "1":
                cell.dayColor5.text = ""
                cell.dayColor5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            case "X":
                cell.dayColor5.text = ""
                cell.dayColor5.backgroundColor = UIColor.red
            case "E":
                cell.dayColor5.backgroundColor = UIColor.lightGray
            default:
                cell.dayColor5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
                cell.dayColor5.textColor = UIColor.white
            }
            
            cell.dayColor6.text = day6
            switch day6 {
            case "1":
                cell.dayColor6.text = ""
                cell.dayColor6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            case "X":
                cell.dayColor6.text = ""
                cell.dayColor6.backgroundColor = UIColor.red
            case "E":
                cell.dayColor6.backgroundColor = UIColor.lightGray
            default:
                cell.dayColor6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
                cell.dayColor6.textColor = UIColor.white
            }
            
            cell.dayColor7.text = day7
            switch day7 {
            case "1":
                cell.dayColor7.text = ""
                cell.dayColor7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            case "X":
                cell.dayColor7.text = ""
                cell.dayColor7.backgroundColor = UIColor.red
            case "E":
                cell.dayColor7.backgroundColor = UIColor.lightGray
            default:
                cell.dayColor7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
                cell.dayColor7.textColor = UIColor.white
            }
            
            return cell
            
        } else {
            // PART 2
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "CustomCell2", for: indexPath) as! PaydayDetailCell2
            let (_, pointAmount) = tempDailyChoresSummary[indexPath.row]
            
            cell2.dailyChoresNumber.text = "\(pointAmount)"
            cell2.choreConsistencyBonusNumber.text = "\(pointAmount)"
            cell2.previousUnpaidAmountsNumber.text = "\(pointAmount)"
            cell2.dailyChoresSubtotalNumber.text = "\(pointAmount)"
            
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return customRowHeight
        } else {
            return standardRowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReportsPointsVC")
        navigationController?.pushViewController(vc, animated: true)
        tableView.reloadData()
    }
    
    
    // -------
    // ACTIONS
    // -------
    
    func resizeTable() {
        
        tableViewHeight.constant = (CGFloat(tempPaydayDailyChores.count) * standardRowHeight) + customRowHeight
        
        // if table height is bigger than screen, allow scrolling. otherwise, don't scroll
        if tableViewHeight.constant > 432 {
            tableView.isScrollEnabled = true
        } else {
            tableView.isScrollEnabled = false
        }
    }
    
    
    // -------------
    // Alert Message
    // -------------
    
    @IBAction func questionButtonTapped(_ sender: UIButton) {
        
        // Left justify the alert bubble
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        // Lengthy alert bubble
        let messageText = NSMutableAttributedString(
            string: "What do the colors and numbers mean?\n\n\tGreen: completed\n\tGray: excused (or not completed)\n\tRed: unexcused\n\nChores will have a number if they are completed more than once per day.",
            attributes: [
                NSParagraphStyleAttributeName : paragraphStyle,
                NSFontAttributeName : UIFont.systemFont(ofSize: 13.0),
                NSForegroundColorAttributeName : UIColor.black
            ]
        )
        
        // Not sure what this does,  but it works
        let alert = UIAlertController(title: "What does it mean?", message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        // Button one: "okay"
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}
