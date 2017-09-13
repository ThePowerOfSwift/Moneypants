import UIKit
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func getStoryboard() -> UIStoryboard {
        var storyboard = UIStoryboard()
        let currentUser = FIRAuth.auth()?.currentUser
        if currentUser != nil {
            print("\(currentUser?.uid) logged in")
            storyboard = UIStoryboard(name: "Home", bundle: nil)
        } else {
            print("user logged out")
            storyboard = UIStoryboard(name: "Setup", bundle: nil)
        }
        return storyboard
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true        // enable offline work
        IQKeyboardManager.sharedManager().enable = true
        
        //        let storyboard: UIStoryboard = self.getStoryboard()
        //
        //        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        //        self.window?.makeKeyAndVisible()
        return true
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

