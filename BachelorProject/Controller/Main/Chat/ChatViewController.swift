//
//  ChatViewController.swift
//  BachelorProject
//
//  Created by Павел Снижко on 15.03.2021.
//

import UIKit


enum MessageType: String {
    case sender
    case responder
}


struct Message {
    let name: String
    let time: Int
    let text: String
    let type: MessageType
}


class ChatViewController: UIViewController, NibLoadable {
    
    var messages: [Message] = [Message(name: "Columb", time: 10, text: "This is a test message", type: .sender),
                               Message(name: "Jack", time: 10, text: "Hello world.I will be so long because I wanna test your cell.This is a test message.This is a test message.This is a test message. There can be lorem ipsum", type: .responder),
                               Message(name: "John", time: 10, text: "Hello world.I will be so long because I wanna test your cell.This is a test message.This is a test message.This is a test message. There can be lorem ipsum", type: .responder),
                               Message(name: "Paul", time: 10, text: "Hello world.I will be so long because I wanna test your cell.This is a test message.This is a test message.This is a test message. There can be lorem ipsum", type: .sender)]
    
    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.isNavigationBarHidden = false
        
        // Do any additional setup after loading the view.
    }
    @IBAction func sendMessageTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}


extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageTableViewCell else { return .init() }
//        let cell = MessageTableViewCell(style: .default, reuseIdentifier: "MessageCell")
        cell.selectionStyle = .none
        
        let message = messages[indexPath.row]
        cell.message = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = MessageTableViewCell.height(for: messages[indexPath.row])
        return height
    }
    
    func insertNewMessageCell(_ message: Message) {
        messages.append(message)
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .bottom)
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}


extension ChatViewController {
    
}
