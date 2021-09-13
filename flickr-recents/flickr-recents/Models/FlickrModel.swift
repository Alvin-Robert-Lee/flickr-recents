//
//  FlickrModel.swift
//  flickr-recents
//
//  Created by Alvin Lee on 9/13/21.
//

import Foundation

class FlickrModel {
    
    var currentPage = 1
    var lastPage = 1
    var photos = [Photo]()
    
    func loadFirstPage() {
        self.currentPage = 1
        self.lastPage = 1
        getPhotos(at: 1, append: false)
    }
    
    func loadNextPage() {
        if currentPage < lastPage {
            currentPage += 1
            getPhotos(at: currentPage)
        } else {
            print("No more pages to get.")
        }
    }
    
    func getPhotos(at page: Int, append: Bool = true) {
        NetworkManager.shared.fetchImages(page: page) { [weak self] result in
            switch result {
            case .success(let response):
                self?.currentPage = response.photos.page
                self?.lastPage = response.photos.pages
                if append {
                    self?.photos += response.photos.photo
                } else {
                    self?.photos = response.photos.photo
                }
                NotificationCenter.default.post(name: receivedPhotosNotification, object: nil)
            case .failure(let error):
                print("Error getting photos\(error.rawValue)")
            }
        }
    }
}

