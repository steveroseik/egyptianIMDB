//
//  CastListView.swift
//  imdbProj
//
//  Created by Steve Roseik on 4/5/21.
//

import UIKit


var actorwillpass = ""
class CastListView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var castCollection: UICollectionView?
    @IBOutlet weak var profileBtn: UIButton?
    var castPassed = [bCell]()
    var movieNamePassed = "n/a"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return castPassed.count
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastViewCell", for: indexPath) as! ActorsCell
       
        cell.data = castPassed[indexPath.item]

          return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueactor2"{
            let secondController = segue.destination as! CastProfileView
            secondController.actorPassed = actorwillpass
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        
        actorwillpass = castPassed[indexPath.row].name
//
        if (actorwillpass != ""){
            performSegue(withIdentifier: "segueactor2", sender: self)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieName.text = movieNamePassed
        castCollection?.delegate = self
        castCollection?.dataSource = self
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/3, height: 200)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 1
        flowLayout.scrollDirection = .vertical
        castCollection?.collectionViewLayout = flowLayout
        
        if (UserDefaults.standard.isLoggedin()){
            if (UserDefaults.standard.isGuest()){
                profileBtn?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            }else{
                profileBtn?.setBackgroundImage(UIImage(named: "loggedIn"), for: UIControl.State.normal)
            }
            
        }else{
            profileBtn?.setBackgroundImage(UIImage(named: "loggedOut"), for: UIControl.State.normal)
            performSegue(withIdentifier: "listtologin", sender: self)
        }
        
    }
    
    
    @IBAction func gotoUser(_ sender: Any) {
        
        if (UserDefaults.standard.isLoggedin()){
            if (!UserDefaults.standard.isGuest()){
                performSegue(withIdentifier: "listtouser", sender: self)
            }else{
                performSegue(withIdentifier: "listtologin", sender: self)
            }
            
        }else{
            performSegue(withIdentifier: "listtologin", sender: self)
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
