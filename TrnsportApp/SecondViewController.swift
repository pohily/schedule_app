//
//  SecondViewController.swift
//  TrnsportApp
//
//  Created by Michael Pohily on 27.02.2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    var info: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        labelInfo.text = info
    }  

    @IBOutlet weak var labelInfo: UILabel!
    
}
