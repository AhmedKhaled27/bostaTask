//
//  ProfileViewModel.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 17/02/2023.
//

import Foundation
import RxSwift
import RxCocoa


class ProfileViewModel {
    
    private let networkManager = NetworkManager()
    
    private var userModelSubject = PublishSubject<UserModel>()
    var userModelObservable:Observable<UserModel> {
        return userModelSubject
    }
    
    private var userAlbumsModelSubject = PublishSubject<[AlbumModel]>()
    var userAlbumsModelObservable:Observable<[AlbumModel]> {
        return userAlbumsModelSubject
    }
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    func getUsers(){
        loadingBehavior.accept(true)
        networkManager.getUsers { [weak self] result in
            guard let self = self else {return}
            self.loadingBehavior.accept(false)
            
            switch result {
            case .success(let usersArr):
                guard let randomUser = usersArr.randomElement() else {return}
                self.userModelSubject.onNext(randomUser)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserAlbums(userId:String) {
        loadingBehavior.accept(true)
        networkManager.getUserAlbums(userId: userId) { [weak self] result in
            guard let self = self else {return}
            self.loadingBehavior.accept(false)
            
            switch result {
            case .success(let userAlbumsArr):
                self.userAlbumsModelSubject.onNext(userAlbumsArr)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
