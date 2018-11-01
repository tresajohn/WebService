//
//  WebServices.swift
//  Virob
//
//  Created by Thomas Chacko on 16/07/18.
//  Copyright © 2018 Thomas Chacko. All rights reserved.
//

import Foundation
import Alamofire

class WebServices: NSObject {    
    enum WebServiceNames: String {
        case baseUrl = "https://virob.com/new_staging/"
        case login = "api/v1/user/login"
        case forgotPassword = "api/v1/user/forgot-pwd"
        case signup = "api/v1/user/signup"
        case countryList = "api/v1/user/countries"
        case setLocation = "api/v1/user/set-location"
        case countryUpdate = "api/v1/user/country-update"
        case verifyMobile = "api/v1/user/signup/verify-mobile"
        case verifyOTP = "api/v1/user/signup/confirm"
        case verifyResendOTP = "api/v1/user/signup-code-resend"
        case profileUpdate = "api/v1/user/profile-settings/profile/update"
        case checkLoginStatus = "api/v1/user/check-login-status"
        case dashboard = "api/v1/user/dashboard"
        case changePassword = "api/v1/user/change-pwd"
        case resetPassword = "api/v1/user/reset-pwd"
        case myWalletBalance = "api/v1/user/my-wallet/balance"
        case scanPayStoreSearch = "api/v1/user/pay/store/search"
        case scanPaySetBillAmount = "api/v1/user/pay/set-bill-amount"
        case verifyPin = "api/v1/user/profile-settings/security-pin/verify"
        case getPaymentTypes = "api/v1/user/pay/get-payment-types"
        case getPaymentInformation = "api/v1/user/pay/get-payment-info"
        case savePGResponse = "api/v1/user/payment-gateway-response/" //{payment_type}/datafeed/{response_id}
        case saveSecurityPin = "api/v1/user/profile-settings/security-pin/save"
        case forgotSecurityPin = "api/v1/user/profile-settings/security-pin/forgot"
        case resetSecurityPin = "api/v1/user/profile-settings/security-pin/reset"
        case onlineStorePopular = "api/v1/user/online-stores/popular"
        case onlineStore = "api/v1/user/online-stores"
        case cashBackStoreSearch = "api/v1/user/cashback/store/search"
        case cashBackBillAmount = "api/v1/user/cashback/set-bill-amount"
        case cashBackStoreConfirm = "api/v1/user/cashback/send-otp"
        case cashBackStoreConfirmResend = "api/v1/user/cashback/resend-otp"
        case cashBackStoreVerify = "api/v1/user/cashback/confirm"
        case popularInStore = "api/v1/user/store/search/popular"
        case inStoreList = "api/v1/user/store/search"
        case walletTransactions = "api/v1/user/my-wallet/transactions"
        case profileImageUpdate = "api/v1/user/profile-settings/profile/image-upload"
        case transactionDetail = "api/v1/user/my-wallet/transaction-details"
        case redeemStoreSearch = "api/v1/user/redeem/store/search"
        case redeemSetBillAmount = "api/v1/user/redeem/set-bill-amount"
        case redeemWalletValidate = "api/v1/user/redeem/wallet-validate"
        case myOrders = "api/v1/user/my-orders/"
        case storeDetails = "api/v1/user/store/details"
        case storeLike = "api/v1/user/store/like"
        case toggleAppLock = "api/v1/user/toggle-app-lock"
        case resetUsingEmail = "api/v1/user/profile-settings/security-pin/reset-email"
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
    
