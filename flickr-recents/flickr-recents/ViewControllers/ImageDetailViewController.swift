//
//  ImageDetailViewController.swift
//  flickr-recents
//
//  Created by Alvin Lee on 9/13/21.
//

import UIKit
import SDWebImage

protocol GalleryDetailSyncDelegate {
    func set(indexPath: IndexPath)
}

class ImageDetailViewController: UIViewController {

    var collectionView: UICollectionView!
    
    var startingIndex: IndexPath!
    var endingIndex: IndexPath!
    var flickrModel: FlickrModel!
    var buffer = 5
    var delegate: GalleryDetailSyncDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.register(PhotoDetailCollectionViewCell.self, forCellWithReuseIdentifier: detailCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: startingIndex, at: .centeredHorizontally, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.set(indexPath: endingIndex)
    }
}

extension ImageDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellIdentifier, for: indexPath) as! PhotoDetailCollectionViewCell
        let photo = flickrModel.photos[indexPath.row]
        cell.configure(photo: photo, screenSize: collectionView.frame.size)
        if indexPath.row == (flickrModel.photos.count - buffer) {
            flickrModel.loadNextPage { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        endingIndex = indexPath
    }
}
