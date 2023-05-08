//
//  UserProfileController.swift
//  imdbProj
//
//  Created by Steve Roseik on 8/5/21.
//

import UIKit

var pName = ""
var pEmail = ""
var pDob = ""
var pUsername = ""





class UserProfileController: UIViewController {
    
    func getUserdata(_username: String){
        
       
        let parameters = ["name": _username]
        guard let url = URL(string: "http://localhost:3000/userdata") else { return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
         
                    guard let idk = json as? [Dictionary<String, String>] else {return}
                
                    for data: Dictionary<String, String> in idk{
                        
                        let name = data["name"] ?? ""
                        pName = name
                        var dob = data["dob"] ?? ""
                        print(dob)
                        if let x = dob.range(of: "T"){
                            let y = dob[dob.startIndex..<x.lowerBound]
                            dob = String(y)
                        }else{
                            print("not working")
                        }
                        print(dob)
                        pDob = dob;
                        let email = data["email"] ?? ""
                       
                        
                        pEmail = email
                        print(pEmail)
                        
                    }
                    
                    
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
      
    }

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var realname: UILabel?
    @IBOutlet weak var usernameText: UILabel?
    @IBOutlet weak var emailText: UITextField?
    @IBOutlet weak var dobText: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        pUsername = UserDefaults.standard.getUser()
        getUserdata(_username: pUsername)
        userImg.image = UIImage(named: "logged")
        var fetched = false
        while fetched == false {
            if (pEmail != ""){
                realname?.text = pName
                usernameText?.text = "(" + pUsername + ")"
                emailText?.text = pEmail
                dobText?.text = pDob
                fetched = true
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutBtn(_ sender: Any) {
        
        UserDefaults.standard.logout()
        navigationController?.popViewController(animated: true)  
        
    }

}
