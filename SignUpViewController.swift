//
//  SignUpViewController.swift
//  Virob
//
//  Created by Thomas Chacko on 01/08/18.
//  Copyright © 2018 Thomas Chacko. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate,CountryListProtocol,NVActivityIndicatorViewable {
    @IBOutlet weak var signUpFullNameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpCountryCodeTextField: UITextField!
    @IBOutlet weak var signUpMobileNumberTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpPasswordLockButton: UIButton!
    @IBOutlet weak var termsPrivacyPolicyTextView: UITextView!
    @IBOutlet weak var promotionsSwitch: UISwitch!
    @IBOutlet weak var signUpReferralTextField: UITextField!
    @IBOutlet weak var signUpHaveARefferal: UIButton!
    @IBOutlet weak var signUpReferralCloseButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var termsConditionSwitch: UISwitch!
    
    @IBOutlet weak var fullNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var countryErrorLabel: UILabel!
    @IBOutlet weak var mobileErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var referralErrorLabel: UILabel!
    
    let termsURLString = "termsURL"
    let privacyURLString = "privacyURL"
    
    //ValidationFields
    var fullNameTag : Bool = false
    var emailTag : Bool = false
    var countryTag : Bool = false
    var mobileTag : Bool = false
    var passwordStatusTag : Bool = false
    var referralStatusTag : Bool = false
    
    var signUpDictionary : NSDictionary?
    var errorCode : NSDictionary?
    var selectedCountryCode : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        initialSetUp()
    }
    
    func initialSetUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Delegate
        signUpFullNameTextField.delegate = self
        signUpEmailTextField.delegate = self
        signUpCountryCodeTextField.delegate = self
        signUpMobileNumberTextField.delegate = self
        signUpPasswordTextField.delegate = self
        signUpReferralTextField.delegate = self
        
        //Corner radius
        signUpFullNameTextField.layer.cornerRadius = 10
        signUpEmailTextField.layer.cornerRadius = 10
        signUpCountryCodeTextField.layer.cornerRadius = 10
        signUpMobileNumberTextField.layer.cornerRadius = 10
        signUpPasswordTextField.layer.cornerRadius = 10
        signUpPasswordLockButton.layer.cornerRadius = 10
        signUpReferralTextField.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        
        let signUpTermsAndPrivacyString = NSMutableAttributedString(string: "I have read and understood Virob Terms of Usage and Privacy Policy",attributes: [NSAttributedStringKey.font: UIFont(name: "Helvetica", size: 15.0)!,NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.darkGray])
        let termsString = signUpTermsAndPrivacyString.mutableString.range(of: "Terms of Usage")
        signUpTermsAndPrivacyString.addAttribute(.link, value: termsURLString, range: termsString)
        let privacyString = signUpTermsAndPrivacyString.mutableString.range(of: "Privacy Policy")
        signUpTermsAndPrivacyString.addAttribute(.link, value: privacyURLString, range: privacyString)
        
        termsPrivacyPolicyTextView.linkTextAttributes = [NSAttributedStringKey.underlineStyle.rawValue: NSUnderlineStyle.styleSingle.rawValue,NSAttributedStringKey.foregroundColor.rawValue:UIColor(named:"cs_pink")!]
        termsPrivacyPolicyTextView.attributedText = signUpTermsAndPrivacyString
        signUpReferralTextField.isHidden = true
        signUpReferralCloseButton.isHidden = true
        signUpButton.isEnabled = false
        
        fullNameErrorLabel.text = ""
        emailErrorLabel.text = ""
        countryErrorLabel.text = ""
        mobileErrorLabel.text = ""
        passwordErrorLabel.text = ""
        referralErrorLabel.text = ""
        navigationFlag = 0
    }
    
    //MARK: - Keyboard Show and Hide Methods
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -20
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if navigationFlag == 1 {
            if signUpCountryCodeTextField.text == "" {
                countryErrorLabel.text = "Please select country code"
                countryTag = false
            } else {
                countryErrorLabel.text = ""
                countryTag = true
            }
        } else {
            countryErrorLabel.text = ""
            countryTag = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
     }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        fullNameErrorLabel.text = ""
        emailErrorLabel.text = ""
        countryErrorLabel.text = ""
        mobileErrorLabel.text = ""
        passwordErrorLabel.text = ""
        referralErrorLabel.text = ""
        
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor.lightGray
        if textField.tag == -1 {
            let countrySelectionController = UIStoryboard(name: "LoginSignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpCountrySelectionViewController") as? SignUpCountrySelectionViewController
            countrySelectionController?.delegate = self            
            self.present(countrySelectionController!, animated: true, completion: nil)
        }
    }
    
    func countryListFunction(countryCode : String,countryId : Int,isdCode : String) {
        
        countryErrorLabel.text = ""
        signUpCountryCodeTextField.text = countryCode + " " + isdCode
        selectedCountryCode = countryId
    }
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        fullNameTag = true
        emailTag = true
        countryTag = true
        mobileTag = true
        passwordStatusTag = true
        referralStatusTag = true
        if textFieldToChange == signUpFullNameTextField {
            fullNameErrorLabel.text = ""
            if (whitespaceValidation(signUpFullNameTextField.text!) == false) {
                signUpFullNameTextField.text = ""
                fullNameErrorLabel.text = "Please enter full name"
                fullNameTag = false
            }
            if (fullNameValidation(signUpFullNameTextField.text!) == false) {
                fullNameErrorLabel.text = "Please enter valid full name"
                fullNameTag = false
            }
        }
        if textFieldToChange == signUpEmailTextField {
            textFieldToChange.text = textFieldToChange.text?.trailingSpacesTrimmed
            emailErrorLabel.text = ""
            let characterSetNotAllowed = CharacterSet.whitespaces
            if let _ = string.rangeOfCharacter(from:NSCharacterSet.uppercaseLetters) {
                return false
            }
            if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive) {
                return false
            } else {
                if (whitespaceValidation(signUpEmailTextField.text!) == false) {
                    emailErrorLabel.text = "Please enter email"
                    emailTag = false
                }
                if (emailValidation(signUpEmailTextField.text!) == false) {
                    emailErrorLabel.text = "Please enter valid email"
                    emailTag = false
                }
            }
        }
        if textFieldToChange == signUpMobileNumberTextField {
            textFieldToChange.text = textFieldToChange.text?.trailingSpacesTrimmed
            mobileErrorLabel.text = ""
            if (whitespaceValidation(signUpMobileNumberTextField.text!) == false) {
                mobileErrorLabel.text = "Please enter mobile number"
                mobileTag = false
            }
        }
        if textFieldToChange == signUpPasswordTextField {
            textFieldToChange.text = textFieldToChange.text?.trailingSpacesTrimmed
            passwordErrorLabel.text = ""
            if (whitespaceValidation(signUpPasswordTextField.text!) == false) {
                passwordErrorLabel.text = "Please enter password"
                passwordStatusTag = false
            }
            if ((signUpPasswordTextField.text?.count)! < 5) {
                passwordErrorLabel.text = "Password cannot be less than 6 characters"
                passwordStatusTag = false
            }
        }
        if textFieldToChange == signUpReferralTextField {
            textFieldToChange.text = textFieldToChange.text?.trailingSpacesTrimmed
            referralErrorLabel.text = ""
            if signUpReferralTextField.isHidden == false {
                if (whitespaceValidation(signUpReferralTextField.text!) == false) {
                    referralErrorLabel.text = "Please enter referral code"
                    referralStatusTag = false
                }
            } else {
                referralStatusTag = true
            }
        }
        if fullNameTag == true && emailTag == true && countryTag == true && mobileTag == true && passwordStatusTag == true && referralStatusTag == true && termsConditionSwitch.isOn == true {
            signUpButton.backgroundColor = UIColor(named: "cs_green")
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = UIColor.lightGray
            signUpButton.isEnabled =  false
        }
        return true
    }
    
    @IBAction func termsAndConditionSwitch(_ sender: UISwitch) {
        if termsConditionSwitch.isOn {
            if fullNameTag == true && emailTag == true && countryTag == true && mobileTag == true && passwordStatusTag == true && referralStatusTag == true && termsConditionSwitch.isOn == true {
                signUpButton.backgroundColor = UIColor(named: "cs_green")
                signUpButton.isEnabled = true
            }
        } else {
            alertMessage(alerttitle: "", "Please agree to the terms and conditions")
            signUpButton.backgroundColor = UIColor.lightGray
            signUpButton.isEnabled =  false
        }
    }
    
    @IBAction func signUpButtonClicked(_ sender: UIButton) {
        signUpFunction()
    }
    
    func signUpFunction() {
        let frame = CGRect(x: (view.frame.width)/2 - 40, y: (view.frame.height)/2 - 40, width: 80, height: 80)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: 23)!,color: UIColor(named: "cs_pink")!, padding: 10)
        
        if NVActivityIndicatorType.orbit.rawValue == 23 {
            activityIndicatorView.padding = 5
        }
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        WebServices.signup(fullName: signUpFullNameTextField.text!, email: signUpEmailTextField.text!, country: selectedCountryCode, mobileNumber: signUpMobileNumberTextField.text!, password: signUpPasswordTextField.text!, agreeToRecOffers: promotionsSwitch.isOn, referralCode: signUpReferralTextField.text!) {(result, message, status )in
            activityIndicatorView.stopAnimating()
            if (message == "No Internet Connection") {
                return
            }
            if status {
                let signUpDetails = result as? WebServices
                self.signUpDictionary = signUpDetails?.apiResponseData
                if responseStatus == 400 {
                    self.errorCode = self.signUpDictionary?["error"] as? NSDictionary
                    if self.errorCode?["full_name"] != nil {
                        if let emailError = (self.errorCode?["full_name"] as? [String]) {
                            for emailItem in emailError{
                                self.fullNameErrorLabel.text = emailItem
                            }
                        }
                    }
                    if self.errorCode?["email"] != nil {
                        if let codeerror = (self.errorCode?["email"] as? [String]) {
                            for codeItem in codeerror{
                                self.emailErrorLabel.text = codeItem
                            }
                        }
                    }
                    if self.errorCode?["country"] != nil {
                        if let codeerror = (self.errorCode?["country"] as? [String]) {
                            for codeItem in codeerror{
                                self.alertMessage(alerttitle: "", codeItem)
                            }
                        }
                    }
                    if self.errorCode?["mob_number"] != nil {
                        if let codeerror = (self.errorCode?["mob_number"] as? [String]) {
                            for codeItem in codeerror{
                                self.mobileErrorLabel.text = codeItem
                            }
                        }
                    }
                    if self.errorCode?["password"] != nil {
                        if let codeerror = (self.errorCode?["password"] as? [String]) {
                            for codeItem in codeerror{
                                self.passwordErrorLabel.text = codeItem
                            }
                        }
                    }
                    if self.errorCode?["referral_code"] != nil {
                        if let codeerror = (self.errorCode?["referral_code"] as? [String]) {
                            for codeItem in codeerror{
                                self.referralErrorLabel.text = codeItem
                            }
                        }
                    }
                } else if responseStatus == 404 || responseStatus == 422 {
                    self.alertMessage(alerttitle: "", (self.signUpDictionary?["msg"] as? String)!)
                } else if responseStatus == 200 {
                    let verifyMobileNumberController =  UIStoryboard(name: "LoginSignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpVerifyMobileNumberViewController") as? SignUpVerifyMobileNumberViewController
                    verifyMobileNumberController?.regToken = self.signUpDictionary?["regtoken"] as? String
                    if let dataDictionary = self.signUpDictionary?["data"] as? NSDictionary {
                        verifyMobileNumberController?.parsedCountryCode = (dataDictionary["country_id"] as? Int)!
                        verifyMobileNumberController?.parsedMobileNumer = dataDictionary["mobile"] as? String
                        verifyMobileNumberController?.parsedISDCode = "\(String(describing: dataDictionary["country_code"] as! String)) \(String(describing: dataDictionary["phone_code"] as! String))"
                    }
                    self.navigationController?.show(verifyMobileNumberController!, sender: self)
                } else {
                    self.alertMessage(alerttitle: "", (self.signUpDictionary?["msg"] as? String)!)
                }
            } else {
                self.alertMessage(alerttitle: "", "Sorry for the inconvenience!Try again later.")
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == termsURLString) {
            /*let termController = storyboard?.instantiateViewController(withIdentifier: "CBBLoginTermsViewController") as? CBBLoginTermsViewController
             termController?.termsOrPrivacy = "terms-and-conditions"
             termController?.textLabel = "Terms And Conditions"
             navigationController?.show(termController!, sender: self)*/
        } else if (URL.absoluteString == privacyURLString) {
            /*let privacyController = storyboard?.instantiateViewController(withIdentifier: "CBBLoginTermsViewController") as? CBBLoginTermsViewController
             privacyController?.termsOrPrivacy = "privacy-policies"
             privacyController?.textLabel = "Privacy Policy"
             navigationController?.show(privacyController!, sender: self)*/
        }
        return false
    }
    
    @IBAction func haveAReferralButtonClicked(_ sender: UIButton) {
        signUpButton.backgroundColor = UIColor.lightGray
        signUpButton.isEnabled =  false
        referralStatusTag = false
        signUpReferralCloseButton.isHidden = false
        signUpReferralTextField.isHidden = false
        signUpHaveARefferal.isHidden = true
        signUpReferralTextField.becomeFirstResponder()
    }
    
    @IBAction func referralCloseButtonClicked(_ sender: UIButton) {
        signUpButton.backgroundColor = UIColor(named: "cs_green")
        signUpButton.isEnabled = true
        referralStatusTag = true
        signUpReferralCloseButton.isHidden = true
        signUpReferralTextField.isHidden = true
        signUpHaveARefferal.isHidden = false
        signUpReferralTextField.text = ""
        referralErrorLabel.isHidden = true
    }
    
    @IBAction func signUpPasswordToggleButtonClicked(_ sender: UIButton) {
        if sender.isSelected == false {
            signUpPasswordLockButton.setImage(#imageLiteral(resourceName: "ic_eyeHidden"), for: .normal)
            signUpPasswordTextField.isSecureTextEntry = false
            sender.isSelected = true
        } else if sender.isSelected == true {
            signUpPasswordLockButton.setImage(#imageLiteral(resourceName: "ic_eye"), for: .normal)
            signUpPasswordTextField.isSecureTextEntry = true
            sender.isSelected = false
        }
    }
    
    func alertMessage(alerttitle:String,_ message : String) {
        let alertViewController = UIAlertController(title:alerttitle,  message:message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
