//
//  ViewController.swift
//  imdbProj
//
//  Created by Steve Roseik on 22/4/21.
//

import UIKit

struct movieListD {
    var movieName: String
    var movieImg: String
}

var movieData = [movieListD(movieName: "temp", movieImg: "temp"),
                 movieListD(movieName: "temp", movieImg: "temp"),
                 movieListD(movieName: "temp", movieImg: "temp"),
                 movieListD(movieName: "temp!", movieImg: "temp"),
                 movieListD(movieName: "temp", movieImg: "temp")
]

var windowOpen = false

// RETRIEVE MOVIE LIST





class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    
    @IBOutlet weak var viewCon1: UICollectionView?
    @IBOutlet weak var textFilter: UITextField?
    @IBOutlet weak var profileButton: UIButton?
    @IBOutlet weak var textSearchBar: UITextField!
    @IBOutlet weak var mCollectionView: UICollectionView?
    
    @IBOutlet weak var movieFilter: UIPickerView?
   
    var isExpanding = false
    var mRetrieved = false
    var lastChosenFilter = "Alphabetic"
    var moviewillpass = String()
    var pickerView = UIPickerView()
    var dataSeen = 5
    let mfilter = ["Alphabetic", "Oldest","Recent","Highest revenue","Lowest revenue", "Top rating", "Lowest rating","Drama", "Musical", "Romance", "Comedy", "Family", "Thriller", "Fantasy", "Crime", "Adventure", "Action", "Mystery", "Horror", "History"]
  
    func getList(filter: String, searchText: String){
        let parameters = ["filter": filter, "text": searchText]
        
        guard let url = URL(string: "http://localhost:3000/movielist") else { return }
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
                    //add action to response
                    guard let idk = json as? [Dictionary<String, Any>] else {return}
                
                    
                    movieData.removeAll()
                    for data: Dictionary<String, Any> in idk{

                        let newmovieName = data["name"] ?? ""
                        let newLink = data["img"] ?? ""
                        movieData.append(movieListD(movieName: newmovieName as! String, movieImg: newLink as! String))
    //
                    }
                    
                    DispatchQueue.global().async {
                        DispatchQueue.main.async {
                            self.mCollectionView?.reloadData()
                            self.isExpanding = false
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
       
      
    }
    
    func addPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        textFilter?.inputView = pickerView
        textFilter?.inputAccessoryView = toolbar
      
    }
    
    @objc func donePressed(){
        textFilter?.resignFirstResponder()
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewCon1?.delegate = self
        viewCon1?.dataSource = self
       //initiate first movie list
        getList(filter: lastChosenFilter, searchText: "")
        mRetrieved = true
        addPickerView()
        
        if (UserDefaults.standard.isLoggedin()){
            if (UserDefaults.standard.isGuest()){
                profileButton?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            }else{
                profileButton?.setBackgroundImage(UIImage(named: "loggedIn"), for: UIControl.State.normal)
            }
            
        }else{
            profileButton?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            performSegue(withIdentifier: "maintologin", sender: self)
        }
        
        
    }
    
    
    @IBAction func gotoUser(_ sender: Any) {
        
        if (UserDefaults.standard.isLoggedin()){
            if (!UserDefaults.standard.isGuest()){
                performSegue(withIdentifier: "maintouser", sender: self)
            }else{
                performSegue(withIdentifier: "maintologin", sender: self)
            }
            
        }else{
            performSegue(withIdentifier: "maintologin", sender: self)
        }
    }
    @IBAction func searchBtn(_ sender: Any) {
        self.isExpanding = true
        if (textSearchBar.text == ""){
            getList(filter: textFilter?.text ?? "", searchText: "")
            lastChosenFilter = textFilter?.text ?? ""
        }else{
            getList(filter: textFilter?.text ?? "", searchText: textSearchBar?.text ?? "")
            lastChosenFilter = textFilter?.text ?? ""
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        mRetrieved = false
        windowOpen = true
        viewDidLoad()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue1" {
            let secondController = segue.destination as! MovieController
            secondController.moviePassed = moviewillpass
            windowOpen = false
        }
        
    }

    
    //COLLECTION VIEW
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        moviewillpass = movieData[indexPath.row].movieName
        print(moviewillpass)
        
        if (moviewillpass != ""){
            performSegue(withIdentifier: "segue1", sender: self)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieData.count == 0 {
            self.mCollectionView?.setEmptyMessage("No movies to show :(")
            return movieData.count
        }else{
            collectionView.restore()
            if dataSeen >= movieData.count{
                return movieData.count
            }else{
                return dataSeen
            }
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        if (windowOpen){
            if (!self.isExpanding){
                
                 cell.data = movieData[indexPath.item]
            }
        }
       
             
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
        if (dataSeen >= movieData.count){
            dataSeen = movieData.count
        }else{
            if (indexPath.row == dataSeen - 1 && !self.isExpanding) {
                self.isExpanding = true
                dataSeen = dataSeen + 5


                DispatchQueue.global().async {
                    sleep(2)
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                        self.isExpanding = false
                    }
                }

             }
        }
    }


}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mfilter.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mfilter[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFilter?.text = mfilter[row]
        textFilter?.resignFirstResponder()
    }
    
}

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "System", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}



