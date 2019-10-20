//
//  ViewController.swift
//  Bnet_task
//
//  Created by Tianid on 18.10.2019.
//  Copyright © 2019 Tianid. All rights reserved.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    private let reachability = SCNetworkReachabilityCreateWithName(nil, "\(myAPI)")
    private var isFirstStart = true
    private let userDefault = UserDefaults.standard
    private let cellIdentifier = "myCell"
    
    
    @IBAction func addAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddNewEntryVC") as! AddNewEntryViewController
        vc.updateTable = {
            DispatchQueue.main.async {
                self.myTableView.reloadData()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isFirstStart {
            tryNetworkTask()
        }
    }

    private func showAlert() {
        let alert = UIAlertController(title: "Error", message: "No connection!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
            self?.tryNetworkTask()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func isNetworkReachable() -> Bool {
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(self.reachability!, &flags)

        let isReachable = flags.contains(.reachable)
        let needsConncetion = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConntectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConncetion || canConntectWithoutUserInteraction)
    }
    
    private func tryNetworkTask() {
        if !isNetworkReachable() {
            showAlert()
        } else {
            if let value = userDefault.object(forKey: "session") as? String {
                NetworkManager.shared.session = value
                getEntries()
            } else {
                NetworkManager.shared.getNewSession { [weak self] (session) in
                    guard let session = session else { return }
                    self?.userDefault.setValue(session, forKey: "session")
                }
            }
            isFirstStart = !isFirstStart
        }
    }
    
    func getEntries() {
        NetworkManager.shared.getEntries { [weak self] (result, error) in
            if result {
                DispatchQueue.main.async {
                    self?.myTableView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkManager.shared.allEntries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MyTableViewCell {
            
            let entry = NetworkManager.shared.allEntries?[indexPath.row]
            cell.entryBodyLabel.text = getFormatedBody(text: entry!.body)
            let date = getFormatedDate(entryDate: Int(entry!.da)!)
            cell.creationDateLabel.text = date
            if entry?.da != entry?.dm {
                cell.updatingDateLabel.isHidden = false
                let date = getFormatedDate(entryDate: Int(entry!.dm)!)
                cell.updatingDateLabel.text = date
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        detailsVC.entry = NetworkManager.shared.allEntries?[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
        
        
    }
    
    
    private func getFormatedBody(text: String) -> String {
        if text.count <= 200 {
            return text

        } else {
            let mySubstring = text.prefix(200)
            return String(mySubstring)
        }
    }
    
    private func getFormatedDate(entryDate: Int) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC+3")
            dateFormatter.dateFormat = "d MMM yyyy HH:MM"
            dateFormatter.locale = Locale(identifier: "ru_RU")
            return dateFormatter.string(for: Date(timeIntervalSince1970: TimeInterval(entryDate)))!
        }
    
    
}

