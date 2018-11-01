//
//  EditAccountTableViewController.swift
//  Virob
//
//  Created by Thomas Chacko on 29/08/18.
//  Copyright © 2018 Thomas Chacko. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SDWebImage
import Photos

class EditAccountTableViewController: UITableViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var displayNameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var contactNoTextField: SkyFloatingLabelTextFieldWithIcon!
    
    var profileUpdateDictionary : NSDictionary?
    var errorCode : NSDictionary?
    
    var firstNameStatusTag : Bool?
    var lastNameStatusTag : Bool?
    var displayNameStatusTag : Bool?
    
    var profileImageUpdateDetails : NSDictionary?
    var fileType : String?
    var mimeName : String?
    var cameraFlag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        userProfileImageView.layer.masksToBounds = true
        let userProfileImageUrl = URL(string: userProfile)
        if userProfileImageUrl != nil {
            self.userProfileImageView.sd_setImage(with: userProfileImageUrl!, placeholderImage: UIImage(named:""), options: [SDWebImageOptions.continueInBackground, SDWebImageOptions.lowPriority, SDWebImageOptions.refreshCached, SDWebImageOptions.handleCookies, SDWebImageOptions.retryFailed]) { (image, error, cacheType, url) in
                if error != nil {
                    print("Failed: \(String(describing: error))")
                } else {
                    print("Success")
                }
            }
        }
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        displayNameTextField.delegate = self
        saveButton.isEnabled = false
        saveButton.layer.cornerRadius = 10
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        firstNameTextField.text = userFirstName
        lastNameTextField.text = userLastName
        displayNameTextField.text = userName
        emailTextField.text = userEmail
        contactNoTextField.text = userPhoneCode + userMobile
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.backgroundColor = UIColor.lightGray
        saveButton.isEnabled =  false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        firstNameStatusTag = true
        lastNameStatusTag = true
        displayNameStatusTag = true
        if textField.tag == 0 {
            firstNameTextField.text = firstNameTextField.text?.trailingSpacesTrimmed
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if whitespaceValidation(firstNameTextField.text!) != true {
                    floatingLabelTextField.errorMessage = "Please enter first name"
                    firstNameStatusTag = false
                } else if Int(firstNameTextField.text!) != nil || isValidName(firstNameTextField.text!) != true {
                    floatingLabelTextField.errorMessage = "Please enter valid first name"
                    firstNameStatusTag = false
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        if textField.tag == 1 {
            lastNameTextField.text = lastNameTextField.text?.trailingSpacesTrimmed
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if whitespaceValidation(lastNameTextField.text!) != true {
                    floatingLabelTextField.errorMessage = "Please enter last name"
                    lastNameStatusTag = false
                } else if Int(lastNameTextField.text!) != nil || isValidName(lastNameTextField.text!) != true {
                    floatingLabelTextField.errorMessage = "Please enter valid last name"
                    lastNameStatusTag = false
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        if textField.tag == 2 {
            displayNameTextField.text = displayNameTextField.text?.trailingSpacesTrimmed
            displayNameTextField.text = displayNameTextField.text?.lowercased()
            if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
                if whitespaceValidation(displayNameTextField.text!) != true {
                    floatingLabelTextField.errorMessage = "Please enter username"
                    displayNameStatusTag = false
                } else if validateUsername(str: displayNameTextField.text!) != true {
                    floatingLabelTextField.errorMessage = "Please enter valid username"
                    displayNameStatusTag = false
                } else {
                    floatingLabelTextField.errorMessage = ""
                }
            }
        }
        if firstNameStatusTag == true && lastNameStatusTag == true && displayNameStatusTag == true {
            saveButton.backgroundColor = UIColor(named: "cs_green")
            saveButton.isEnabled = true
        } else {
            saveButton.backgroundColor = UIColor.lightGray
            saveButton.isEnabled =  false
        }
        return true
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {        
        profileUpdate()
    }
    
    func profileUpdate() {
        let frame = CGRect(x: (view.frame.width)/2 - 40, y: (view.frame.height)/2 - 40, width: 80, height: 80)
        let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                            type: NVActivityIndicatorType(rawValue: 23)!,color: UIColor(named: "cs_pink")!, padding: 10)
        
        if NVActivityIndicatorType.orbit.rawValue == 23 {
            activityIndicatorView.padding = 5
        }
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        WebServices.profileUpdate(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!,displayName:displayNameTextField.text!) {(result, message, status )in
            activityIndicatorView.stopAnimating()
            if (message == "No Internet Connection") {
                return
            }
            if status {
                let profileUpdateDetails = result as? WebServices
                self.profileUpdateDictionary = profileUpdateDetails?.apiResponseData
                if responseStatus == 400 {
                    self.errorCode = self.profileUpdateDictionary?["error"] as? NSDictionary
                    if self.errorCode?["first_name"] != nil {
                        if let codeerror = (self.errorCode?["first_name"] as? [String]) {
                            for codeItem in codeerror{
                                self.alertMessage(alerttitle: "", codeItem)
                            }
                        }
                    }
                    if self.errorCode?["last_name"] != nil {
                        if let codeerror = (self.errorCode?["last_name"] as? [String]) {
                            for codeItem in codeerror{
                                self.alertMessage(alerttitle: "", codeItem)
                            }
                        }
                    }
                    if self.errorCode?["display_name"] != nil {
                        if let codeerror = (self.errorCode?["display_name"] as? [String]) {
                            for codeItem in codeerror{
                                self.alertMessage(alerttitle: "", codeItem)
                            }
                        }
                    }
                } else if responseStatus == 422 {
                    self.alertMessage(alerttitle: "", (self.profileUpdateDictionary?["msg"] as? String)!)
                } else if responseStatus == 200 {
                    userFirstName = self.firstNameTextField.text!
                    userLastName = self.lastNameTextField.text!
                    userName = self.displayNameTextField.text!
                    userEmail = self.emailTextField.text!
                    userMobile = self.contactNoTextField.text!
                    self.alertMessage(alerttitle: "", (self.profileUpdateDictionary?["msg"] as? String)!)
                } else {
                    self.alertMessage(alerttitle: "", (self.profileUpdateDictionary?["msg"] as? String)!)
                }
            } else {
                self.alertMessage(alerttitle: "", "Sorry for the inconvenience!Try again later.")
            }
        }
    }
    
    @IBAction func editImageButtonClicked(_ sender: UIButton) {
        imageUpdateButtonClicked()
    }
    
    @objc func imageUpdateButtonClicked() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        //Select Image from Gallery
        let library = UIAlertAction(title: "Select From Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkPhotoLibraryPermission()
        })
        //Select Image from Camera
        let camera = UIAlertAction(title: "Select From Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            switch cameraAuthorizationStatus {
            case .notDetermined: self.requestCameraPermission()
            case .authorized: self.imageFromCamera()
            case .restricted, .denied: self.alertCameraAccessNeeded()
            }
        })
        //Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(library)
        optionMenu.addAction(camera)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized: imageFromLibrary()
        case .denied,.restricted : break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized: self.imageFromLibrary()
                case .denied, .restricted,.notDetermined: break
                }
            }
        }
    }
    
    func imageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)

        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
            cameraFlag = 1
        }
    }
    
    func imageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            cameraFlag = 0
        }
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.imageFromCamera()
        })
    }
    
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplicationOpenSettingsURLString)!
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to make full use of this app.",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        userProfileImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if cameraFlag == 0 {
            let documentDirectory: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
            let imageName = "temp"
            let imagePath = documentDirectory.appendingPathComponent(imageName)
            if let data = UIImageJPEGRepresentation(userProfileImageView.image!, 80) {
                do {
                    try data.write(to: URL(fileURLWithPath: imagePath), options: .atomic)
                } catch {
                    print(error)
                }
            }
            mimeName = "image/jpg"
            fileType = "profileImage.jpg"
        } else if cameraFlag == 1 {
            let assetPath = info[UIImagePickerControllerReferenceURL] as! URL
            let result = PHAsset.fetchAssets(withALAssetURLs: [assetPath as URL], options: nil)
            let asset = result.firstObject
            let fileName = asset?.value(forKey: "filename")
            if fileName == nil {
                _ = "temp"
            } else {
                let fileUrl = URL(string: fileName as! String)
                _ = fileUrl?.deletingPathExtension().lastPathComponent
            }
            if (assetPath.absoluteString.hasSuffix("JPG")) {
                mimeName = "image/jpg"
                fileType = "\(String(describing: fileName)).jpg"
            } else if (assetPath.absoluteString.hasSuffix("JPEG")) {
                mimeName = "image/jpeg"
                fileType = "\(String(describing: fileName)).jpeg"
            } else if (assetPath.absoluteString.hasSuffix("PNG")) {
                mimeName = "image/png"
                fileType = "\(String(describing: fileName)).png"
            } else if (assetPath.absoluteString.hasSuffix("GIF")) {
                mimeName = "image/gif"
                fileType = "\(String(describing: fileName)).gif"
            } else if (assetPath.absoluteString.hasSuffix("SVG")) {
                mimeName = "image/svg"
                fileType = "\(String(describing: fileName)).svg"
            } else if (assetPath.absoluteString.hasSuffix("TIFF")) {
                mimeName = "image/tiff"
                fileType = "\(String(describing: fileName)).tiff"
            }
        }
        profileImageUpdateFunction()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func profileImageUpdateFunction() {
        WebServices.profileImageUpdate(imageName: (userProfileImageView.image?.resizedTo1MB()!)!,fileExtension : fileType!,mimeType: mimeName!) {(result, message, status )in
            if status {
                let profileImageUpdateDictionary = result as? WebServices
                self.profileImageUpdateDetails = (profileImageUpdateDictionary?.apiResponseData)!
                if self.profileImageUpdateDetails?["error"] as? NSDictionary != nil
                {
                    self.errorCode = self.profileImageUpdateDetails?["error"] as? NSDictionary
                    if self.errorCode?["attachment"] != nil {
                        if let attachmentError = (self.errorCode?["attachment"] as? [String]){
                            for attachmentItem in attachmentError{
                                self.alertMessage(alerttitle: "", attachmentItem)
                            }
                        }
                    }
                } else if responseStatus == 200 {
                    self.alertMessage(alerttitle: "", (self.profileImageUpdateDetails?["msg"] as? String)!)
                    //userProfile = (self.profileImageUpdateDetails?["profile_img"] as? String)!
                    if let profileImage = self.profileImageUpdateDetails?["profile_img"] as? String {
                        defaults.setValue(profileImage,forKey:"profileImageUrl")
                    } else {
                        defaults.setValue("",forKey:"profileImageUrl")
                    }
                    userProfile = defaults.string(forKey: "profileImageUrl")!
                    
                } else if self.profileImageUpdateDetails?["msg"] as? String == "Unauthorized access"
                {
                    self.alertMessage(alerttitle: "", (self.profileImageUpdateDetails?["msg"] as? String)!)
                }
            } else {
                self.alertMessage(alerttitle: "", "Sorry for the inconvenience!Try again later.")
            }
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
