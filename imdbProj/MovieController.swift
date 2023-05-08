//
//  MovieController.swift
//  imdbProj
//
//  Created by Steve Roseik on 27/4/21.
//

import UIKit

struct MovieCollection {
    var name: String
    var rating: Double
    var revenue: String
    var description: String
    var duration: Double
    var releaseD: String
    var img: String
}

struct aCell{
    var name: String
    var role: String
    var img: String
}

struct bCell{
    var name: String
    var img: String
}

struct reviewContainer{
    var username: String
    var review: String
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

var MoviePreviewed: MovieCollection!
var movieFetched = false
var fetcher = false
var directs: String = ""
var writes: String = ""
var Genres = ""
var castlist = [aCell]()

var actList = [bCell(name: "temp", img: "temp"),
                bCell(name: "temp", img: "temp"),
                bCell(name: "temp", img: "temp"),
                bCell(name: "temp!", img: "temp"),
                bCell(name: "temp", img: "temp")
]

var revList = [reviewContainer(username: "none", review: "n/a")]



//image download extension
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class MovieController: ViewController{
    
    @IBOutlet weak var scrooll: UIScrollView!
    @IBOutlet weak var actorsCellView: UICollectionView?
    @IBOutlet weak var movieTitle: UILabel?
    @IBOutlet weak var movieDate: UILabel?
    @IBOutlet weak var movieRating: UILabel?
    @IBOutlet weak var movieDuration: UILabel?
    @IBOutlet weak var movieGenre: UILabel?
    @IBOutlet weak var movieImg: UIImageView?
    @IBOutlet weak var movieDescription: UILabel?
    @IBOutlet weak var movieRevenue: UILabel?
    @IBOutlet weak var movieWriters: UILabel?
    @IBOutlet weak var movieDirectors: UILabel?
    @IBOutlet weak var seeAllCast: UILabel!
    @IBOutlet weak var reviewBox: UITextField?
    @IBOutlet weak var profileBtn: UIButton?
    @IBOutlet weak var reviewCollection: UICollectionView?
    
    var moviePassed  = "nothing passed"
    var actorwillpass = "nothing yet"
    //fetch genre
    func getgenre(movieName: String){
        
        var nGenre = ""
        let parameters = ["name": movieName]
        guard let url = URL(string: "http://localhost:3000/getgenre") else { return}
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
                        if nGenre == ""{
                            nGenre = data["genre"] ?? ""
                        }else{
                            nGenre = nGenre + ", " + (data["genre"] ?? "")
                        }
                        
                    }
                   
                    Genres = nGenre
                    if (data != nil){
                        fetcher = true
                    }
                    
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
        
        
        
       
    }
    
    //fetch reviews
    func getReviews(_movieName: String){
        let parameters = ["moviename": _movieName]
        guard let url = URL(string: "http://localhost:3000/getreviews") else { return}
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
           
                    guard let idk = json as? [Dictionary<String, Any>] else {return}
                
                    for data: Dictionary<String, Any> in idk{

                        let nUsername = data["username"] ?? ""
                        let  nReview = data["review"] ?? ""
                        revList.append(reviewContainer(username: nUsername as! String, review: nReview as! String))
                    }
                   
                
                    DispatchQueue.global().async {
                        DispatchQueue.main.async {
                            self.reviewCollection?.reloadData()
                        }
                    }
                  
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
        
    }
    
    
    func postReview(moviename: String, username: String, review: String){
        let parameters = ["moviename": moviePassed, "username": username, "review": review]
        guard let url = URL(string: "http://localhost:3000/setreview") else { return}
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
              
                    let jsonObject = json as! [String: Any]
                    let resp = jsonObject["response"]
                    
                    if (resp as! Int == 0) {
                        //error
                    }else{
                        revList.removeAll()
                        self.getReviews(_movieName: self.moviePassed)
                    }
                  
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewBox?.textAlignment = .left
        reviewBox?.contentVerticalAlignment = .top
        
        movieTitle?.text = moviePassed
        getMovieData(_movieName: moviePassed)
        getReviews(_movieName: moviePassed)
        getCast(_movieName: moviePassed)
        getgenre(movieName: moviePassed)
        while (!fetcher){
            movieGenre?.text = Genres
        }
        
        actorsCellView?.delegate = self
        actorsCellView?.dataSource = self
        reviewCollection?.delegate = self
        reviewCollection?.dataSource = self
        
        actorsCellView?.backgroundColor = UIColor.systemBackground
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: 190)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 1
        flowLayout.scrollDirection = .horizontal
        actorsCellView?.collectionViewLayout = flowLayout
        
