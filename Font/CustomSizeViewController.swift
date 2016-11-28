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
    
    private let x = ComputedVariable<CGFloat>(userDefaultskey: "CustomSizeViewController.x", default: 8)
    private let y = ComputedVariable<CGFloat>(userDefaultskey: "CustomSizeViewController.y", default: 8)
    private let width = ComputedVariable<CGFloat>(userDefaultskey: "CustomSizeViewController.width", default: 200)
    private let height = ComputedVariable<CGFloat>(userDefaultskey: "CustomSizeViewController.height", default: 120)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // textField <-> variable
        
        xTextField.rx.cgFloatValue <-> variable { $0.x }
        yTextField.rx.cgFloatValue <-> variable { $0.y }
        widthTextField.rx.cgFloatValue <-> variable { $0.width }
        heightTextField.rx.cgFloatValue <-> variable { $0.height }
        
        // variable --> view

        x.asDriver() --> binding { $0.xConstraint.constant = $1 }
        y.asDriver() --> binding { $0.yConstraint.constant = $1 }
        width.asDriver() --> binding { $0.widthConstraint.constant = $1 }
        height.asDriver() --> binding { $0.heightConstraint.constant = $1 }
    }
    
    // view --> variable

    @IBAction func didPanSampleView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sampleView)
        x.value = max(0, x.value + translation.x)
        y.value = max(0, y.value + translation.y)
        sender.setTranslation(.zero, in: sampleView)
    }
    
    @IBAction func didPanHandler(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: sampleView)
        width.value = max(0, width.value + translation.x)
        height.value = max(0, height.value + translation.y)
        sender.setTranslation(.zero, in: sampleView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension Reactive where Base: UITextField {
    
    /// Reactive wrapper for `text` property.
    public var cgFloatValue: ControlProperty<CGFloat> {
        
        let getter = text.map { $0.flatMap(Double.init) }
            .map { $0.flatMap { CGFloat.init($0) } }
            .filterNil()
            .distinctUntilChanged()
        
        let setter = UIBindingObserver(UIElement: base) { (base, value: CGFloat) in
            let text = Int(value).description
            if base.text != text {
                base.text = text
            }
        }
        return ControlProperty(values: getter, valueSink: setter)
    }
    
}
