import Foundation
import Firebase

struct Points {
    var user: String
    var itemName: String
    var itemCategory: String
    var code: String
    var valuePerTap: Int
    var itemDate: Double
    
    static var pointsArray = [Points]()
    
    // code:
    // C = completed (for daily jobs, daily habits, and weekly jobs)
    // E = excused (for daily jobs only)
    // X = unexcused (for daily jobs only)
    // S = sub (for daily and weekly jobs)
    // N = not complete (for habits and weekly jobs)
    // F = fee
    // B = bonus (for daily jobs and habits)
    // P = paid (for payday items)
    // U = unpaid
    
    static func loadPoints(completion: @escaping () -> ()) {
        let firebaseUser = Auth.auth().currentUser
        let ref = Database.database().reference().child("users").child((firebaseUser?.uid)!)
        ref.child("points").observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            for item in snapshot.children {
                if let snap = item as? DataSnapshot {
                    if let value = snap.value as? [String : Any] {
                        let user = value["user"] as! String
                        let itemName = value["itemName"] as! String
                        let itemCategory = value["itemCategory"] as! String
                        let code = value["code"] as! String
                        let valuePerTap = value["valuePerTap"] as! Int
                        let itemDate = value["itemDate"] as! Double
                        
                        let pointsItem = Points(user: user, itemName: itemName, itemCategory: itemCategory, code: code, valuePerTap: valuePerTap, itemDate: itemDate)
                        
                        Points.pointsArray.append(pointsItem)
                        completion()
                    }
                }
            }
        }
    }
}
