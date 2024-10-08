//
//  CustomCollectionViewCell.swift
//  Grow
//
//  Created by Kedarnath Pandya on 26/09/24.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    //MARK: - ViewController life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
