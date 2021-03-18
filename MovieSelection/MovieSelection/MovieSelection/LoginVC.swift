//
//  LoginVC.swift
//  MovieSelection
//
//  Created by 李易潤 on 2021/3/18.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class LoginVC: UIViewController, GIDSignInDelegate {
    

    @IBOutlet weak var googleLogin: GIDSignInButton!
    
    var auth: Auth!
    var gidSignIn: GIDSignIn!
    var loginManager: LoginManager!
    
    override func viewWillAppear(_ animated: Bool) {
        if auth.currentUser != nil {
            performSegue(withIdentifier: "LoginOK", sender: self)
        }
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        gidSignIn = GIDSignIn.sharedInstance()
        loginManager = LoginManager()
        // 設定要跳出登入網頁
        gidSignIn.presentingViewController = self
        gidSignIn.clientID = FirebaseApp.app()?.options.clientID
        gidSignIn.delegate = self

    }

    // 驗證結束時呼叫
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      if let error = error {
        print("Google sign in error: \(error.localizedDescription)")
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        signInFirebase(with: credential)
    }
    
    // 使用Google帳號完成Firebase驗證
    func signInFirebase(with credential: AuthCredential) {
        auth.signIn(with: credential) { (authResult, error) in
            if error == nil {
                print("Firebase logged in, authResult: \(authResult!)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Firebase login failed, error: \(error!)")
            }
        }
    }

    @IBAction func fbLoginButton(_ sender: Any) {
        signInFB()
    }
    func signInFB() {
        loginManager.logIn(permissions: ["public_profile"], from: self) { (result, error) in
            if error == nil {
                if result != nil && !result!.isCancelled {
                    print("facebook logged in, result: \(result!)")
                    self.signInFirebase(token: result!.token)
                }
            }
        }
    }
    
    // 使用FB token完成Firebase驗證
    func signInFirebase(token: AccessToken?) {
        if token != nil {
            let credential = FacebookAuthProvider.credential(withAccessToken: token!.tokenString)
            auth.signIn(with: credential) { (authResult, error) in
                if error == nil {
                    print("Firebase logged in, authResult: \(authResult!)")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Firebase login failed, error: \(error!)")
                }
            }
        }
    }
}
