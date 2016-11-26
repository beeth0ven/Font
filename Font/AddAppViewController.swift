//
//  AddAppViewController.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import BNKit
import RxSwift
import RxCocoa

class AddAppViewController: UIViewController {
    
    private let app = Application.insert()
    
    @IBOutlet private weak var doneBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var nameTextField: RegularExpressionTextField!
    @IBOutlet private weak var captionTextView: PlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.becomeFirstResponder()
        
        nameTextField.rx.text --> binding { $0.app.name = $1 }
        
        captionTextView.rx.text --> binding { $0.app.caption = $1 }

        nameTextField.isValid --> observer { $0.doneBarButtonItem.rx.isEnabled }
        
        cancelBarButtonItem.rx.tap --> binding { $0.0.app.delete() }
        
        Observable.of(cancelBarButtonItem.rx.tap, doneBarButtonItem.rx.tap)
            .merge() --> observer { $0.rx.dismiss }
        
        
    }
}
