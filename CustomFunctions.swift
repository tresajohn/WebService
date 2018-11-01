//
//  CustomFunctions.swift
//  Virob
//
//  Created by Thomas Chacko on 01/08/18.
//  Copyright © 2018 Thomas Chacko. All rights reserved.
//

import Foundation
import  UIKit

func whitespaceValidation(_ name:String) -> Bool {
    let whitespaceSet = CharacterSet.whitespaces
    if !name.trimmingCharacters(in: whitespaceSet).isEmpty {
        return true
    } else {
        return false
    }
}

func emailValidation(_ email:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    if emailTest.evaluate(with: email) {
        return true
    } else {
        return false
    }
}

func passwordValidation(_ password:String) -> Bool {
    let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[0-9].*[0-9])(?=.*[$@$!%*#?&])[A-Za-z0-9$@$!%*#?&]{6,}$"
    let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
    if passwordTest.evaluate(with: password) {
        return true
    } else {
        return false
    }
}

func fullNameValidation(_ fullName:String) -> Bool {
    let fullNameRegEx = "^[A-Z][a-zA-Z]{1,}(?: [A-Z][a-zA-Z]*){1,2}$"
    let fullNameTest = NSPredicate(format:"SELF MATCHES %@", fullNameRegEx)
    if fullNameTest.evaluate(with: fullName) {
        return true
    } else {
        return false
    }
}

func validateUsername(str: String) -> Bool {
    if str.count > 5 && str.count < 16 {
        let regex = "^[0-9a-z\\_]{6,18}$"
        let fullNameTest = NSPredicate(format:"SELF MATCHES %@", regex)
        if fullNameTest.evaluate(with: str) {
            return true
        }
    }
    return false
}

func isValidName(_ nameString: String) -> Bool {
    var returnValue = true
    let mobileRegEx =  "[A-Za-z]"  // {3} -> at least 3 alphabet are compulsory.
    do {
        let regex = try NSRegularExpression(pattern: mobileRegEx)
        let nsString = nameString as NSString
        let results = regex.matches(in: nameString, range: NSRange(location: 0, length: nsString.length))
        
        if results.count == 0
        {
            returnValue = false
        }
        
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        returnValue = false
    }
    return  returnValue
}

func setShadow(shadowView: UIView,color:UIColor, opacity: Float,radius:CGFloat) {
    shadowView.layer.shadowColor = color.cgColor
    shadowView.layer.shadowOpacity = opacity
    shadowView.layer.shadowOffset = CGSize.zero
    shadowView.layer.shadowRadius = radius
}

class CustomTabBar : UITabBar {
    @IBInspectable var height: CGFloat = 0.0    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if height > 0.0 {
            sizeThatFits.height = height
        }
        return sizeThatFits
    }
}

class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateLeftView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var imageColor: UIColor = UIColor.lightGray {
        didSet {
            updateLeftView()
        }
    }
    
    @IBInspectable var placeHolderColor: UIColor = UIColor.lightGray {
        didSet {
            updateLeftView()
        }
    }
    
    func updateLeftView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = imageColor
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: placeHolderColor])
    }
    
    // Provides right padding for images
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= rightPadding
        return textRect
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0
    
    @IBInspectable var rightImageColor: UIColor = UIColor.lightGray {
        didSet {
            updateRightView()
        }
    }
    
    @IBInspectable var rightPlaceHolderColor: UIColor = UIColor.lightGray {
        didSet {
            updateRightView()
        }
    }
    
    func updateRightView() {
        if let image = rightImage {
            rightViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = rightImageColor
            rightView = imageView
        } else {
            rightViewMode = UITextFieldViewMode.never
            rightView = nil
        }
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: rightPlaceHolderColor
            ])
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func md5(string: String) -> String {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }
    return digestData.map { String(format: "%02hhx", $0) }.joined()
}
