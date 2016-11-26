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
    
    private let insetsTop = Variable<CGFloat>(8.0)
    private let insetsLeft = Variable<CGFloat>(8.0)
    private let insetsBottom = Variable<CGFloat>(8.0)
    private let insetsRight = Variable<CGFloat>(8.0)
    private let insetsHorizontally = Variable<CGFloat>(8.0)
    private let insetsVertically = Variable<CGFloat>(8.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
