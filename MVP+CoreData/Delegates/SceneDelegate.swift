//
//  SceneDelegate.swift
//  MVP+CoreData
//
//  Created by Umang on 16/06/23.
//

import UIKit

var scenedelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) { 
        guard let _ = (scene as? UIWindowScene) else { return }
        checkRootController()
    }
    
    func checkRootController() {
        let isLoggedIn = UserDefaults.standard.value(forKey: Keys.isLoggedIn) as? Bool ?? false
        if isLoggedIn {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardVC") as! DashboardVC
            let navVC = UINavigationController(rootViewController: vc)
            navVC.isNavigationBarHidden = true
            window?.rootViewController = navVC
            loggedInUser = UserDefaults.standard.value(forKey: Keys.userId) as? Int64 ?? 0
            window?.makeKeyAndVisible()
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            let navVC = UINavigationController(rootViewController: vc)
            navVC.isNavigationBarHidden = true
            window?.rootViewController = navVC
            window?.makeKeyAndVisible()        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

