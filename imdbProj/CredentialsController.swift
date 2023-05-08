//
//  CredentialsController.swift
//  imdbProj
//
//  Created by Steve Roseik on 8/5/21.
//

import UIKit

var loginResp = 3



class CredentialsController: UIViewController {

   
    func verifyLogin(user: String, pass: String){
        let parameters = ["username": user,
                          "password": pass]
        
        guard let url = URL(string: "http://localhost:3000/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    guard let resp = json as? Dictionary<String, Any> else {return}

                    loginResp = resp["response"] as? Int ?? -2
                    
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
      
    }
    
    
    
    
   
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var ErrorMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ErrorMessage.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            if (UserDefaults.standard.getUser() == ""){
                UserDefaults.standard.setGuest()
            }
        }
    }
    
    @IBAction func gotoSignup(_ sender: Any) {
        
        performSegue(withIdentifier: "logintosignup", sender: self)
    }
    
    @IBAction func contGuest(_ sender: Any) {
        UserDefaults.standard.setGuest()
        navigationController?.popViewController(animated: true)  
    }
    @IBAction func loginButton(_ sender: Any) {
        ErrorMessage.isHidden = true
        if (userText.text != "") && (passText.text != ""){
            
            verifyLogin(user: userText.text!, pass: passText.text!)
            var gotResp = false
            while (!gotResp){
                if (loginResp == 3){
                    gotResp = false
                }else{
                    if (loginResp == 1){
                        
                        UserDefaults.standard.login(user: userText.text!, pass: passText.text!)
                        navigationController?.popViewController(animated: true)
                  
                    }else if (loginResp == 0){
                        
                        ErrorMessage.text = "Incorrect credentials!"
                        ErrorMessage.isHidden = false
                    }else if (loginResp == -1){
                        ErrorMessage.text = "Username not found!"
                        ErrorMessage.isHidden = false
                     
                    }else{
                        //error code -2:  response fetch failed
                        //default code 3: should not happen
                        
                    }
                    
                    loginResp = 3
                    gotResp = true
                }
               
            }
            

        }
    }
    

}
