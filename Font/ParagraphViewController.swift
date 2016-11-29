//
//  ParagraphViewController.swift
//  Font
//
//  Created by luojie on 2016/11/29.
//  Copyright © 2016年 LuoJie. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import BNKit

class ParagraphViewController: UIViewController {
    
    @IBOutlet private weak var fontSizeTextField: RegularExpressionTextField!
    @IBOutlet private weak var verticallyTextField: RegularExpressionTextField!
    @IBOutlet private weak var fontSizeStepper: UIStepper!
    @IBOutlet private weak var verticallyStepper: UIStepper!
    
    @IBOutlet private weak var textView: UITextView!
    
    private let fontSize = ComputedVariable<CGFloat>(userDefaultskey: "ParagraphViewController.fontSize", default: 14)
    private let insetsVertically = ComputedVariable<CGFloat>(userDefaultskey: "ParagraphViewController.insetsVertically", default: 8)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textField <-> variable
        
        fontSizeTextField.rx.cgFloatValue <-> variable { $0.fontSize }
        verticallyTextField.rx.cgFloatValue <-> variable { $0.insetsVertically }
        
        // variable --> view
        
        fontSize.asDriver() --> binding { $0.updateTextView(fontSize: $1) }
        insetsVertically.asDriver() --> binding { $0.updateTextView(insetsVertically: $1) }
        
        // variable --> stepper
        
        fontSize.asDriver() --> binding { $0.fontSizeStepper.value = Double($1) }
        insetsVertically.asDriver() --> binding { $0.verticallyStepper.value = Double($1) }
        
        // stepper --> variable
        
        fontSizeStepper.rx.value --> binding { $0.fontSize.value = max(10, CGFloat($1)) }
        verticallyStepper.rx.value --> binding { $0.insetsVertically.value = max(0, CGFloat($1)) }
    }
    
    // updateTextView
    
    private func updateTextView(fontSize: CGFloat) {
        let range = NSRange(location: 0, length: textView.text.characters.count)
        let attrs = [NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)]
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedText.addAttributes(attrs, range: range)
        textView.attributedText = attributedText
    }
    
    private func updateTextView(insetsVertically: CGFloat) {
        let range = NSRange(location: 0, length: textView.text.characters.count)
        let paragraph = NSMutableParagraphStyle(); paragraph.lineSpacing = insetsVertically
        let attrs = [NSParagraphStyleAttributeName: paragraph]
        let attributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedText.addAttributes(attrs, range: range)
        textView.attributedText = attributedText
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
