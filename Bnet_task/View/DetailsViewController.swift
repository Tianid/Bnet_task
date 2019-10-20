//
//  DetailsViewController.swift
//  Bnet_task
//
//  Created by Tianid on 19.10.2019.
//  Copyright © 2019 Tianid. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var entry: Entry?

    @IBOutlet weak var updatingDateLAbel: UILabel!
    @IBOutlet weak var entryBodyTextView: UITextView!
    @IBOutlet weak var creatingDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        entryBodyTextView.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    private func setup() {
        entryBodyTextView.text = entry?.body
        updatingDateLAbel.text = getFormatedDate(entryDate: Int(entry!.dm)!)
        creatingDateLabel.text = getFormatedDate(entryDate: Int(entry!.da)!)
    }
    
    
    private func getFormatedDate(entryDate: Int) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC+3")
            dateFormatter.dateFormat = "d MMM yyyy HH:MM"
            dateFormatter.locale = Locale(identifier: "ru_RU")
            return dateFormatter.string(for: Date(timeIntervalSince1970: TimeInterval(entryDate)))!
        }
    
}
