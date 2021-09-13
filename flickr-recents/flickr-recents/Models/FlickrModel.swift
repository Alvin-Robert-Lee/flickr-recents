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
    
    func loadFirstPage(onSuccess: @escaping () -> ()) {
        self.currentPage = 1
        self.lastPage = 1
        getPhotos(at: 1, append: false, onSuccess: onSuccess)
    }
    
    func loadNextPage(onSuccess: @escaping () -> ()) {
        if currentPage < lastPage {
            currentPage += 1
            getPhotos(at: currentPage, onSuccess: onSuccess)
        } else {
            print("No more pages to get.")
        }
    }
    
    func getPhotos(at page: Int, append: Bool = true, onSuccess: @escaping () -> ()) {
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
                print("self.photos\(response.photos.photo)")
                onSuccess()
            case .failure(let error):
                print("Error getting photos\(error.rawValue)")
            }
        }
    }
}

