//
//  SignupController.swift
//  imdbProj
//
//  Created by Steve Roseik on 9/5/21.
//

import UIKit



class SignupController: UIViewController{
    
    //signup request
    func signUp(user: String, name: String, email: String, Gender: String, pass: String, dob: String){
        let parameters = ["username": user,
                          "name": name, "email": email, "gender": Gender, "password": pass, "dob": dob]
        
        guard let url = URL(string: "http://localhost:3000/signup") else { return }
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

                    let signResp = resp["response"] as? Int ?? -2
                    
                    if signResp == 0 {
//                        self.sErrorLabel.text = "couldn't sign up, try again later."
                       // error
                    }
                    
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
      
    }

    @IBOutlet weak var sName: UITextField!
    @IBOutlet weak var sUsername: UITextField!
    @IBOutlet weak var sEmail: UITextField!
    @IBOutlet weak var sPass1: UITextField!
    @IBOutlet weak var sPass2: UITextField!
    @IBOutlet weak var sDob: UITextField!
    @IBOutlet weak var sGender: UITextField!
    @IBOutlet weak var sErrorLabel: UILabel!
    
    let datePicker = UIDatePicker()
    let genderPicker = UIPickerView()
    let gFilter = ["M","F"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDatePicker()
        createGenderPicker()
        sErrorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    func convertDateFormater(_ date: String) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
            let date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return  dateFormatter.string(from: date!)

        }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func createGenderPicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(gPressed))
        toolbar.setItems([doneBtn], animated: true)
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        sGender.inputView = genderPicker
        sGender.inputAccessoryView = toolbar
    }
    
    @objc func gPressed(){
        self.view.endEditing(true)
    }
        
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        datePicker.datePickerMode = .date
        datePicker.sizeToFit()
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        sDob.inputView = datePicker
        sDob.inputAccessoryView = toolbar
    }
    
    @objc func donePressed(){
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none

        
        
//        sDob.text = form
        let dte = "\(datePicker.date)"
        sDob.text = convertDateFormater(dte)
        self.view.endEditing(true)
    }
    
    
    

    
    
    @IBAction func signupBtn(_ sender: Any) {
        if (sName.text == ""){
            sErrorLabel.text = "Please type your name!"
            sErrorLabel.isHidden = false
        }else{
            if (sUsername.text == ""){
                sErrorLabel.text = "Please choose a username!"
                sErrorLabel.isHidden = false
            }else{
                if (isValidEmail(sEmail.text!)){
                    if (sPass1.text != ""){
                        if (sPass2.text == sPass1.text){
                            if (sDob.text == "" ){
                                sErrorLabel.text = "Please choose your birthdate!"
                                sErrorLabel.isHidden = false
                            }else{
                                if (sGender.text == ""){
                                    sErrorLabel.text = "choose your gender!"
                                    sErrorLabel.isHidden = false
                                }else{
                                    signUp(user: sUsername.text!, name: sName.text!, email: sEmail.text!, Gender: sGender.text!, pass: sPass1.text!, dob: sDob.text!)
                                    navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        }else{
                            sErrorLabel.text = "passwords don't match!"
                            sErrorLabel.isHidden = false
                        }
                    }else{
                        sErrorLabel.text = "Please choose a password!"
                        sErrorLabel.isHidden = false
                    }
                }else{
                    sErrorLabel.text = "Invalid email address!"
                    sErrorLabel.isHidden = false
                }
            }
        }
        
        
    }
    
    @IBAction func gotoLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }

}

extension SignupController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gFilter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gFilter[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sGender.text = gFilter[row]
        sGender.resignFirstResponder()
    }
    
}


