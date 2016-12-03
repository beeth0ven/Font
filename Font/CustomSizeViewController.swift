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
    
    private let x = UserDefaults.standard.rx.value(forKey: "CustomSizeViewController.x", default: 8 as CGFloat)
    private let y = UserDefaults.standard.rx.value(forKey: "CustomSizeViewController.y", default: 8 as CGFloat)
    private let width = UserDefaults.standard.rx.value(forKey: "CustomSizeViewController.width", default: 200 as CGFloat)
    private let height = UserDefaults.standard.rx.value(forKey: "CustomSizeViewController.height", default: 120 as CGFloat)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // textField <-> variable
        
        xTextField.rx.text.cgFloat <-> variable { $0.x }
        yTextField.rx.text.cgFloat <-> variable { $0.y }
        widthTextField.rx.text.cgFloat <-> variable { $0.width }
        heightTextField.rx.text.cgFloat <-> variable { $0.height }
        
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

extension ControlPropertyType where E == String? {
    
    public var cgFloat: ControlProperty<CGFloat> {
        let getter = asControlProperty().map { $0.flatMap(Double.init) }
            .map { $0.flatMap { CGFloat.init($0) } }
            .filterNil()
            .distinctUntilChanged()
        
        let setter = asControlProperty().mapObserver { (value: CGFloat) in
            Int(value).description
        }
        
        return ControlProperty(values: getter, valueSink: setter)
    }
}


extension ControlPropertyType where E == Double {
    
    public var cgFloat: ControlProperty<CGFloat> {
        return asControlProperty()
            .map(
                onObservale: { CGFloat($0) },
                onObserver: Double.init
        )
    }
}


