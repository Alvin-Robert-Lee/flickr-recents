//
//  ImageGalleryViewController.swift
//  flickr-recents
//
//  Created by Alvin Lee on 9/12/21.
//

import UIKit
import SDWebImage

class ImageGalleryViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let flickrModel = FlickrModel()
    let buffer = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Gallery"
        self.navigationItem.backButtonTitle = "Gallery"
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: galleryCellIdentifier)
        collectionView.backgroundColor = .white
        flickrModel.loadFirstPage { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ImageGalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: galleryCellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let photo = flickrModel.photos[indexPath.row]
        cell.configure(photo: photo)
        if indexPath.row == (flickrModel.photos.count - buffer) {
            flickrModel.loadNextPage { [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.width
        let orientation = UIDevice.current.orientation
        if(orientation == .landscapeLeft || orientation == .landscapeRight) {
            return CGSize(width: width/5, height: height/2)
        }
        return CGSize(width: width/3, height: height/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = ImageDetailViewController()
        detailVC.flickrModel = self.flickrModel
        detailVC.startingIndex = indexPath
        detailVC.delegate = self
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ImageGalleryViewController: GalleryDetailSyncDelegate {
    func set(indexPath: IndexPath) {
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
}
