//
//  AppDelegate.swift
//  ToyDonation
//
//  Created by Eric Alves Brito.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		FirebaseApp.configure()
		
		if let _ = Auth.auth().currentUser {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let listTableViewController = storyboard.instantiateViewController(withIdentifier: "ListTableViewController")
			let navigationControlller = window?.rootViewController as? UINavigationController
//			navigationControlller.navigationBar.prefersLargeTitles = true
			navigationControlller?.viewControllers = [listTableViewController]
			window?.rootViewController = navigationControlller
		}
		
        return true
    }
}

