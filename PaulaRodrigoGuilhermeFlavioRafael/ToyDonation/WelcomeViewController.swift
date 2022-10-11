//
//  ViewController.swift
//  ToyDonation
//
//  Created by Eric Alves Brito.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit

final class WelcomeViewController: UIViewController {
    

    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func signIn(_ sender: Any) {
        if let listTableViewController = storyboard?.instantiateViewController(withIdentifier: "ListTableViewController") {
            show(listTableViewController, sender: nil)
        }
    }
}

