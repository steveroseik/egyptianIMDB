//
//  CollectionViewCell.swift
//  imdbProj
//
//  Created by Steve Roseik on 23/4/21.
//

import UIKit

//extension UIImageView {
//
//
//}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var movieT: UILabel?
    @IBOutlet weak var imgView: UIImageView?
   
    
    var data: movieListD? {
        didSet {
            guard let data = data else { return }
            movieT?.allowsDefaultTighteningForTruncation = true
            let t = data.movieName
            movieT?.text = t
            imgView?.downloaded(from: data.movieImg)
        }
    }
    
    
    
    
}
