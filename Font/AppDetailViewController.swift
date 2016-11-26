//
//  AppDetailViewController.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import BNKit
import RxSwift
import RxCocoa


class AppDetailViewController: UIViewController {
    
    var app: Application!
    
    @IBOutlet private weak var nameTextField: RegularExpressionTextField!
    @IBOutlet private weak var captionTextView: PlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        setupRx()
    }
    
    private func updateUI() {
        nameTextField.text = app.name
        captionTextView.text = app.caption
    }
    
    private func setupRx() {
        
        nameTextField.rx.text --> binding { $0.app.name = $1 }
        
        captionTextView.rx.text --> binding { $0.app.caption = $1 }
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        nameTextField.isEnabled = editing
        captionTextView.isEditable = editing
        
        nameTextField.becomeFirstResponder()
    }
}
