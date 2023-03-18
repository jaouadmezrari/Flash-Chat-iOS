//
//  ChatViewController.swift
//  Flash Chat
//
//  Created by Abdeljaouad Mezrari on 04/03/2023.
//  Copyright © 2023 Abdeljaouad Mezrari. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    var messages:[Message] = [
        Message(sender: "aaaa@aaaa.com", body: "Hey!"),
        Message(sender: "edan.amaar@moabuild.com", body: "Hello!!"),
        Message(sender: "aaaa@aaaa.com", body: "What's up?"),
    ]
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            throwAlert(title: "Error", text: "Error signing out: \(signOutError)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName).addSnapshotListener { (querySnapshot, error) in
            if let e = error{
                self.throwAlert(title: "Error", text: e.localizedDescription)
            } else {
                if let snapShotDocuments = querySnapshot?.documents{
                    self.messages = []
                    for snapShotDocument in snapShotDocuments {
                        let data = snapShotDocument.data()
                        if let sender = snapShotDocument.data()[K.FStore.senderField] as? String, let body = snapShotDocument.data()[K.FStore.bodyField] as? String{
                            self.messages.append(Message(sender: sender, body: body))
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath.init(row: self.messages.count-1, section: 0), at: .none, animated: true)
            }
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).document("\(Date().timeIntervalSince1970)").setData([
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody
            ]) { (error) in
                if let e = error {
                    self.throwAlert(title: "Error", text: e.localizedDescription)
                } else {
                    self.messageTextfield.text = ""
                    self.loadMessages()
                }
            }
        }
        
        
    }
    
    func throwAlert(title: String, text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let closeAlertBtn = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(closeAlertBtn)
        self.present(alert, animated: true)

    }

}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! CellMessage
        cell.label.text = self.messages[indexPath.row].body
        if self.messages[indexPath.row].sender == Auth.auth().currentUser?.email{
            cell.youAvatarImage.isHidden = true
            cell.meAvatarImage.isHidden = false
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            cell.LabelView.backgroundColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.youAvatarImage.isHidden = false
            cell.meAvatarImage.isHidden = true
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
            cell.LabelView.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
}
