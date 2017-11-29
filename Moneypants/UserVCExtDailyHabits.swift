import UIKit

extension UserVC {
    
    func createNewItemForDailyHabit(indexPath: IndexPath) {
        var valuePerTap = 0
        
        if indexPath.row == 0 {
            valuePerTap = priorityHabitPointValue!
        } else {
            valuePerTap = regularHabitPointValue!
        }
        
        // refresh selectedDate variable with current time
        selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateNumber, to: Date())
        let pointsArrayItem = Points(user: currentUserName,
                                     itemName: (usersDailyHabits?[indexPath.row].name)!,
                                     itemCategory: "daily habits",
                                     code: "C",
                                     valuePerTap: valuePerTap,
                                     itemDate: selectedDate.timeIntervalSince1970)
        
        Points.pointsArray.append(pointsArrayItem)
        
        // add item to Firebase
        ref.child("points").childByAutoId().setValue(["user" : currentUserName,
                                                      "itemName" : (usersDailyHabits?[indexPath.row].name)!,
                                                      "itemCategory" : "daily habits",
                                                      "code" : "C",
                                                      "valuePerTap" : valuePerTap,
                                                      "itemDate" : selectedDate.timeIntervalSince1970])
        
        // update user's income array & income label
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += valuePerTap
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                updateProgressMeterHeights()
            }
        }
        
        updateUserIncomeOnFirebase()
    }
    
    func createZeroValueItemForDailyHabit(indexPath: IndexPath) {
        let undoneHabit = Points(user: self.currentUserName,
                                 itemName: self.usersDailyHabits[indexPath.row].name,
                                 itemCategory: "daily habits",
                                 code: "N",
                                 valuePerTap: 0,
                                 itemDate: selectedDate.timeIntervalSince1970)
        
        Points.pointsArray.append(undoneHabit)
        tableView.setEditing(false, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func getParentalPasscodeThenResetItemToZero(isoArray: [Points], indexPath: IndexPath) {
        let alert = UIAlertController(title: "Parental Passcode Required", message: "You must enter a parental passcode to override a habit that has been marked 'not done'.", preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "enter passcode"
            textField.isSecureTextEntry = true
            textField.keyboardType = .numberPad
        })
        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default , handler: { (action) in
            // get passcodes for just parents, no kids
            let parentalArray = MPUser.usersArray.filter({ $0.childParent == "parent" })
            if parentalArray.contains(where: { "\($0.passcode)" == alert.textFields![0].text }) {
                
                // if array is not empty, delete the item from the array
                for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
                    // if PointsArray item matches the isoArray item, then use the pointsarray index to delete that item from the points array
                    if pointsItem.user == self.currentUserName &&
                        pointsItem.itemCategory == "daily habits" &&
                        pointsItem.itemName == isoArray.first?.itemName &&
                        pointsItem.itemDate == isoArray.first?.itemDate {
                        
                        // remove item from points array (no need to do anything else: value was already zero)
                        Points.pointsArray.remove(at: pointsIndex)
                        
                        // update tableview
                        self.tableView.setEditing(false, animated: true)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            } else {
                self.incorrectPasscodeAlert()
            }
        }))
        // Button TWO: "cancel", reset table to normal
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: {_ in
            self.tableView.setEditing(false, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func habitBonusEarned() {
        // refresh selectedDate variable with selected time
        selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateNumber, to: Date())
        
        // if selected habit is in current pay period, update habit bonus for current pay period
        if self.selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().current.timeIntervalSince1970 {
            if let index = Points.pointsArray.index(where: { $0.user == currentUserName &&
                $0.itemCategory == "daily habits" &&
                $0.code == "B" &&
                $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 }) {
                
                // update array at index
                Points.pointsArray[index].valuePerTap = jobAndHabitBonusValue
                Points.pointsArray[index].itemDate = selectedDate.timeIntervalSince1970
            }
        } else if self.selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().previous.timeIntervalSince1970 && self.selectedDate.timeIntervalSince1970 < FamilyData.calculatePayday().current.timeIntervalSince1970 {
            if let index = Points.pointsArray.index(where: { $0.user == currentUserName &&
                $0.itemCategory == "daily habits" &&
                $0.code == "B" &&
                $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
                $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 }) {
                
                // update array at index
                Points.pointsArray[index].valuePerTap = jobAndHabitBonusValue
                Points.pointsArray[index].itemDate = selectedDate.timeIntervalSince1970
            }
        }
        
        // update bonus on Firebase (this code is wrong: it is for adding, not updating Firebase)
//        ref.child("points").childByAutoId().setValue(["user" : currentUserName,
//                                                      "itemName" : "habit bonus",
//                                                      "itemCategory" : "daily habits",
//                                                      "code" : "B",
//                                                      "valuePerTap" : jobAndHabitBonusValue,
//                                                      "itemDate" : selectedDate.timeIntervalSince1970])
        
        // update user's income array & income label
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += jobAndHabitBonusValue
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
                updateProgressMeterHeights()
            }
        }
        
        // update user's income on Firebase
        updateUserIncomeOnFirebase()
        
        habitProgressMeterView.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0)
    }
    
    func updateProgressMeters() {
        // update progress meters with current data
        let potentialWeeklyEarnings = FamilyData.adjustedNatlAvgYrlySpendingPerKid * 100 / 52
        habitProgressMeterHeight.constant = habitTotalProgressView.bounds.height * CGFloat(pointsEarnedInPayPeriod(previousOrCurrent: "current").habits) / CGFloat(jobAndHabitBonusValue)
        totalProgressMeterHeight.constant = habitTotalProgressView.bounds.height * CGFloat(pointsEarnedInPayPeriod(previousOrCurrent: "current").total) / CGFloat(potentialWeeklyEarnings)
    
        if pointsEarnedInPayPeriod(previousOrCurrent: "current").habits >= Int(Double(jobAndHabitBonusValue) * 0.75) {
//            currentBonusSoundAlreadyPlayed = true
            habitProgressMeterView.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0) // green
        } else {
            habitProgressMeterView.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0) // purple
