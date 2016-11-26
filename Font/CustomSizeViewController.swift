//
//  CustomSizeViewController.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BNKit

class CustomSizeViewController: UIViewController {
    
    @IBOutlet private weak var xConstraint: NSLayoutConstraint!
    @IBOutlet private weak var yConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var xTextField: RegularExpressionTextField!
    @IBOutlet private weak var yTextField: RegularExpressionTextField!
    @IBOutlet private weak var widthTextField: RegularExpressionTextField!
    @IBOutlet private weak var heightTextField: RegularExpressionTextField!
    @IBOutlet private weak var sampleView: UIView!
    
    private let x = Variable<CGFloat>(8.0)
    private let y = Variable<CGFloat>(8.0)
    private let width = Variable<CGFloat>(8.0)
    private let height = Variable<CGFloat>(8.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        xTextField.rx.cgFloat.filterNil()
            --> variable { $0.x }
        
        yTextField.rx.cgFloat.filterNil()
            --> variable { $0.y }
        
        widthTextField.rx.cgFloat.filterNil()
            --> variable { $0.width }
        
        heightTextField.rx.cgFloat.filterNil()
            --> variable { $0.height }
        
        x.asDriver() --> binding { $0.xConstraint.constant = $1 }
        y.asDriver() --> binding { $0.yConstraint.constant = $1 }
        width.asDriver() --> binding { $0.widthConstraint.constant = $1 }
        height.asDriver() --> binding { $0.heightConstraint.constant = $1 }
        
        x.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.xTextField.text = Int($1).description }
        
        y.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.yTextField.text = Int($1).description }
        
        width.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.widthTextField.text = Int($1).description }
        
        height.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.heightTextField.text = Int($1).description }
    }
    
    @IBAction func didPanSampleView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sampleView)
        x.value += translation.x
        y.value += translation.y
        sender.setTranslation(.zero, in: sampleView)
    }
    
    @IBAction func didPanHandler(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sampleView)
        width.value += translation.x
        height.value += translation.y
        sender.setTranslation(.zero, in: sampleView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
