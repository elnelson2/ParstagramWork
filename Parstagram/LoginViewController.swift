//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Nelson  on 10/1/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func signinButton(_ sender: Any) {
        let username = userField.text!
        let  password = passwordField.text!
        
        PFUser.logInWithUsername(inBackground: username, password: password) {(user, error) in
            if user != nil{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    @IBAction func signupButton(_ sender: Any) {
        let user = PFUser()
        user.username = userField.text
        user.password = passwordField.text
        
        user.signUpInBackground{ (success ,error) in
            if success{
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
            } else{
                print("Error: \(String(describing: error))")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [235/255,54/255,174/255,0.85]) as Any, CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [255/255,187/255,110/255,1]) as Any]

        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
