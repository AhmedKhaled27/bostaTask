//
//  ProfileViewController.swift
//  bostaTask
//
//  Created by Ahmed Khaled on 17/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {
    
    //MARK: - IBOutLets
    @IBOutlet weak var userInfoView: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userAddressLabel: UILabel!
    @IBOutlet weak var userAlbumsTableview: UITableView!
    
    //MARK: - Properties
    let userAlbumsTableViewCell = "UserAlbumsTableViewCell"
    var profileViewModel = ProfileViewModel()
    let disposeBag = DisposeBag()
    
    //MARK: - ViewContollerLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getUsersData()
        subscribeToUserModel()
        subscribeToLoading()
        bindTableViewToViewModel()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    //MARK: - HelperFunctions
    func setupNavigationBar(){
        self.title = "Profile"
        guard let navigationController = self.navigationController else  {return}
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    func setupTableView() {
        userAlbumsTableview.register(UINib(nibName: userAlbumsTableViewCell, bundle: nil), forCellReuseIdentifier: userAlbumsTableViewCell)
    }
    
    func getUsersData(){
        profileViewModel.getUsers()
    }
    
    func subscribeToUserModel(){
        profileViewModel.userModelObservable.subscribe { [weak self] (user) in
            guard let self = self else {return}
            if let user = user.element {
                self.profileViewModel.getUserAlbums(userId: "\(user.id)")
                self.userNameLabel.text = user.name
                self.userAddressLabel.text = "\(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)"
            }
        }.disposed(by: disposeBag)
    }
    
    func subscribeToLoading(){
        profileViewModel.loadingBehavior.subscribe { (isLoading) in
            if(isLoading){
                self.showIndicator()
            }else {
                self.hideIndicator()
            }
        }.disposed(by: disposeBag)
    }
    
    func bindTableViewToViewModel(){
        profileViewModel.userAlbumsModelObservable
            .bind(to: userAlbumsTableview
                .rx
                .items(cellIdentifier: userAlbumsTableViewCell
                       , cellType: UserAlbumsTableViewCell.self)) { (row ,album ,cell) in
                cell.textLabel?.text = album.title
                cell.selectionStyle = .none
            }
                       .disposed(by: disposeBag)
        
        userAlbumsTableview
            .rx
            .modelSelected(AlbumModel.self)
            .bind { (selectedAlbum) in
                let albumDetailsVc = AlbumDetailsViewController()
                albumDetailsVc.title = selectedAlbum.title
                albumDetailsVc.albumId = "\(selectedAlbum.id)"
                self.navigationController?.pushViewController(albumDetailsVc, animated: true)
            }
    }
}
