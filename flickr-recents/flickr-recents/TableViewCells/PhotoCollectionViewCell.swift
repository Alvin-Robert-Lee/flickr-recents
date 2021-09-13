//
//  PhotoCollectionViewCell.swift
//  flickr-recents
//
//  Created by Alvin Lee on 9/12/21.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(photo: Photo) {
        let thumbImageString = photo.thumbURL
        let url = URL(string: thumbImageString)
        photoImageView.sd_setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
