//
//  PhotoDetailCollectionViewCell.swift
//  flickr-recents
//
//  Created by Alvin Lee on 9/13/21.
//

import UIKit
import SDWebImage

class PhotoDetailCollectionViewCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let title: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .black
        let stackView = UIStackView(arrangedSubviews: [photoImageView, title])
        stackView.spacing = 20.0
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.alignment = .center
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(photo: Photo, screenSize: CGSize) {
        title.text = photo.title.count > 0 ? photo.title : "No Title Provided"
        let url = URL(string: photo.largeImageURL)
        title.widthAnchor.constraint(equalToConstant: screenSize.width * 0.8).isActive = true
        title.heightAnchor.constraint(equalToConstant: screenSize.height * 0.2).isActive = true
        photoImageView.sd_setImage(with: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