    class func setLocation(countryId: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.setLocation.rawValue
            let params = ["country_id":countryId] as [String : Any]
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
    
    class func dashboard(token: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.dashboard.rawValue
            let params = ["":""] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["usrtoken":token]) { (response, message, status) in
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
    
    class func forgotPassword(userName: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.forgotPassword.rawValue
            let params = ["uname":userName] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["":""]) { (response, message, status) in
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
    
    class func resetPassword(token: String,code: String,newPassword: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.resetPassword.rawValue
            let params = ["code":code,"newpwd":newPassword,"conf_newpwd":newPassword] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["token":token]) { (response, message, status) in
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
    
    class func countryList(completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.countryList.rawValue
            let params = ["":""] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["":""]) { (response, message, status) in
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
    
    class func countryUpdate(countryId : Int,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.countryUpdate.rawValue
            let params = ["country_id":countryId] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["":""]) { (response, message, status) in
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
    
    class func signup(fullName: String,email: String,country: Int,mobileNumber: String,password: String,agreeToRecOffers: Bool,referralCode: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.signup.rawValue
            let params = ["full_name":fullName,"email":email,"country":country,"mob_number":mobileNumber,"password":password,"agree_to_rec_offers":agreeToRecOffers,"referral_code":referralCode] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["":""]) { (response, message, status) in
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
    
    class func verifyMobile(regtoken: String,country: Int,mobileNumber: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.verifyMobile.rawValue
            let params = ["country":country,"mob_number":mobileNumber] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["regtoken":regtoken]) { (response, message, status) in
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
    
    class func verifyOTP(regtoken: String,code: Int,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.verifyOTP.rawValue
            let params = ["code":code] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["regtoken":regtoken]) { (response, message, status) in
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
    
    class func verifyResendOTP(regtoken: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.verifyResendOTP.rawValue
            let params = ["":""] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["regtoken":regtoken]) { (response, message, status) in
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
    
    class func profileUpdate(firstName: String, lastName: String, displayName:String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.profileUpdate.rawValue
            let params = ["first_name":firstName,"last_name":lastName,"display_name":displayName] as [String : Any]
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
    
    class func changePassword(currentPassword: String,password: String,confirmPassword: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.changePassword.rawValue
            let params = ["current_password":currentPassword,"password":password,"conf_password":confirmPassword] as [String : Any]
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
    
    class func myWalletBalance(completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.myWalletBalance.rawValue
            let params = ["":""] as [String : Any]
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
    
    class func scanPayStoreSearch(storeCode: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.scanPayStoreSearch.rawValue
            let params = ["store_code":storeCode] as [String : Any]
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
    
    class func scanPaySetBillAmount(amount: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.scanPaySetBillAmount.rawValue
            let params = ["amount":amount] as [String : Any]
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
    
    class func verifyPin(securityPin: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.verifyPin.rawValue
            let params = ["security_pin":securityPin] as [String : Any]
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
    
    class func saveSecurityPin(securityPin: String,confirmPin: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.saveSecurityPin.rawValue
            let params = ["security_pin":securityPin,"confirm_security_pin":confirmPin] as [String : Any]
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
    
    class func forgotSecurityPin(completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.forgotSecurityPin.rawValue
            let params = ["":""] as [String : Any]
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
    
    class func resetSecurityPin(code: String, securityPin: String, confirmPin: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.resetSecurityPin.rawValue
            let params = ["code":code,"security_pin":securityPin,"confirm_security_pin":confirmPin] as [String : Any]
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
    
    class func getPaymentTypes(authType: Int,securityPin: Int,authStatus:Bool, completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.getPaymentTypes.rawValue
            let params : [String:Any]
            if authType == 1 {
                params = ["auth_type":authType,"security_pin":securityPin] as [String : Any]
            } else if authType == 2 {
                params = ["auth_type":authType,"auth_status":authStatus] as [String : Any]
            } else {
                params = [:]
            }
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
    
    class func getPaymentInformation(paymentType: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.getPaymentInformation.rawValue
            let params = ["payment_mode":paymentType] as [String : Any]
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
    
    class func savePGResponse(datafeedUrl: String,reponseString: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = datafeedUrl
            let params = ["response":reponseString] as [String : AnyObject]
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
    
    class func onlineStorePopular(completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.onlineStorePopular.rawValue
            let params = ["":""] as [String : Any]
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
    
    class func onlineStore(categoryName: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.onlineStore.rawValue + "/" + categoryName
            let params = ["":""] as [String : Any]
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

    class func cashBackStoreSearch(storeCode: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.cashBackStoreSearch.rawValue
            let params = ["store_code":storeCode] as [String : Any]
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
    
    class func cashBackBillAmount(amount: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.cashBackBillAmount.rawValue
            let params = ["bill_amount":amount] as [String : Any]
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
    
    class func cashBackStoreConfirm(completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.cashBackStoreConfirm.rawValue
            let params = ["":""] as [String : Any]
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
    
    class func cashBackStoreConfirmResend(completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.cashBackStoreConfirmResend.rawValue
            let params = ["":""] as [String : Any]
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
    
    class func cashBackStoreVerify(code: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.cashBackStoreVerify.rawValue
            let params = ["code":code] as [String : Any]
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
    
    class func popularInStore(completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.popularInStore.rawValue
            let params = ["":""] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["usrtoken":userLoginToken,"lat":latitude!,"lng":longtitude!]) { (response, message, status) in
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
    
    class func inStoreList(category: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.inStoreList.rawValue + "/" + category
            let params = ["":""] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["usrtoken":userLoginToken,"lat":latitude!,"lng":longtitude!]) { (response, message, status) in
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
    
    class func walletTransactions(transactionType: Int,walletType: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.walletTransactions.rawValue
            let params : [String:Any]
            if transactionType == 3 {
                params = ["" : ""] as [String : Any]
            } else {
                params = ["transaction_type" : transactionType,"wallet" : walletType] as [String : Any]
            }
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
    
    class func walletTransactionDetails(transactionId: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.transactionDetail.rawValue + "/" + transactionId
            let params = ["" : ""] as [String : Any]
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
    
    class func myOrders(orderCode: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.myOrders.rawValue + orderCode
            let params = ["" : ""] as [String : Any]
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
    
    class func redeemStoreSearch(storeCode: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.redeemStoreSearch.rawValue
            let params = ["store_code":storeCode] as [String : Any]
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
    
    class func redeemSetBillAmount(amount: String,authType: Int,securityPin: Int,wallet: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.redeemSetBillAmount.rawValue
            let params = ["amount":amount,"auth_type":authType,"security_pin":securityPin,"wallet":wallet] as [String : Any]
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
    
    class func redeemWalletValidate(amount: String,oPaymentType: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.redeemWalletValidate.rawValue
            let params = ["amount":amount,"opayment_type":oPaymentType] as [String : Any]
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
    
    class func storeDetails(storeCode: String,completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.storeDetails.rawValue
            let params = ["store_code":storeCode] as [String : Any]
            WebServices.postWebServiceWithHeader(urlString: url, params: params as [String : AnyObject], urlToken: ["usrtoken":userLoginToken,"lat":latitude!,"lng":longtitude!]) { (response, message, status) in
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
    
    class func storeLike(storeCode: String, isThisDislike:Int, completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.storeLike.rawValue + "/" + storeCode
            let params = ["status":isThisDislike] as [String : Any]
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
    
    class func toggleAppLock(toggleAppLockStatus: Bool, completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.toggleAppLock.rawValue
            let params = ["toggle_app_lock":toggleAppLockStatus] as [String : Any]
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
    
    class func resetUsingEmail(completion : @escaping (_ response : AnyObject?, _ message: String?, _ success : Bool)-> ()) {
        if Connectivity.isConnectedToInternet() {
            let url = WebServiceNames.baseUrl.rawValue + WebServiceNames.resetUsingEmail.rawValue
            let params = ["":""] as [String : Any]
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
