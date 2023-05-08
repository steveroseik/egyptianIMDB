//
//  ActorsCell.swift
//  imdbProj
//
//  Created by Steve Roseik on 1/5/21.
//

import UIKit

class ActorsCell: UICollectionViewCell {
    
    @IBOutlet weak var aCellPhoto: UIImageView?
    @IBOutlet weak var aCellLabel: UILabel?
    
    
    @IBOutlet weak var CastCellPhoto: UIImageView?
    @IBOutlet weak var CastCellLabel: UILabel?
    
    var data: bCell? {
        
        didSet {
            guard let data = data else { return }
            let t = data.name
            aCellLabel?.text = t
            aCellPhoto?.downloaded(from: data.img)
            
            CastCellLabel?.text = t
            CastCellPhoto?.downloaded(from: data.img)
        }
    }
}
