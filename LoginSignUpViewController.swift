//
//  LoginSignUpViewController.swift
//  Virob
//
//  Created by Thomas Chacko on 01/08/18.
//  Copyright © 2018 Thomas Chacko. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class LoginSignUpViewController: UIViewController {
    @IBOutlet weak var segmentView: UIView!
    
    var segmentController = SJSegmentedViewController()
    var controllerArray : [UIViewController] = []
    var segmentIndex = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        segmentController.delegate = self
        let loginController = (self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
        loginController.title = "LOGIN"
        self.controllerArray.append(loginController)
        let signUpController = (self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController)!
        signUpController.title = "SIGN UP"
        self.controllerArray.append(signUpController)
        segmentController.segmentControllers = controllerArray
        segmentController.headerViewHeight = 0
        segmentController.headerViewOffsetHeight = 35.0
        segmentController.segmentTitleColor = UIColor(named: "cs_pink")!
        segmentController.selectedSegmentViewColor = UIColor(named: "cs_pink")!
        segmentController.segmentTitleFont = UIFont(name: "Helvetica", size: 15.0)!
        segmentController.showsVerticalScrollIndicator = false
        segmentController.showsHorizontalScrollIndicator = false
        segmentController.segmentedScrollViewColor = .clear
        self.addChildViewController(segmentController)
        self.segmentView.addSubview(segmentController.view)
        segmentController.view.frame = CGRect(x: 0.0, y: 0.0, width: self.segmentView.frame.width, height: self.view.frame.height+100)
        segmentController.didMove(toParentViewController: self)
        segmentController.selectedSegmentViewHeight = 5.0
        segmentController.segmentShadow = SJShadow.light()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }    

    @IBAction func closeButtonClicked(_ sender: UIButton) {
        let dashboardController = UIStoryboard(name: "Dashboard", bundle: nil).instantiateViewController(withIdentifier: "BaseTabBarViewController") as? BaseTabBarViewController
        self.present(dashboardController!, animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension LoginSignUpViewController: SJSegmentedViewControllerDelegate {
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        if segmentController.segments.count > 0 {
            _ = segmentController.segments[index]
            segmentIndex = index
        }
    }
}
