//
//  ViewController.swift
//  SOLSOL
//
//  Created by 변희주 on 2023/05/13.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    private var adBannerHit: [Advertisement] = [] {
        didSet {
            self.homeTableView.reloadData()
        }
    }
    
    private var accountList: [Transfer] = [] {
        didSet {
            self.homeTableView.reloadData()
        }
    }
    
    private var currentAccountList: [TransferList] = [] {
        didSet {
            self.homeTableView.reloadData()
        }
    }
    
    private let homeTableView = UITableView()
    private lazy var navigationBar = SOLNavigationBar(self, leftItem: .home)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setLayout()
        setDelegate()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        getAdvertisementWithAPI()
        getAccountsListWithAPI()
        getCurrentAccountsListWithAPI()
    }
    
    func setStyle() {
        view.backgroundColor = .white
        homeTableView.do {
            $0.separatorStyle = .none
            $0.backgroundColor = .gray100
            setRegister()
        }
        
    }
    
    func setLayout() {
        view.addSubviews(navigationBar, homeTableView)
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        homeTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func setDelegate() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
    }
    
    func setRegister() {
        homeTableView.register(AdvertisementTableViewCell.self, forCellReuseIdentifier:  AdvertisementTableViewCell.className)
        homeTableView.register(MyAccountTableViewCell.self, forCellReuseIdentifier:  MyAccountTableViewCell.className)
        homeTableView.register(TransferTableViewCell.self, forCellReuseIdentifier:  TransferTableViewCell.className)
        homeTableView.register(ShinhanPlusTableViewCell.self, forCellReuseIdentifier:  ShinhanPlusTableViewCell.className)
        homeTableView.register(DeliveryPackagingTableViewCell.self, forCellReuseIdentifier:  DeliveryPackagingTableViewCell.className)
        homeTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier:  CategoryTableViewCell.className)
        homeTableView.register(FooterButtonTableViewCell.self, forCellReuseIdentifier:  FooterButtonTableViewCell.className)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return adBannerHit.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = Section(rawValue: indexPath.section) else {
            print("Wrong Section !")
            return UITableViewCell()
        }
        switch sectionType {
        case .advertisement:
            let cell = tableView.dequeueReusableCell(withIdentifier: AdvertisementTableViewCell.className, for: indexPath) as! AdvertisementTableViewCell
            let advertisement = adBannerHit[indexPath.row]
            cell.configureCell(advertisement: advertisement)
            return cell
        case .myAccount:
            let cell = tableView.dequeueReusableCell(withIdentifier: MyAccountTableViewCell.className, for: indexPath)
            return cell
        case .transfer:
            let cell = tableView.dequeueReusableCell(withIdentifier:             TransferTableViewCell.className, for: indexPath) as! TransferTableViewCell
            cell.accountList = accountList
            cell.currentAccountList = currentAccountList
            cell.pushDelegate = self
            return cell
        case .shinhanPlus:
            let cell = tableView.dequeueReusableCell(withIdentifier:             ShinhanPlusTableViewCell.className, for: indexPath)
            return cell
        case .deliveryPackaging:
            let cell = tableView.dequeueReusableCell(withIdentifier:             DeliveryPackagingTableViewCell.className, for: indexPath)
            return cell
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier:             CategoryTableViewCell.className, for: indexPath)
            return cell
        case.footerButton:
            let cell = tableView.dequeueReusableCell(withIdentifier:             FooterButtonTableViewCell.className, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 64
        case 1:
            return 63
        case 2:
            return 290
        case 3:
            return 52
        case 4:
            return 100
        case 5:
            return 175
        case 6:
            return 125
        default:
            return 0
        }
    }
}

extension HomeViewController: TransferButtonAction {
    func transferButtonTapped() {
        let nextViewController = TransferViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

// MARK: Network Result

extension HomeViewController {
    
    func getAdvertisementWithAPI() {
        NetworkService.shared.homeService.getADs { result in
            switch result {
            case .success(let data):
                guard let data = data.data else { return }
                
                let advertisementData = Advertisement(title: data[1].title, content: data[1].content)
                self.adBannerHit = [advertisementData]
                
                dump(data)
            default:
                print("network failure")
                return
            }
        }
    }
    
    func getAccountsListWithAPI() {
        let queryDTO = AccountsListRequestDTO(memberId: 1)
        NetworkService.shared.homeService.getAccountsList(queryDTO: queryDTO) {
            result in
            
            switch result {
            case .success(let data):
                guard let data = data.data else { return }
                
                dump(data)
                self.accountList = [Transfer(id: data[0].id, kind: data[0].kind, bank: data[0].bank, name: data[0].name, money: data[0].balance, accountNumber: data[0].accountNumber), Transfer(id: data[1].id, kind: data[1].kind, bank: data[1].bank, name: data[1].name, money: data[1].balance, accountNumber: data[1].accountNumber) ]
                
            default:
                print("network failure")
                return
            }
        }
        
    }
    
    func getCurrentAccountsListWithAPI() {
        let queryDTO = CurrentAccountListRequestDTO(memberId: 2)
        NetworkService.shared.homeService.getCurrentAccoutsList(queryDTO: queryDTO) { result in
            
            switch result {
            case .success(let data):
                guard let data = data.data else { return }
                
                dump(data)
                self.currentAccountList = [TransferList(id: data.transfers[0].id, name: data.transfers[0].name , bank: data.transfers[0].bank), TransferList(id: data.transfers[1].id, name: data.transfers[1].name , bank: data.transfers[1].bank), TransferList(id: data.transfers[2].id, name: data.transfers[2].name , bank: data.transfers[2].bank) ]
                
            default:
                print("network failure")
                return
            }
        }
    }
    
}
