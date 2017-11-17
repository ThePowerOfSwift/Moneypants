import UIKit

extension UserVC {
    
    func weeklyJobsSubDialogue(indexPath: IndexPath, isoArray: [Points]) {
        
        // -----------------
        // Choose substitute
        // -----------------
        
        let alert2 = UIAlertController(title: "Job Substitute", message: "Who was the job substitute for \(self.currentUserName!)'s job '\(self.usersWeeklyJobs[indexPath.row].name)'?", preferredStyle: UIAlertControllerStyle.alert)
        for user in MPUser.usersArray {
            alert2.addAction(UIAlertAction(title: user.firstName, style: .default, handler: { (action) in
                print(self.currentUserName, user.firstName)
                
                if user.firstName == self.currentUserName {
                    let alert3 = UIAlertController(title: "Substitute Error", message: "For weekly jobs, a user cannot be their own substitute.", preferredStyle: .alert)
                    alert3.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.cancel, handler: { (action) in
                        alert3.dismiss(animated: true, completion: nil)
                        self.tableView.setEditing(false, animated: true)
                        return
                    }))
                    self.present(alert3, animated: true, completion: nil)
                }
                
                
                
                alert2.dismiss(animated: true, completion: nil)
                
                // ---------------------------
                // Confirm / Cancel substitute
                // ---------------------------
                
                self.confirmOrCancelSubstituteForWeeklyJob(nameOfSub: user.firstName, indexPath: indexPath, isoArray: isoArray)
            }))
        }
        
        // -------------
        // NO substitute
        // -------------
        
        alert2.addAction(UIAlertAction(title: "None", style: .cancel, handler: { (action) in
            let alert3 = UIAlertController(title: "Job Substitute Missing", message: "You have not chosen a job substitute for \(self.currentUserName!)'s job '\(self.usersWeeklyJobs[indexPath.row].name)'.\n\nNobody will get paid for doing this job and it will remain undone. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
            alert3.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
                // do nothing
                self.tableView.setEditing(false, animated: true)
                alert3.dismiss(animated: true, completion: nil)}))
            alert3.addAction(UIAlertAction(title: "accept", style: .default, handler: { (action) in
                
                // --------------------------------------------------------------------------------------------------------------------
                // 1. if user had added points to their point chart for that job, delete them and their values and update income totals
                // --------------------------------------------------------------------------------------------------------------------
                
                // if array is empty, create a new Points item with a value of zero and a code of "N" for current user
                if isoArray.isEmpty {
                    let noSub = Points(user: self.currentUserName,
                                       itemName: self.usersWeeklyJobs[indexPath.row].name,
                                       itemCategory: "weekly jobs",
                                       code: "N",
                                       valuePerTap: 0,
                                       itemDate: Date().timeIntervalSince1970)
                    Points.pointsArray.append(noSub)
                    
                // if array isn't empty, change the existing Points item to be zero and code "N", and subtract corresponding Income value from user's income
                } else {
                    for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                        if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "weekly jobs" && pointsItem.itemName == isoArray[0].itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: isoArray[0].itemDate)) {
                            
                            // update item at points array
                            Points.pointsArray[pointsIndex].code = "N"
                            Points.pointsArray[pointsIndex].valuePerTap = 0
                            
                            // subtract item from user's income array and update income label
                            for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                                if incomeItem.user == self.currentUserName {
                                    Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                                    self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                                    self.updateProgressMeterHeights()
                                }
                            }
                            self.tableView.setEditing(false, animated: true)
                            self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
                
                self.tableView.setEditing(false, animated: true)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                
                alert3.dismiss(animated: true, completion: nil)}))
            self.present(alert3, animated: true, completion: nil)}))
        self.present(alert2, animated: true, completion: nil)
    }

    func confirmOrCancelSubstituteForWeeklyJob(nameOfSub: String, indexPath: IndexPath, isoArray: [Points]) {
        let substituteName: String = nameOfSub
        let weeklyJobsPointsFormatter = String(format: "%.2f", Double(weeklyJobsPointValue) / 100)
        
        let alert = UIAlertController(title: "Confirm Job Substitute", message: "\(substituteName) was the job substitute for \(currentUserName!)'s job '\(self.usersWeeklyJobs[indexPath.row].name)' and earned $\(weeklyJobsPointsFormatter) for completing the job.\n\nDo you wish to continue?", preferredStyle: .alert)
        
        // ------------------
        // Confirm substitute
        // ------------------
        
        alert.addAction(UIAlertAction(title: "pay \(substituteName) $\(weeklyJobsPointsFormatter)", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
            // --------------------------------------------------------
            // 1. create or update current user Points array and Income
            // --------------------------------------------------------
            
            // if array is empty, create a new Points item with a value of zero and a code of "N" for current user
            if isoArray.isEmpty {
                print("array is empty; item must be blank")
                let noSub = Points(user: self.currentUserName,
                                   itemName: self.usersWeeklyJobs[indexPath.row].name,
                                   itemCategory: "weekly jobs",
                                   code: "N",
                                   valuePerTap: 0,
                                   itemDate: Date().timeIntervalSince1970)
                Points.pointsArray.append(noSub)
                
            // if array isn't empty, change the existing Points item to be zero and code "N", and subtract corresponding Income value from user's income
            } else {
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    if pointsItem.user == self.currentUserName && pointsItem.itemCategory == "weekly jobs" && pointsItem.itemName == isoArray[0].itemName && Calendar.current.isDateInToday(Date(timeIntervalSince1970: isoArray[0].itemDate)) {
                        
                        // update item at points array
                        Points.pointsArray[pointsIndex].code = "N"
                        Points.pointsArray[pointsIndex].valuePerTap = 0
                        
                        // subtract item from user's income array and update income label
                        for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                            if incomeItem.user == self.currentUserName {
                                Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                                self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                                self.updateProgressMeterHeights()
                            }
                        }
                    }
                }
            }
            
            // ------------------------------------------------------------------------
            // 2. pay the susbtitute for doing the job in Income array AND Points array
            // ------------------------------------------------------------------------
            
            // add job value to Points array for substitute
            let earnedSubstitutionValue = Points(user: substituteName, itemName: "\(self.usersWeeklyJobs[indexPath.row].name) (sub)", itemCategory: "weekly jobs", code: "S", valuePerTap: self.weeklyJobsPointValue, itemDate: Date().timeIntervalSince1970)
            Points.pointsArray.append(earnedSubstitutionValue)
            
            // add fee and job value to Income array at substitute's index
            for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                if incomeItem.user == substituteName {
                    Income.currentIncomeArray[incomeIndex].currentPoints += self.weeklyJobsPointValue
                }
            }
            
            self.tableView.setEditing(false, animated: true)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            print("\(substituteName) confirmed as substitute")
        }))
        
        // -----------------
        // Cancel substitute
        // -----------------
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.tableView.setEditing(false, animated: true)
            print("canceled")
        }))
        self.present(alert, animated: true, completion: nil)
        print("\(substituteName) selected as substitute")
    }
    
    func createNewPointsItemForWeeklyJobs(indexPath: IndexPath) {
        let newItemTapped = Points(user: currentUserName,
                                   itemName: (usersWeeklyJobs?[indexPath.row].name)!,
                                   itemCategory: "weekly jobs",
                                   code: "C",
                                   valuePerTap: weeklyJobsPointValue,
                                   itemDate: Date().timeIntervalSince1970)
        
        Points.pointsArray.append(newItemTapped)
        
        // update user's income array & income label
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += weeklyJobsPointValue
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                updateProgressMeterHeights()
            }
        }
    }
}