        let reviewLayout = UICollectionViewFlowLayout()
        reviewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        reviewLayout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        reviewLayout.minimumInteritemSpacing = 0
        reviewLayout.minimumLineSpacing = 1
        reviewLayout.scrollDirection = .vertical
        reviewCollection?.collectionViewLayout = reviewLayout
        
        if (UserDefaults.standard.isLoggedin()){
            if (UserDefaults.standard.isGuest()){
                profileBtn?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            }else{
                profileBtn?.setBackgroundImage(UIImage(named: "loggedIn"), for: UIControl.State.normal)
            }
            
        }else{
            profileBtn?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            performSegue(withIdentifier: "movietologin", sender: self)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        castlist.removeAll()
        actList.removeAll()
        revList.removeAll()
        getMovieData(_movieName: moviePassed)
        getCast(_movieName: moviePassed)
        getReviews(_movieName: moviePassed)
        getgenre(movieName: moviePassed)
        fetcher = false
        while (!fetcher){
            movieGenre?.text = Genres
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
        seeAllCast.isUserInteractionEnabled = true
        seeAllCast.addGestureRecognizer(tap)
        
        if (UserDefaults.standard.isLoggedin()){
            if (UserDefaults.standard.isGuest()){
                profileBtn?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            }else{
                profileBtn?.setBackgroundImage(UIImage(named: "loggedIn"), for: UIControl.State.normal)
            }
            
        }else{
            profileBtn?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            performSegue(withIdentifier: "maintologin", sender: self)
        }
        
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "seguecast", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguecast" {
            let secondController = segue.destination as! CastListView
            secondController.castPassed = actList
            secondController.movieNamePassed = moviePassed
            
        }else if segue.identifier == "segueactor1"{
            let secondController = segue.destination as! CastProfileView
            secondController.actorPassed = actorwillpass
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
 
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.reviewCollection{
            if revList.count == 0{
                reviewCollection?.setEmptyMessage("No reviews yet.")
            }else{
               collectionView.restore()
            }
            return revList.count
        }else{
            if actList.count == 0{
                reviewCollection?.setEmptyMessage("No cast retrieved.")
            }else{
                collectionView.restore()
            }
            return actList.count
        }
       
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if collectionView == self.actorsCellView{
            actorwillpass = actList[indexPath.row].name

            if (actorwillpass != ""){
                performSegue(withIdentifier: "segueactor1", sender: self)
            }
        }
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if (collectionView == self.reviewCollection){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCell
           
            cell.data = revList[indexPath.item]
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell2", for: indexPath) as! ActorsCell
           
            cell.data = actList[indexPath.item]
            return cell
        }
       

 
    }
    @IBAction func PostReviewBtn(_ sender: Any) {
        
        if (UserDefaults.standard.isLoggedin()){
            if (!UserDefaults.standard.isGuest()){
                let usr = UserDefaults.standard.getUser()
                let comment = reviewBox?.text
                
                postReview(moviename: moviePassed, username: usr, review: comment!)
            }else{
                performSegue(withIdentifier: "reviewtologin", sender: self)
            }
        }else{
            performSegue(withIdentifier: "reviewtologin", sender: self)
        }
        
    }
    
    @IBAction func gotoUserProfile(_ sender: Any) {
        
        if (UserDefaults.standard.isLoggedin()){
            if (!UserDefaults.standard.isGuest()){
                performSegue(withIdentifier: "movietouser", sender: self)
            }else{
                performSegue(withIdentifier: "reviewtologin", sender: self)
            }
            
        }else{
            performSegue(withIdentifier: "reviewtologin", sender: self)
        }
    }
    
    //fetch movie data from WEB API
    func getMovieData(_movieName: String){
        let parameters = ["name": _movieName]
    //    var Collection: MovieCollection!
        guard let url = URL(string: "http://localhost:3000/moviedata") else { return}
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
                    //add action to response
                    guard let idk = json as? [Dictionary<String, Any>] else {return}
                
                    //log
                   
                
                    for data: Dictionary<String, Any> in idk{

                        let nImg = data["img"] ?? ""
                        let  nrating = data["rating"] as? Double ?? 0.0
                        let nrevenue = data["revenue"] ?? ""
                        let ndescription = data["description"] ?? ""
                        let nduration = data["duration"] as? Double ?? 0.0
                        
                        let rdate = String(data["release_date"] as! String)
                        var ndate: String!
                        if let range = rdate.range(of: "T"){
                            let phone = rdate[rdate.startIndex..<range.lowerBound]
                            ndate = String(phone)
                        }else{
                            ndate = rdate
                        }
                        
                        MoviePreviewed = MovieCollection(name: _movieName , rating: nrating, revenue: nrevenue as! String, description: ndescription as! String, duration: nduration , releaseD: ndate, img: nImg as! String)
                    }
                    
                    movieFetched = true
                   
                  
                } catch {
                    print(error)
                }
            }
            
        }.resume()
        
        
        
        
        if (MoviePreviewed != nil){
            movieDate?.text = MoviePreviewed.releaseD
            movieRating?.text = String(MoviePreviewed.rating) + "/10"
            movieDuration?.text = String(Int(MoviePreviewed.duration)) + " minutes"
            movieDescription?.text = MoviePreviewed.description
            movieRevenue?.text = Int(MoviePreviewed.revenue)?.withCommas()
            movieImg?.downloaded(from: MoviePreviewed.img)
            
        }
    }
    
    func getCast(_movieName: String){
        
       
        let parameters = ["name": _movieName]
        guard let url = URL(string: "http://localhost:3000/moviecast") else { return}
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
                    //add action to response
                    guard let idk = json as? [Dictionary<String, String>] else {return}
                
                    for data: Dictionary<String, String> in idk{
                        var img = data["img"] ?? ""
                        if let x = img.range(of: ".jpg"){
                            let y = img[img.startIndex..<x.lowerBound]
                            img = String(y) + ".jpg"
                        }else{
                            img = "unavailable"
                        }

                        var role = data["role"] ?? ""
                        
                        if let x = role.range(of: "\r"){
                            let y = role[role.startIndex..<x.lowerBound]
                            role = String(y)
                        }else{
                            print("not working")
                        }
 
                        let personname = data["personname"] ?? ""

                        castlist.append(aCell(name: personname , role: role , img: img ))
                       
                    }
                    
                   
                  
                } catch {
                    print(error)
                }
            }
            
            actList.removeAll()
            self.sortCast()
            
        }.resume()
        
      
    }
    
    func sortCast(){
        var dir = 0
        var wir = 0
        for person in castlist{
            if person.role.contains("director"){
                if (dir == 0){
                    directs = person.name
                }else{
                    directs = directs + ", " + person.name
                }
                dir += 1
            }else if person.role.contains("writer"){
                if (wir == 0){
                    writes = person.name
                }else{
                    writes = writes + ", " + person.name
                    
                }
                wir += 1
            }else{
                actList.append(bCell(name: person.name, img: person.img))
            }
        }
       
        DispatchQueue.global().async {
           DispatchQueue.main.async {
            self.movieWriters?.text = writes
            self.movieDirectors?.text = directs
            self.actorsCellView?.reloadData()
           }
        }
    }
    
    
    //END OF CLASS MovieCollection
}
