//
//  ReviewCell.swift
//  imdbProj
//
//  Created by Steve Roseik on 8/5/21.
//

import UIKit
class ReviewCell: UICollectionViewCell {
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var reviewText: UILabel?
    @IBOutlet weak var frameView: UIImageView!
    @IBOutlet weak var usernameText: UILabel?
    
    var data: reviewContainer? {
        didSet {
//            frameView.image = UIImage(named: "reviewFrame")
            guard let data = data else { return }
            var t = data.username
            if (t != UserDefaults.standard.getUser()){
                editBtn.isHidden = true
            }
            t = t + ":"
            usernameText?.text = t
            let r = "'" + data.review + "'"
            reviewText?.text = r
            
        }
    }
}
