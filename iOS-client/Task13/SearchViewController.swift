//
//  SearchViewController.swift
//  Task13
//
//  Created by buqian zheng on 5/10/18.
//  Copyright © 2018 buqian zheng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var fromInput: UITextField!
    @IBOutlet weak var toInput: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resultList: UITableView!
    @IBOutlet weak var timeInput: UITextField!
    @IBAction func dismissKeyboard(_ sender: Any) {
        fromInput.resignFirstResponder()
        toInput.resignFirstResponder()
        searchButton.resignFirstResponder()
    }
    
    @IBOutlet weak var resultView: UIView!
    @IBAction func switchText(_ sender: Any) {
        dismissKeyboard(sender)
        (fromInput.text, toInput.text) = (toInput.text, fromInput.text)
    }
    @IBAction func search(_ sender: Any) {
        dismissKeyboard(sender)
        resultView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultList.delegate = self
        resultList.dataSource = self
        resultList.rowHeight = 80
        resultList.separatorStyle = .none
        
        searchButton.layer.borderColor = MainBlue.cgColor
        searchButton.layer.borderWidth = 2
        searchButton.layer.cornerRadius = 5
        
        setInputs(fromInput)
        setInputs(toInput)
        setInputs(timeInput)
        
    }
    
    func setInputs(_ input: UITextField) {
        input.layer.cornerRadius = 5
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        input.leftView = padding
        input.leftViewMode = .always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SearchInfoIdentifier) as? SearchInfoCell
        if cell == nil {
            tableView.register(UINib(nibName: "SearchInfoCell", bundle: nil), forCellReuseIdentifier: SearchInfoIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: SearchInfoIdentifier) as? SearchInfoCell
        }
        cell?.selectionStyle = .none
        cell?.name.text = searchResults[indexPath.row].3
        cell?.start.text = searchResults[indexPath.row].0
        cell?.stop.text = searchResults[indexPath.row].1
        cell?.end.text = searchResults[indexPath.row].2
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = NSNotification.Name(rawValue: ShowRouteNotification)
        NotificationCenter.default.post(name: notification, object: nil)
        dismiss(self)
    }
}
