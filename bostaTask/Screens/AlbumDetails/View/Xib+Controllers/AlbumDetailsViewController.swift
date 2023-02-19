//
//  AlbumDetailsViewController.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 19/02/2023.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class AlbumDetailsViewController: UIViewController {
    //MARK: - OUTLETS
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imagesCollectionview: UICollectionView!
    
    //MARK: - Properites
    let imagesCollectionViewCell = "ImagesCollectionViewCell"
    var albumDetailsViewModel = AlbumDetailsViewModel()
    let disposeBag = DisposeBag()
    
    var albumId:String = ""
    
    //MARK: - ViewContollerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationController()
        setupCollectionView()
        subscribeToLoading()
        bindCollectionViewToViewModel()
        bindSearchBarToViewModel()
        getAlbumImages()
        hideKeyboardWhenTappedAround()
        
    }
    //MARK: - HelperFunctions
    func setupNavigationController(){
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func setupCollectionView(){
        imagesCollectionview.register(UINib(nibName: imagesCollectionViewCell, bundle: nibBundle), forCellWithReuseIdentifier: imagesCollectionViewCell)
        imagesCollectionview.rx.setDelegate(self)
    }
    
    func subscribeToLoading(){
        albumDetailsViewModel.loadingBehavior.subscribe { (isLoading) in
            if(isLoading){
                self.showIndicator()
            }else {
                self.hideIndicator()
            }
        }.disposed(by: disposeBag)
    }
    
    func getAlbumImages(){
        albumDetailsViewModel.getAlbumImages(albumId: self.albumId)
    }
    
    func bindCollectionViewToViewModel(){
        
        albumDetailsViewModel.filteredImagesModelBehavior
            .bind(to: imagesCollectionview
                .rx
                .items(cellIdentifier: imagesCollectionViewCell,cellType: ImagesCollectionViewCell.self))
        { (row ,image ,cell) in

            guard let imageUrl = URL(string: image.url) else {return}
            cell.imageView.kf.setImage(with: imageUrl)

        }.disposed(by: disposeBag)
    }
    
    func bindSearchBarToViewModel(){
        searchBar.rx.text.orEmpty
//            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { key in
                self.albumDetailsViewModel.searchKey.accept(key)
        }).disposed(by: disposeBag)
    }
    
}

//MARK: - UISearchBarDelegate
extension AlbumDetailsViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension AlbumDetailsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.imagesCollectionview.frame.width/3 - 10
        return CGSize(width: width, height: width)
    }
}
