//
//  PhotoCollectionViewCell.swift
//  flickr-recents
//
//  Created by Alvin Lee on 9/12/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    let photo: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(photo)
        photo.translatesAutoresizingMaskIntoConstraints = false
        photo.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        photo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        photo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        photo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
