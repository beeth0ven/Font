//
//  ViewController.swift
//  Font
//
//  Created by luojie on 2016/11/25.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import BNKit

class MenuTableViewController: UITableViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = "版本 \(InfoPlist.appVersion)"
    }
    
}

class FTSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        preferredDisplayMode = .allVisible
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
