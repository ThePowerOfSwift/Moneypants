import UIKit

extension UserVC {
    
    func runExcusedUnexcusedDialogueForDailyJob(alertTitle: String, alertMessage: String, isoArray: [Points], indexPath: IndexPath, assignEorX: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        // --------------------
        // Button ONE: "accept"
        // --------------------
        
        alert.addAction(UIAlertAction(title: "accept", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // -----------------
            // Choose substitute
            // -----------------
            
            let alert2 = UIAlertController(title: "Job Substitute", message: "Who was the job substitute for \(self.currentUserName!)'s job '\(self.usersDailyJobs[indexPath.row].name)'?", preferredStyle: UIAlertControllerStyle.alert)
            for user in MPUser.usersArray {
                alert2.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                    alert2.dismiss(animated: true, completion: nil)
                    
                    // ---------------------------
                    // Confirm / Cancel substitute
                    // ---------------------------
                    
                    self.confirmOrCancelSubstituteForDailyJob(isoArray: isoArray, nameOfSub: user.firstName, eORx: assignEorX, indexPath: indexPath)
                }))
            }
            
            // -------------
            // NO substitute
            // -------------
            
            alert2.addAction(UIAlertAction(title: "None", style: .cancel, handler: { (action) in
                let alert3 = UIAlertController(title: "Job Substitute Missing", message: "You have not chosen a job substitute for \(self.currentUserName!)'s job '\(self.usersDailyJobs[indexPath.row].name)'.\n\nNobody will get paid for doing this job and it will remain undone. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
                alert3.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                    // do nothing
                    self.tableView.setEditing(false, animated: true)
                    alert3.dismiss(animated: true, completion: nil)}))
                alert3.addAction(UIAlertAction(title: "accept", style: .default, handler: { (action) in
                    
                    // --------------------------------------------------------------------------------------------------------------------
                    // 1. if user had added points to their point chart for that job, delete them and their values and update income totals
                    // --------------------------------------------------------------------------------------------------------------------
                    
                    if !isoArray.isEmpty {
                        for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                            if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily jobs" && pointsItem.itemName == isoArray[0].itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: isoArray[0].itemDate)) {
                                
                                // remove item from points array
                                Points.pointsArray.remove(at: pointsIndex)
                                
                                // subtract item from user's income array
                                for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                                    if incomeItem.user == self.currentUserName {
                                        Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                                    }
                                }
                                self.tableView.setEditing(false, animated: true)
                                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    }
                    
                    // ----------------------------------------------------------------------------
                    // 2. charge user substitution fee in Points array and then update Income array
                    // ----------------------------------------------------------------------------
                    
                    // subtract fee from Points Array
                    let loseSubstitutionPoints = Points(user: self.currentUserName, itemName: "\(self.usersDailyJobs[indexPath.row].name)", itemCategory: "daily jobs", code: assignEorX, valuePerTap: -(self.substituteFee), itemDate: Date().timeIntervalSince1970)
                    Points.pointsArray.append(loseSubstitutionPoints)
                    
                    // subtract fee from Income array and update income label
                    for (index, item) in Income.currentIncomeArray.enumerated() {
                        if item.user == self.currentUserName {
                            Income.currentIncomeArray[index].currentPoints -= self.substituteFee
                            self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                            self.updateProgressMeterHeights()
                        }
                    }
                    self.tableView.setEditing(false, animated: true)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    
                    alert3.dismiss(animated: true, completion: nil)}))
                self.present(alert3, animated: true, completion: nil)}))
            self.present(alert2, animated: true, completion: nil)}))
        
        // --------------------
        // Button TWO: "cancel"
        // --------------------
        
        alert.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.cancel , handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tableView.setEditing(false, animated: true)
            print("excused canceled")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func confirmOrCancelSubstituteForDailyJob(isoArray: [Points], nameOfSub: String, eORx: String, indexPath: IndexPath) {
        let substituteName: String = nameOfSub
        let substituteSubtotal = substituteFee + dailyJobsPointValue
        
        let dailyJobsPointsFormatter = String(format: "%.2f", Double(dailyJobsPointValue) / 100)
        let susbtituteSubtotalFormatted = String(format: "%.2f", Double(substituteSubtotal) / 100)
        
        let alert3 = UIAlertController(title: "Confirm Job Substitute", message: "\(substituteName) was the job substitute for '\(self.usersDailyJobs[indexPath.row].name)'. \(substituteName) earned the $\(subFeeFormatted!) substitute fee plus $\(dailyJobsPointsFormatter) for completing the job.\n\nDo you wish to continue?", preferredStyle: .alert)
        
        // ------------------
        // Confirm substitute
        // ------------------
        
        alert3.addAction(UIAlertAction(title: "pay \(substituteName) $\(susbtituteSubtotalFormatted)", style: .default, handler: { (action) in
            alert3.dismiss(animated: true, completion: nil)
            
            // -----------------------------------------------------------------------------------------------------------------
            // 1. subtract existing job from Points array AND Income array (if user already erroneously marked it as "complete")
            // -----------------------------------------------------------------------------------------------------------------
            
            if !isoArray.isEmpty {
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "daily jobs" && pointsItem.itemName == isoArray[0].itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: isoArray[0].itemDate)) {
                        
                        // remove item from points array
                        Points.pointsArray.remove(at: pointsIndex)
                        
                        // subtract from user's income array
                        for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                            if incomeItem.user == self.currentUserName {
                                Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                            }
                        }
                        self.tableView.setEditing(false, animated: true)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
            // -------------------------------------------------------------------
            // 2. charge current user the sub fee in Income array AND Points array
            // -------------------------------------------------------------------
            
            // subtract from income array
            for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                if incomeItem.user == self.currentUserName {
                    Income.currentIncomeArray[incomeIndex].currentPoints -= self.substituteFee
                }
            }
            
            // create charge in points array
            let loseSubstitutionPoints = Points(user: self.currentUserName, itemName: "\(self.usersDailyJobs[indexPath.row].name)", itemCategory: "daily jobs", code: eORx, valuePerTap: -(self.substituteFee), itemDate: Date().timeIntervalSince1970)
            Points.pointsArray.append(loseSubstitutionPoints)
            
            // -----------------------------------------------------------------------------------------
            // 3. pay the susbtitute the substitution fee AND job value in Income array AND Points array
            // -----------------------------------------------------------------------------------------
            
            // add fee and job value to substitute's Points array
            let earnedSubstitutionFee = Points(user: substituteName, itemName: "\(self.usersDailyJobs[indexPath.row].name) (sub)", itemCategory: "daily jobs", code: "S", valuePerTap: (self.substituteFee + self.dailyJobsPointValue), itemDate: Date().timeIntervalSince1970)
            Points.pointsArray.append(earnedSubstitutionFee)
            
            // update current user's table view with new row in 'other jobs' only if they assigned the substitution to themself
            if substituteName == self.currentUserName {
                let subJobsArray = Points.pointsArray.filter({ $0.user == self.currentUserName && $0.code == "S" && Calendar.current.isDateInToday(Date(timeIntervalSince1970: $0.itemDate)) })
                
                let jobSubIndexPath = IndexPath(row: subJobsArray.count - 1, section: 3)
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [jobSubIndexPath], with: .automatic)
                self.tableView.endUpdates()
            }
            
            // add fee and job value to Income array at substitute's index
            for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                if incomeItem.user == substituteName {
                    Income.currentIncomeArray[incomeIndex].currentPoints += (self.substituteFee + self.dailyJobsPointValue)
                }
            }
            
            // --------------------------------------------------------------------------------
            // 4. update the current user's income label last (after all calculations are done)
            // --------------------------------------------------------------------------------
            
            for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                if incomeItem.user == self.currentUserName {
                    self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                    self.updateProgressMeterHeights()
                }
            }
            self.tableView.setEditing(false, animated: true)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            print("\(substituteName) confirmed as substitute")
        }))
        
        // -----------------
        // Cancel substitute
        // -----------------
        
        alert3.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert3.dismiss(animated: true, completion: nil)
            self.tableView.setEditing(false, animated: true)
            print("canceled")
        }))
        self.present(alert3, animated: true, completion: nil)
        print("\(substituteName) selected as substitute")
    }
    
    func createNewPointsItemForDailyJobs(indexPath: IndexPath) {
        let pointsArrayItem = Points(user: currentUserName,
                                     itemName: (usersDailyJobs?[indexPath.row].name)!,
                                     itemCategory: "daily jobs",
                                     code: "C",
                                     valuePerTap: dailyJobsPointValue,
                                     itemDate: Date().timeIntervalSince1970)
        
        Points.pointsArray.append(pointsArrayItem)
        
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += dailyJobsPointValue
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                updateProgressMeterHeights()
            }
        }
    }
}
