//
//  WebServices.swift
//
//

import Foundation
import Alamofire

class WebServices: NSObject {    
    enum WebServiceNames: String {
        case baseUrl = "https://abc.com/new_staging/"
        case login = "api/v1/user/login"
        case checkLoginStatus = "api/v1/user/check-login-status"        
    }
    
    // MARK: - Variables
    var apiResponseData : NSDictionary?
    
    class func checkLoginStatus(latitude: String,longtitude:String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.checkLoginStatus.rawValue
            let params = ["":""] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["usrtoken":userLoginToken,"lat":latitude,"lng":longtitude]) { (response, message, status) in
                print(response ?? "Error")
                let result = WebServices()
                if let data = response as? NSDictionary {
                    result.apiResponseData = data
                    completion(result, "Success", true)
                } else {
                    completion("" as AnyObject?, "Failed", false)
                }
            }
        } else {
            ErrorReporting.showMessage(title: "No Internet", msg: "Please check your internet connection.")
            completion("" as AnyObject?, "No Net", false)
        }
    }    
    
    class func login(loginUserName: String,loginPassword:String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.login.rawValue
            let params = ["username":loginUserName,"password":loginPassword] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["usrtoken":userLoginToken]) { (response, message, status) in
                print(response ?? "Error")
                let result = WebServices()
                if let data = response as? NSDictionary {
                    result.apiResponseData = data
                    completion(result, "Success", true)
                } else {
                    completion("" as AnyObject?, "Failed", false)
                }
            }
        } else {
            ErrorReporting.showMessage(title: "No Internet", msg: "Please check your internet connection.")
            completion("" as AnyObject?, "No Net", false)
        }
    }
    
    // MARK :- Profile Image Update
    class func profileImageUpdate(imageName: UIImage,fileExtension: String,mimeType:String, completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.profileImageUpdate.rawValue
            let params = ["":""]
            WebServices.postWebServiceWithImage(urlString: url, params: params as [String : AnyObject], urlToken: userLoginToken, imageToUploadURL: imageName,fileType: fileExtension,mimeName: mimeType) { (response, message, status) in
                print(response ?? "Error")
                let result = WebServices()
                if let data = response as? NSDictionary {
                    print(data)
                    result.apiResponseData = data
                    completion(result, "Success", true)
                }else {
                    completion("" as AnyObject?, "Failed", false)
                }
            }
        } else {
            ErrorReporting.showMessage(title: "No Internet", msg: "Please check your internet connection.")
            completion("" as AnyObject?, "No Net", false)
        }
    }
    
    //MARK :- PostWithHeader
    class func postWebServiceWithHeader(urlString: String, params: [String : AnyObject], urlToken: [String : String], completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void) {
        alamofireFunctionWithHeader(urlString: urlString, method: .post, parameters: params, token: urlToken) { (response, message, success) in
            if response != nil {
                completion(response as AnyObject?, "", true)
            } else {
                completion(nil, "", false)
            }
        }
    }
    
    class func alamofireFunctionWithHeader(urlString : String, method : Alamofire.HTTPMethod, parameters : [String : AnyObject], token: [String : String], completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void) {
        if method == Alamofire.HTTPMethod.post {
            Alamofire.request(urlString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: token).responseJSON { (response:DataResponse<Any>) in
                print(urlString)
                if let response = response.response?.statusCode {
                    responseStatus = response
                    print("Response Status : \(responseStatus!)")
                }
                if response.result.isSuccess {
                    completion(response.result.value as AnyObject?, "", true)
                } else {
                    completion(nil, "", false)
                }
            }
        } else {
            Alamofire.request(urlString).responseJSON { (response) in
                if response.result.isSuccess{
                    completion(response.result.value as AnyObject?, "", true)
                } else {
                    completion(nil, "", false)
                }
            }
        }
    }
    
    //Image
    class func postWebServiceWithImage(urlString: String, params: [String : AnyObject], urlToken: String, imageToUploadURL: UIImage,fileType:String,mimeName: String, completion : @escaping ( _ response : AnyObject?,  _ message: String?, _ success : Bool)-> Void) {
        let imageData = UIImageJPEGRepresentation(imageToUploadURL, 1.0)
        let URL = try! URLRequest(url: urlString, method: .post, headers: ["usrtoken" : urlToken])
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(imageData!, withName: "attachment", fileName: fileType, mimeType: mimeName)
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
        }, with: URL, encodingCompletion: { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response.request!)  // original URL request
                    print(response.response!) // URL response
                    print(response.data!)     // server data
                    print(response.result)   // result of response serialization
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                        completion(response.result.value as AnyObject?, "", true)
                    }
                }
            case .failure(let encodingError):
                print(encodingError)
                completion(nil, "", false)
            }
        })
    }
    
    //Mark:-Cancel
    class func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    //example checkin in (alamofireFunction)
    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
}

extension WebServices {
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

class ErrorReporting {
    static func showMessage(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        WebServices.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
