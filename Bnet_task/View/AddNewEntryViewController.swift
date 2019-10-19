//
//  DetailViewController.swift
//  Bnet_task
//
//  Created by Tianid on 19.10.2019.
//  Copyright © 2019 Tianid. All rights reserved.
//

import UIKit

class AddNewEntryViewController: UIViewController {
    
    var updateTable: (() -> ())?

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        NetworkManager.shared.addEntry(text: textView.text)
        NetworkManager.shared.getEntries { [weak self] (result, error) in
            if result {
                DispatchQueue.main.async {
                    self?.showToast()
                    self?.updateTable!()
                }
            }
        }
    }
    
    private func showToast() {
        
        let alert = UIAlertController(title: nil, message: "Saved", preferredStyle: .alert)
        alert.view.alpha = 0
        alert.view.layer.cornerRadius = 15
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
