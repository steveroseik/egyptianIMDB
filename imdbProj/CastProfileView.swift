//
//  CastProfileView.swift
//  imdbProj
//
//  Created by Steve Roseik on 5/5/21.
//

import UIKit

struct actorDet{
    var name: String
    var img: String
    var dob: String
    var nationality: String
    var bio: String
}

var detCell: actorDet!

class CastProfileView: UIViewController {
    
    @IBOutlet weak var actorName: UILabel?
    @IBOutlet weak var actorImg: UIImageView?
    @IBOutlet weak var actorNationality: UILabel?
    @IBOutlet weak var actorDob: UILabel?
    @IBOutlet weak var actorBio: UILabel?
    @IBOutlet weak var scrollActor: UIScrollView!
    @IBOutlet weak var profileBtn: UIButton?
    var actorPassed = "n/a"
    
    
    func getDetails(){
        detCell = nil
        let parameters = ["name": actorPassed]
        guard let url = URL(string: "http://localhost:3000/castDetails") else { return }
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
              
                    guard let idk = json as? [Dictionary<String, Any>] else {return}
                
                    
                    movieData.removeAll()
                    for data: Dictionary<String, Any> in idk{

                        let xnationality = data["nationality"] ?? ""
                        let xImg = data["img"] ?? ""
                        let xBio = data["bio"] ?? ""
                        let xdate = String(data["dob"] as! String)
                        var ndate: String!
                        if let range = xdate.range(of: "T"){
                            let trunc = xdate[xdate.startIndex..<range.lowerBound]
                            ndate = String(trunc)
                        }else{
                            print("not working")
                        }
                        var nImg = xImg as! String
                        if let range = nImg.range(of: ".jpg"){
                            let trunc = nImg[nImg.startIndex..<range.lowerBound]
                            nImg = trunc + ".jpg"
                        }
                        let tempCell = actorDet(name: self.actorPassed, img: nImg, dob: ndate, nationality: xnationality as! String, bio: xBio as! String)
                        detCell = tempCell
                  
    
                    }
                    
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
       
       
      
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
        var fetched = false
        while fetched == false {
            scrollActor.isScrollEnabled = true
            if (detCell != nil){
                actorName?.text = self.actorPassed
                actorDob?.text = detCell.dob
                actorNationality?.text = detCell.nationality
                actorBio?.text = detCell.bio
                self.actorImg?.downloaded(from: detCell.img)
                
                fetched = true
            }
        }
        
        if (UserDefaults.standard.isLoggedin()){
            if (UserDefaults.standard.isGuest()){
                profileBtn?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            }else{
                profileBtn?.setBackgroundImage(UIImage(named: "loggedIn"), for: UIControl.State.normal)
            }
            
        }else{
            profileBtn?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            performSegue(withIdentifier: "cptologin", sender: self)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
    @IBAction func gotoUser(_ sender: Any) {
        if (UserDefaults.standard.isLoggedin()){
            if (!UserDefaults.standard.isGuest()){
                performSegue(withIdentifier: "cptouser", sender: self)
            }else{
                performSegue(withIdentifier: "cptologin", sender: self)
            }
            
        }else{
            performSegue(withIdentifier: "cptologin", sender: self)
        }
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
