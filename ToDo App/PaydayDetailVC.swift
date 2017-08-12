import UIKit

class PaydayDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let (userName, _, userIncome) = tempUsers[homeIndex]
    let headerData: [(String, UIImage)] = [("daily chores", #imageLiteral(resourceName: "broom white")),
                                           ("daily habits", #imageLiteral(resourceName: "toothbrush white")),
                                           ("weekly chores", #imageLiteral(resourceName: "lawnmower white")),
                                           ("job bonus", #imageLiteral(resourceName: "broom plus white")),
                                           ("habit bonus", #imageLiteral(resourceName: "toothbrush plus white")),
                                           ("fees & withdrawals", #imageLiteral(resourceName: "dollar minus white"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        incomeLabel.text = "$\(userIncome)"
        self.navigationItem.title = userName
    }
    
    // ----------
    // Table View
    // ----------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tempPaydayDailyChores.count
        } else if section == 1 {
            return tempPaydayDailyHabits.count
        } else if section == 2 {
            return tempPaydayWeeklyChores.count
        } else if section == 5 {
            return fees.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let (headerLabel, _) = headerData[section]
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let (headerLabel2, headerImage2) = headerData[section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCustomCell") as! PaydayDetailHeaderCell
        cell.headerLabel.text = headerLabel2
        cell.headerImage.image = headerImage2
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.font = UIFont(name: "Arista2.0", size: 20.0)
//        header.textLabel?.textColor = UIColor.white
//        header.textLabel?.textAlignment = .center
//        header.contentView.backgroundColor = UIColor.lightGray
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! PaydayDetailCell
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "BonusCustomCell", for: indexPath) as! PaydayDetailBonusCell
        
        cell.tallyView.layer.cornerRadius = cell.tallyView.bounds.height / 6.4
        cell.tallyView.layer.masksToBounds = true
        cell.tallyView.layer.borderColor = UIColor.lightGray.cgColor
        cell.tallyView.layer.borderWidth = 0.5
        
        // ------------
        // DAILY CHORES
        // ------------
        
        if indexPath.section == 0 {
            let (choreDesc, label1, label2, label3, label4, label5, label6, label7, choreNum) = tempPaydayDailyChores[indexPath.row]
            cell.choreHabitDesc.text = choreDesc
            
            cell.lab1.text = label1
            switch label1 {
            case "X":
                cell.lab1.backgroundColor = UIColor.red
            case "E":
                cell.lab1.backgroundColor = UIColor.lightGray
            case "":
                cell.lab1.backgroundColor = UIColor.lightGray
            default:
                cell.lab1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab2.text = label2
            switch label2 {
            case "X":
                cell.lab2.backgroundColor = UIColor.red
            case "E":
                cell.lab2.backgroundColor = UIColor.lightGray
            case "":
                cell.lab2.backgroundColor = UIColor.lightGray
            default:
                cell.lab2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }

            cell.lab3.text = label3
            switch label3 {
            case "X":
                cell.lab3.backgroundColor = UIColor.red
            case "E":
                cell.lab3.backgroundColor = UIColor.lightGray
            case "":
                cell.lab3.backgroundColor = UIColor.lightGray
            default:
                cell.lab3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }

            cell.lab4.text = label4
            switch label4 {
            case "X":
                cell.lab4.backgroundColor = UIColor.red
            case "E":
                cell.lab4.backgroundColor = UIColor.lightGray
            case "":
                cell.lab4.backgroundColor = UIColor.lightGray
            default:
                cell.lab4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }

            cell.lab5.text = label5
            switch label5 {
            case "X":
                cell.lab5.backgroundColor = UIColor.red
            case "E":
                cell.lab5.backgroundColor = UIColor.lightGray
            case "":
                cell.lab5.backgroundColor = UIColor.lightGray
            default:
                cell.lab5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }

            cell.lab6.text = label6
            switch label6 {
            case "X":
                cell.lab6.backgroundColor = UIColor.red
            case "E":
                cell.lab6.backgroundColor = UIColor.lightGray
            case "":
                cell.lab6.backgroundColor = UIColor.lightGray
            default:
                cell.lab6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }

            cell.lab7.text = label7
            switch label7 {
            case "X":
                cell.lab7.backgroundColor = UIColor.red
            case "E":
                cell.lab7.backgroundColor = UIColor.lightGray
            case "":
                cell.lab7.backgroundColor = UIColor.lightGray
            default:
                cell.lab7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }

            cell.choreHabitTotal.text = "\(choreNum)"
            
        // ------------
        // DAILY HABITS
        // ------------
        
        } else if indexPath.section == 1 {
            let (habitDesc, label1, label2, label3, label4, label5, label6, label7, habitNum) = tempPaydayDailyHabits[indexPath.row]
            cell.choreHabitDesc.text = habitDesc
            
            cell.lab1.text = label1
            switch label1 {
            case "X":
                cell.lab1.backgroundColor = UIColor.red
            case "E":
                cell.lab1.backgroundColor = UIColor.lightGray
            case "":
                cell.lab1.backgroundColor = UIColor.lightGray
            default:
                cell.lab1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab2.text = label2
            switch label2 {
            case "X":
                cell.lab2.backgroundColor = UIColor.red
            case "E":
                cell.lab2.backgroundColor = UIColor.lightGray
            case "":
                cell.lab2.backgroundColor = UIColor.lightGray
            default:
                cell.lab2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab3.text = label3
            switch label3 {
            case "X":
                cell.lab3.backgroundColor = UIColor.red
            case "E":
                cell.lab3.backgroundColor = UIColor.lightGray
            case "":
                cell.lab3.backgroundColor = UIColor.lightGray
            default:
                cell.lab3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab4.text = label4
            switch label4 {
            case "X":
                cell.lab4.backgroundColor = UIColor.red
            case "E":
                cell.lab4.backgroundColor = UIColor.lightGray
            case "":
                cell.lab4.backgroundColor = UIColor.lightGray
            default:
                cell.lab4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab5.text = label5
            switch label5 {
            case "X":
                cell.lab5.backgroundColor = UIColor.red
            case "E":
                cell.lab5.backgroundColor = UIColor.lightGray
            case "":
                cell.lab5.backgroundColor = UIColor.lightGray
            default:
                cell.lab5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab6.text = label6
            switch label6 {
            case "X":
                cell.lab6.backgroundColor = UIColor.red
            case "E":
                cell.lab6.backgroundColor = UIColor.lightGray
            case "":
                cell.lab6.backgroundColor = UIColor.lightGray
            default:
                cell.lab6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab7.text = label7
            switch label7 {
            case "X":
                cell.lab7.backgroundColor = UIColor.red
            case "E":
                cell.lab7.backgroundColor = UIColor.lightGray
            case "":
                cell.lab7.backgroundColor = UIColor.lightGray
            default:
                cell.lab7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.choreHabitTotal.text = "\(habitNum)"
            
        // -------------
        // WEEKLY CHORES
        // -------------
        
        } else if indexPath.section == 2 {
            let (weeklyDesc, label1, label2, label3, label4, label5, label6, label7, weeklyNum) = tempPaydayWeeklyChores[indexPath.row]
            cell.choreHabitDesc.text = weeklyDesc
            
            cell.lab1.text = label1
            switch label1 {
            case "X":
                cell.lab1.backgroundColor = UIColor.red
            case "E":
                cell.lab1.backgroundColor = UIColor.lightGray
            case "":
                cell.lab1.backgroundColor = UIColor.lightGray
            default:
                cell.lab1.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab2.text = label2
            switch label2 {
            case "X":
                cell.lab2.backgroundColor = UIColor.red
            case "E":
                cell.lab2.backgroundColor = UIColor.lightGray
            case "":
                cell.lab2.backgroundColor = UIColor.lightGray
            default:
                cell.lab2.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab3.text = label3
            switch label3 {
            case "X":
                cell.lab3.backgroundColor = UIColor.red
            case "E":
                cell.lab3.backgroundColor = UIColor.lightGray
            case "":
                cell.lab3.backgroundColor = UIColor.lightGray
            default:
                cell.lab3.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab4.text = label4
            switch label4 {
            case "X":
                cell.lab4.backgroundColor = UIColor.red
            case "E":
                cell.lab4.backgroundColor = UIColor.lightGray
            case "":
                cell.lab4.backgroundColor = UIColor.lightGray
            default:
                cell.lab4.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab5.text = label5
            switch label5 {
            case "X":
                cell.lab5.backgroundColor = UIColor.red
            case "E":
                cell.lab5.backgroundColor = UIColor.lightGray
            case "":
                cell.lab5.backgroundColor = UIColor.lightGray
            default:
                cell.lab5.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab6.text = label6
            switch label6 {
            case "X":
                cell.lab6.backgroundColor = UIColor.red
            case "E":
                cell.lab6.backgroundColor = UIColor.lightGray
            case "":
                cell.lab6.backgroundColor = UIColor.lightGray
            default:
                cell.lab6.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            
            cell.lab7.text = label7
            switch label7 {
            case "X":
                cell.lab7.backgroundColor = UIColor.red
            case "E":
                cell.lab7.backgroundColor = UIColor.lightGray
            case "":
                cell.lab7.backgroundColor = UIColor.lightGray
            default:
                cell.lab7.backgroundColor = UIColor(red: 141/255, green: 198/255, blue: 63/255, alpha: 1)
            }
            cell.choreHabitTotal.text = "\(weeklyNum)"
            
            
        // -----------------
        // JOB & HABIT BONUS
        // -----------------
            
        } else if indexPath.section == 3 {
            cell.choreHabitDesc.text = "job bonus"
            cell.choreHabitTotal.text = "500"
            cell.tallyView.isHidden = true
            

        // -----------
        // HABIT BONUS
        // -----------
            
        } else if indexPath.section == 4 {
            cell.choreHabitDesc.text = "habit bonus"
            cell.choreHabitTotal.text = "500"
            cell.tallyView.isHidden = true
            
        // ------------------
        // FEES & WITHDRAWALS
        // ------------------
        
        } else {
            cell.choreHabitDesc.text = fees[indexPath.row]
            cell.choreHabitTotal.text = "100"
            cell.tallyView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ReportsPointsVC")
        navigationController?.pushViewController(vc, animated: true)
        tableView.reloadData()
    }
    
    
    // -------------
    // Alert Message
    // -------------
    
    @IBAction func paydayButtonTapped(_ sender: UIButton) {
        
        // First, format the numbers to be called inside the alert dialogue box
        let tenPercent = String(format: "%.2f", (Double(userIncome)! * 0.1))
        let seventyPercent = String(format: "%.2f", (Double(userIncome)! * 0.7))
        
        // Left justify the alert bubble
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left

        // Lengthy alert bubble
        let messageText = NSMutableAttributedString(
            string: "\(userName) earned $\(userIncome) this week. \n \nBe sure to compliment progress. \n \n\(userName)'s money will be allocated like this: \n \n$\(tenPercent) (10% charity) \n$\(tenPercent) (10% personal money) \n$\(tenPercent) (10% long-term savings) \n \n$\(seventyPercent) (70% expenses) \n \nWhen you are done paying them, tap 'okay'. This will zero out their account. You can still see all their transactions on the 'reports' page.",
            attributes: [
                NSParagraphStyleAttributeName : paragraphStyle,
                NSFontAttributeName : UIFont.systemFont(ofSize: 13.0),
                NSForegroundColorAttributeName : UIColor.black
            ]
        )
        
        // Not sure what this does,  but it works
        let alert = UIAlertController(title: "\(userName)'s payday", message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        
        // Button one: "okay"
        alert.addAction(UIAlertAction(title: "Okay. Pay \(userName) $\(userIncome)", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }))
        
        // Button two: "cancel"
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
}





