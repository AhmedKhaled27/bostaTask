//
//  AlbumDetailsViewModel.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 19/02/2023.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumDetailsViewModel {
    
    let networkManager = NetworkManager()
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var imagesModelBehavior = BehaviorRelay<[ImageModel]>(value: [])
    var filteredImagesModelBehavior = BehaviorRelay<[ImageModel]>(value: [])

    var searchKey:BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    
    init(){
        subscribeToSearchBarTextAndFilter()
    }
    
    func getAlbumImages(albumId:String){
        loadingBehavior.accept(true)
        networkManager.getAlbumImages(albumId: albumId) { [weak self] (result) in
            guard let self = self else {return}
            self.loadingBehavior.accept(false)
            
            switch result {
            case .success(let images):
                self.imagesModelBehavior.accept(images)
                self.filteredImagesModelBehavior.accept(images)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func subscribeToSearchBarTextAndFilter(){
        searchKey.bind { searchKey in
            let filterdImages = self.imagesModelBehavior.value.filter({ image in
                searchKey.isEmpty ||  image.title.lowercased().contains(searchKey.lowercased())
            })
            self.filteredImagesModelBehavior.accept(filterdImages)
        }
    }
}
