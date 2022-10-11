//
//  TableViewController.swift
//  ToyDonation
//
//  Created by Eric Alves Brito.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import Firebase

final class ListTableViewController: UITableViewController {

	// MARK: - Properties
	private let collection = "toyDonationList"
	private var donationList: [Toy] = []
	private lazy var firestore: Firestore = {
		let settings = FirestoreSettings()
		settings.isPersistenceEnabled = true
		
		let firestore = Firestore.firestore()
		firestore.settings = settings
		return firestore
	}()
	var firestoreListener: ListenerRegistration!
	
	//TOC: Trabalhar a Organização Código
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
		
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Voltar",
														   style: .plain,
														   target: self,
														   action: #selector(back))
		
		loadDonationList()
    }
	
	// MARK: - Methods
	@objc private func back() {
        guard let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") else {
            return
        }
        navigationController?.viewControllers = [welcomeViewController]
	}
	
	private func loadDonationList() {
		firestoreListener = firestore
							.collection(collection)
							.order(by: "name", descending: false)
//								.limit(to: 20)
							.addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
								if let error = error {
									print(error)
								} else {
									guard let snapshot = snapshot else { return }
									print("Total de documentos alterados:", snapshot.documentChanges.count)
									if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
										self.showItemsFrom(snapshot: snapshot)
									}
								}
							})
	}
	
	private func showItemsFrom(snapshot: QuerySnapshot) {
        donationList.removeAll()
		for document in snapshot.documents {
			let id = document.documentID
			let data = document.data()
			let name = data["name"] as? String ?? "---"
			let cellphone = data["cellphone"] as? String ?? "---"
			let toy = Toy(id: id, name: name, cellphone: cellphone)
            donationList.append(toy)
		}
		tableView.reloadData()
	}
	
	private func showAlertForItem(_ item: Toy?) {
		let alert = UIAlertController(title: "Produto", message: "Entre com as informações do brinquedo abaixo", preferredStyle: .alert)
		
		alert.addTextField { textField in
			textField.placeholder = "Nome"
			textField.text = item?.name
		}
		alert.addTextField { textField in
			textField.placeholder = "Telefone"
			textField.keyboardType = .numberPad
			textField.text = item?.cellphone
		}
		
		let okAction = UIAlertAction(title: "OK", style: .default) { _ in
			guard let name = alert.textFields?.first?.text,
				  let cellphone = alert.textFields?.last?.text else {return}
			
			let data: [String: Any] = [
				"name": name,
				"cellphone": cellphone
			]
			
			if let item = item {
				//Edição
				self.firestore.collection(self.collection).document(item.id).updateData(data)
			} else {
				//Criação
				self.firestore.collection(self.collection).addDocument(data: data)
			}
		}
		
		let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
		
		alert.addAction(okAction)
		alert.addAction(cancelAction)
		
		present(alert, animated: true, completion: nil)
	}

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return donationList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let toy = donationList[indexPath.row]
		cell.textLabel?.text = toy.name
        cell.detailTextLabel?.text = toy.cellphone
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let toy = donationList[indexPath.row]
		showAlertForItem(toy)
    }
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let toy = donationList[indexPath.row]
			firestore.collection(collection).document(toy.id).delete()
		}
	}
    
    // MARK: - IBActions
    @IBAction func addItem(_ sender: Any) {
		showAlertForItem(nil)
    }
}


