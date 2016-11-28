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
    
    private let insetsTop = ComputedVariable<CGFloat>(userDefaultskey: "InsetsViewController.insetsTop", default: 8)
    private let insetsLeft = ComputedVariable<CGFloat>(userDefaultskey: "InsetsViewController.insetsLeft", default: 8)
    private let insetsBottom = ComputedVariable<CGFloat>(userDefaultskey: "InsetsViewController.insetsBottom", default: 8)
    private let insetsRight = ComputedVariable<CGFloat>(userDefaultskey: "InsetsViewController.insetsRight", default: 8)
    private let insetsHorizontally = ComputedVariable<CGFloat>(userDefaultskey: "InsetsViewController.insetsHorizontally", default: 8)
    private let insetsVertically = ComputedVariable<CGFloat>(userDefaultskey: "InsetsViewController.insetsVertically", default: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // textField <-> variable
        
        topTextField.rx.cgFloatValue <-> variable { $0.insetsTop }
        leftTextField.rx.cgFloatValue <-> variable { $0.insetsLeft }
        bottomTextField.rx.cgFloatValue <-> variable { $0.insetsBottom }
        rightTextField.rx.cgFloatValue <-> variable { $0.insetsRight }
        horizontallyTextField.rx.cgFloatValue <-> variable { $0.insetsHorizontally }
        verticallyTextField.rx.cgFloatValue <-> variable { $0.insetsVertically }
        
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
        insetsTop.value = max(0, insetsTop.value + translation.y)
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanLeft(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsLeft.value = max(0, insetsLeft.value + translation.x)
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanBottom(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsBottom.value = max(0, insetsBottom.value - translation.y)
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanRight(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsRight.value = max(0, insetsRight.value - translation.x)
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanTopLeft(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsTop.value = max(0, insetsTop.value + translation.y)
        insetsLeft.value = max(0, insetsLeft.value + translation.x)
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanTopRight(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsTop.value = max(0, insetsTop.value + translation.y)
        insetsRight.value = max(0, insetsRight.value - translation.x)
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanBottomLeft(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsBottom.value = max(0, insetsBottom.value - translation.y)
        insetsLeft.value = max(0, insetsLeft.value + translation.x)
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanBottomRight(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsBottom.value = max(0, insetsBottom.value - translation.y)
        insetsRight.value = max(0, insetsRight.value - translation.x)
        sender.setTranslation(.zero, in: nil)
    }
    
    @IBAction func didPanCenter(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        insetsHorizontally.value = max(0, insetsHorizontally.value - translation.x)
        insetsVertically.value = max(0, insetsVertically.value - translation.y)
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
