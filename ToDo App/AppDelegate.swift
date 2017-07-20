import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true        // enable offline work
        IQKeyboardManager.sharedManager().enable = true
        
        // ---------------------------------------------
        // hide text, only have back arrow on navigation
        // ---------------------------------------------
        
//        let backImage = UIImage(named: "BackNavigation")?.withRenderingMode(.alwaysOriginal)
//        UINavigationBar.appearance().backIndicatorImage = backImage
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
//        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -80.0), for: .default)
        
        
        /*
        //let currentUser = FIRAuth.auth()?.currentUser
        // If user already logged in, go right to setup page 103
        // MARK: TODO - We'll have to update this in the future
        // First have app check to see if all setup is done. If not, then go to that part of setup. And if setup is done, then go to Home Page
        if currentUser != nil
        {
            self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "setup103Page")
        }
        else
        {
            self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage")
        }
        */

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

