//
//  InsetsViewController.swift
//  Font
//
//  Created by luojie on 2016/11/26.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BNKit

class InsetsViewController: UIViewController {
    
    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var rightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var topTextField: RegularExpressionTextField!
    @IBOutlet private weak var leftTextField: RegularExpressionTextField!
    @IBOutlet private weak var bottomTextField: RegularExpressionTextField!
    @IBOutlet private weak var rightTextField: RegularExpressionTextField!
    @IBOutlet private weak var horizontallyTextField: RegularExpressionTextField!
    @IBOutlet private weak var verticallyTextField: RegularExpressionTextField!
    @IBOutlet private weak var verticallyStackView: UIStackView!
    @IBOutlet private var horizontallyStackViews: [UIStackView]!
    @IBOutlet private weak var centerHandlerView: UIView!
    
    private let insetsTop = Variable<CGFloat>(8.0)
    private let insetsLeft = Variable<CGFloat>(8.0)
    private let insetsBottom = Variable<CGFloat>(8.0)
    private let insetsRight = Variable<CGFloat>(8.0)
    private let insetsHorizontally = Variable<CGFloat>(8.0)
    private let insetsVertically = Variable<CGFloat>(8.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textField --> variable
        
        topTextField.rx.cgFloat.filterNil()
            --> variable { $0.insetsTop }
        
        leftTextField.rx.cgFloat.filterNil()
            --> variable { $0.insetsLeft }
        
        bottomTextField.rx.cgFloat.filterNil()
            --> variable { $0.insetsBottom }
        
        rightTextField.rx.cgFloat.filterNil()
            --> variable { $0.insetsRight }
        
        horizontallyTextField.rx.cgFloat.filterNil()
            --> variable { $0.insetsHorizontally }
        
        verticallyTextField.rx.cgFloat.filterNil()
            --> variable { $0.insetsVertically }
        
        // variable --> textField
        
        insetsTop.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.topTextField.text = Int($1).description }
        
        insetsLeft.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.leftTextField.text = Int($1).description }
        
        insetsBottom.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.bottomTextField.text = Int($1).description }
        
        insetsRight.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.rightTextField.text = Int($1).description }
        
        insetsHorizontally.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.horizontallyTextField.text = Int($1).description }
        
        insetsVertically.asDriver().distinctUntilChanged().throttle(0.1)
            --> binding { $0.verticallyTextField.text = Int($1).description }
        
        // variable --> view

        insetsTop.asDriver() --> binding { $0.topConstraint.constant = $1 }
        insetsLeft.asDriver() --> binding { $0.leftConstraint.constant = $1 }
        insetsBottom.asDriver() --> binding { $0.bottomConstraint.constant = $1 }
        insetsRight.asDriver() --> binding { $0.rightConstraint.constant = $1 }
        insetsVertically.asDriver() --> binding { $0.verticallyStackView.spacing = $1 }
        insetsHorizontally.asDriver() --> binding { (selfvc, insetsHorizontally) in
            selfvc.horizontallyStackViews.forEach {
                $0.spacing = insetsHorizontally
            }
        }
        
    }
    
    // view --> variable

    @IBAction func didPanTop(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsTop.value += translation.y
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanLeft(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsLeft.value += translation.x
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanBottom(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsBottom.value -= translation.y
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanRight(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsRight.value -= translation.x
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanTopLeft(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsLeft.value += translation.x
        insetsTop.value += translation.y
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanTopRight(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsRight.value -= translation.x
        insetsTop.value += translation.y
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanBottomLeft(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsLeft.value += translation.x
        insetsBottom.value -= translation.y
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanBottomRight(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsRight.value -= translation.x
        insetsBottom.value -= translation.y
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanCenter(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsHorizontally.value -= translation.x
        insetsVertically.value -= translation.y
        sender.setTranslation(.zero, in: nil)
        
        switch sender.state {
        case .began:
            centerHandlerView.alpha = 1
        case .cancelled, .ended, .failed:
            centerHandlerView.alpha = 0
        default:
            break
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension Reactive where Base: UITextField {
    
    /// Reactive wrapper for `text` property.
    public var cgFloat: Observable<CGFloat?> {
        return text.map {
            $0.flatMap(Double.init)
                .flatMap { CGFloat($0) }
        }
    }
}
