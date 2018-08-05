//
//  ViewController.swift
//  ResizingScrollViewOnKeyBoardAppearance
//
//  Created by Avinash Kaul on 05/08/18.
//  Copyright © 2018 Avinash Kaul. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    /* this will hold the current text field being edited */
    var currentTextField:UITextField?
    /* this will hold the contentoffset of the scrollview before resizing of the scrollview, this will be used to restore the content offset of scroll view when keyboard is hidden */
    var lastOffset:CGPoint?
    var keyboardHeight:CGFloat?
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting delegate for textfield
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        //Adding observers
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        //Setting textfield Style
        setStyle(layer: self.nameTextField.layer)
        setStyle(layer: self.emailTextField.layer)
        setStyle(layer: self.passwordTextField.layer)
        setStyle(layer: self.confirmPasswordTextField.layer)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setStyle(layer:CALayer){
        layer.cornerRadius = 5
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 0.5
        layer.shadowOpacity = 0.40
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        //saving the contentOffset of scrollview
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        currentTextField?.resignFirstResponder()
        currentTextField = nil
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3, animations: {
                self.contentViewHeightConstraint.constant += self.keyboardHeight!
            })
            
            
            let distanceToBottom = self.scrollView.frame.size.height - (currentTextField?.frame.origin.y)! - (currentTextField?.frame.size.height)!
            let collapseSpace = keyboardHeight! - distanceToBottom
            if collapseSpace < 0 {
                return
            }
            UIView.animate(withDuration: 0.3, animations: {
                //Your scrollview will scroll to 5 coordinates above the keyboard
                self.scrollView.contentOffset = CGPoint(x: (self.lastOffset?.x)!, y: collapseSpace + 5)
            })
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.keyboardHeight != nil{
            UIView.animate(withDuration: 0.3) {
                self.contentViewHeightConstraint.constant -= self.keyboardHeight!
                self.scrollView.contentOffset = self.lastOffset!
            }
            keyboardHeight = nil
        }
    }

}

