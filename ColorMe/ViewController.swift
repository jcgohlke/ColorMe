//  ViewController.swift
//  ColorMe
//
//  Created by Ben Gohlke on 12/5/18.
//  Copyright © 2018 Ben Gohlke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var colorTextField: UITextField!
    @IBOutlet weak var colorMeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UITextField delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            validateHexCode(textEntered: text ) {
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    // MARK: - Helper functions
    
    func validateHexCode(textEntered hexCode: String) -> Bool {
        var isValidHex = true
        
        let hexValues = CharacterSet.init(charactersIn: "0123456789ABCDEFabcdef#")
        for c in hexCode.unicodeScalars {
            if !hexValues.contains(c) {
                isValidHex = false
                break
            }
        }
        
        return isValidHex
    }
    
    func convert(hexCode hexString: String) -> UIColor? {
        let r, g, b, a: CGFloat
        
        var strippedHexString = hexString
        
        if hexString.hasPrefix("#") {
            strippedHexString = String(hexString.dropFirst(1))
        }
            
        if strippedHexString.count == 6 {
            let scanner = Scanner(string: strippedHexString)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff)) / 255
                
                return UIColor(red: r, green: g, blue: b, alpha: 1.0)
            }
        } else if strippedHexString.count == 8 {
            let scanner = Scanner(string: strippedHexString)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                return UIColor(red: r, green: g, blue: b, alpha: a)
            }
        }
        
        return nil
    }
    
    // MARK: - Action handlers

    @IBAction func colorizeBackground(sender: UIButton) {
        if let text = colorTextField.text,
            validateHexCode(textEntered: text),
            let color = convert(hexCode: text) {
                view.backgroundColor = color
        }
    }
}