//            currentBonusSoundAlreadyPlayed = false
        }
        
        if pointsEarnedInPayPeriod(previousOrCurrent: "previous").habits >= Int(Double(jobAndHabitBonusValue) * 0.75) {
//            previousBonusSoundAlreadyPlayed = true
            habitProgressMeterView.backgroundColor = UIColor(red: 125/255, green: 190/255, blue: 48/255, alpha: 1.0) // green
        } else {
            habitProgressMeterView.backgroundColor = UIColor(red: 204/255, green: 0/255, blue: 102/255, alpha: 1.0) // purple
//            previousBonusSoundAlreadyPlayed = false
        }
    }
    
    func updateItemInArrayAndUpdateIncomeArrayAndLabel(isoArray: [Points], indexPath: IndexPath) {
        // if array is not empty, subtract "value per tap" from income array (at user's index) and change item code to "N" and "value per tap" to zero
        for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
            // if PointsArray item matches the isoArray item, then use the pointsarray index to update that item in the points array
            if pointsItem.user == self.currentUserName &&
                pointsItem.itemCategory == "daily habits" &&
                pointsItem.itemName == isoArray.first?.itemName &&
                pointsItem.itemDate == isoArray.first?.itemDate {
                
                // update item in points array
                Points.pointsArray[pointsIndex].code = "N"
                Points.pointsArray[pointsIndex].valuePerTap = 0
                
                // update user's income array & income label
                for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                    if incomeItem.user == self.currentUserName {
                        Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
                        incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                        updateProgressMeterHeights()
                    }
                }
                tableView.setEditing(false, animated: true)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func removeHabitBonus() {
        // if user hasn't yet earned the 75% for the habit bonus...
        if pointsEarnedInPayPeriod(previousOrCurrent: "current").habits < Int(Double(jobAndHabitBonusValue) * 0.75) {
            // remove the bonus from the array (if it exists)
            if let index = Points.pointsArray.index(where: { $0.user == currentUserName &&
                $0.itemCategory == "daily habits" &&
                $0.code == "B" &&
                $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 }) {
                
                // remove bonus amount from Income array first before deleting item from array
                print(Income.currentIncomeArray[MPUser.currentUser].currentPoints)
                print(Points.pointsArray[index].valuePerTap)

                Income.currentIncomeArray[MPUser.currentUser].currentPoints -= Points.pointsArray[index].valuePerTap
                
                // then remove item from array
                Points.pointsArray.remove(at: index)
            }
            
//            for (pointsIndex, pointsItem) in Points.pointsArray.enumerated() {
//                if pointsItem.user == currentUserName && pointsItem.itemCategory == "daily habits" && pointsItem.code == "B" {
//                    
//                    // update item in points array
//                    // or do I just delete it?
//                    Points.pointsArray[pointsIndex].valuePerTap = 0
//                }
//                
//                // update user's income array & income label
//                for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
//                    if incomeItem.user == self.currentUserName {
//                        Income.currentIncomeArray[incomeIndex].currentPoints -= pointsItem.valuePerTap
//                        incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
//                        updateProgressMeterHeights()
//                    }
//                }
//            }
        }
    }
    
    func displayHabitBonusFlyover() {
        habitBonusAmountLabel.text = "$\(String(format: "%.2f", Double(jobAndHabitBonusValue!) / 100))"
        trophyView.image = UIImage(named: "trophy black")
        trophyView.tintColor = .white
        habitBonusCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.habitBonusView.alpha = 1
            self.view.layoutIfNeeded()
        }
        
        habitBonusSound.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 0.3, animations: {
                self.habitBonusCenterConstraint.constant = 300
                self.habitBonusView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func checkHabitsDefaultBonusValue() {
        let currentPayPeriodBonusIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemCategory == "daily habits" &&
            $0.code == "B" &&
            $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 })
        
        let previousPayPeriodBonusIsoArray = Points.pointsArray.filter({ $0.user == currentUserName &&
            $0.itemCategory == "daily habits" &&
            $0.code == "B" &&
            $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
            $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 })
        
        // check to see if current pay period has bonus
        if selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().current.timeIntervalSince1970 {
            if currentPayPeriodBonusIsoArray.isEmpty {
                createZeroValueHabitBonusItem()
                print("zero bonus item created")
            } else {
                print("current pay period already has bonus")
            }
        } else if selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().previous.timeIntervalSince1970 && selectedDate.timeIntervalSince1970 < FamilyData.calculatePayday().current.timeIntervalSince1970 {
            if previousPayPeriodBonusIsoArray.isEmpty {
                createZeroValueHabitBonusItem()
                print("zero bonus item created")
            } else {
                print("previous pay period already has bonus")  // not sure when this code would run...
            }
        }
    }
    
    func createZeroValueHabitBonusItem() {
        // refresh selectedDate variable with selected time
        selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateNumber, to: Date())
        let pointsArrayItem = Points(user: currentUserName,
                                     itemName: "habit bonus",
                                     itemCategory: "daily habits",
                                     code: "B",
                                     valuePerTap: 0,
                                     itemDate: selectedDate.timeIntervalSince1970)
        
        // add bonus to local array
        Points.pointsArray.append(pointsArrayItem)
        
        // add bonus to Firebase
        ref.child("points").childByAutoId().setValue(["user" : currentUserName,
                                                      "itemName" : "habit bonus",
                                                      "itemCategory" : "daily habits",
                                                      "code" : "B",
                                                      "valuePerTap" : 0,
                                                      "itemDate" : selectedDate.timeIntervalSince1970])
    }
    
    func checkIfUserStillEarnedBonusAndUpdateAccordingly() {
        // 1. need to check if user has dropped below 75% threshold
        // SO: get total habits points earned in pay period
        // get habit bonus value
        // subtract bonus value from habit points (bonus could be zero, and wouldn't change anything)
        // then compare if that amount is less than the 75% threshold
        // if so, change the bonus value for that pay period to zero and update user's income
        // if not, don't do anything
        
        // ------------------
        // current pay period
        // ------------------
        
        let currentPayPeriodBonusIsoArray = Points.pointsArray.filter({ $0.user == self.currentUserName &&
            $0.itemCategory == "daily habits" &&
            $0.code == "B" &&
            $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 })
        
        // check to see if selected date is in current pay period
        if self.selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().current.timeIntervalSince1970 {
            let pointsEarned = self.pointsEarnedInPayPeriod(previousOrCurrent: "current").habits
            let bonusValue = currentPayPeriodBonusIsoArray.first?.valuePerTap
            let the75PercentMark = Int(Double(self.jobAndHabitBonusValue) * 0.75)
            
            if pointsEarned - bonusValue! < the75PercentMark {
                
                // find index of bonus in previous pay period
                if let index = Points.pointsArray.index(where: { $0.user == self.currentUserName &&
                    $0.itemCategory == "daily habits" &&
                    $0.code == "B" &&
                    $0.itemDate >= FamilyData.calculatePayday().current.timeIntervalSince1970 }) {
                    
                    // update array at index
                    Points.pointsArray[index].valuePerTap = 0
                    Points.pointsArray[index].itemDate = self.selectedDate.timeIntervalSince1970
                    
                    // update user's income array & income label
                    for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                        if incomeItem.user == self.currentUserName {
                            Income.currentIncomeArray[incomeIndex].currentPoints -= bonusValue!
                            self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                            self.updateProgressMeterHeights()
                        }
                    }
                }
            } else {
                // do nothing b/c user's habit total is still above the 75% threshold
            }
        }
        
        // -------------------
        // previous pay period
        // -------------------
        
        let previousPayPeriodBonusIsoArray = Points.pointsArray.filter({ $0.user == self.currentUserName &&
            $0.itemCategory == "daily habits" &&
            $0.code == "B" &&
            $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
            $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 })
        
        // check to see if selected date is in previous pay period
        if self.selectedDate.timeIntervalSince1970 >= FamilyData.calculatePayday().previous.timeIntervalSince1970 && self.selectedDate.timeIntervalSince1970 < FamilyData.calculatePayday().current.timeIntervalSince1970 {
            let pointsEarned = self.pointsEarnedInPayPeriod(previousOrCurrent: "previous").habits
            let bonusValue = previousPayPeriodBonusIsoArray.first?.valuePerTap
            let the75PercentMark = Int(Double(self.jobAndHabitBonusValue) * 0.75)
            
            if pointsEarned - bonusValue! < the75PercentMark {
                
                // find index of bonus in previous pay period
                if let index = Points.pointsArray.index(where: { $0.user == self.currentUserName &&
                    $0.itemCategory == "daily habits" &&
                    $0.code == "B" &&
                    $0.itemDate >= FamilyData.calculatePayday().previous.timeIntervalSince1970 &&
                    $0.itemDate < FamilyData.calculatePayday().current.timeIntervalSince1970 }) {
                    
                    // update array at index
                    Points.pointsArray[index].valuePerTap = 0
                    Points.pointsArray[index].itemDate = self.selectedDate.timeIntervalSince1970
                    
                    // update user's income array & income label
                    for (incomeIndex, incomeItem) in Income.currentIncomeArray.enumerated() {
                        if incomeItem.user == self.currentUserName {
                            Income.currentIncomeArray[incomeIndex].currentPoints -= bonusValue!
                            self.incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[incomeIndex].currentPoints) / 100))"
                            self.updateProgressMeterHeights()
                        }
                    }
                }
            } else {
                // do nothing b/c user's habit total is still above the 75% threshold
            }
        }
    }
}
