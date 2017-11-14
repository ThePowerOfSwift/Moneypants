import UIKit

extension UserVC {
    
    func createNewItemForDailyHabit(indexPath: IndexPath) {
        var valuePerTap = 0
        
        if indexPath.row == 0 {
            valuePerTap = priorityHabitPointValue!
        } else {
            valuePerTap = regularHabitPointValue!
        }
        
        let pointThingy = Points(user: currentUserName,
                                 itemName: (usersDailyHabits?[indexPath.row].name)!,
                                 itemCategory: "daily habits",
                                 codeCEXSN: "C",
                                 valuePerTap: valuePerTap,
                                 itemDate: Date().timeIntervalSince1970)
        
        Points.pointsArray.append(pointThingy)
        
        // update user's income array & income label
        for (index, item) in Income.currentIncomeArray.enumerated() {
            if item.user == currentUserName {
                Income.currentIncomeArray[index].currentPoints += valuePerTap
                incomeLabel.text = "$\(String(format: "%.2f", Double(Income.currentIncomeArray[index].currentPoints) / 100))"
            }
        }
    }
    
    func createZeroValueItemForDailyHabit(indexPath: IndexPath) {
        let undoneHabit = Points(user: self.currentUserName,
                                 itemName: self.usersDailyHabits[indexPath.row].name,
                                 itemCategory: "daily habits",
                                 codeCEXSN: "N",
                                 valuePerTap: 0,
                                 itemDate: Date().timeIntervalSince1970)
        
        Points.pointsArray.append(undoneHabit)
        tableView.setEditing(false, animated: true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
