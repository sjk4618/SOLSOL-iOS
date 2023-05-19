//
//  TransferCollectionViewCell.swift
//  SOLSOL
//
//  Created by 변희주 on 2023/05/15.
//

import UIKit

import SnapKit
import Then

protocol TransferButtonAction: AnyObject {
    func transferButtonTapped()
}

final class TransferCollectionViewCell: UICollectionViewCell {
    
    weak var cellDelegate: TransferButtonAction?
    
    private let dummy = TransferList.dummy()

    private let transferBackGround = UIView()
    private let bankImage = UIImageView()
    private let depositWithdraw = UILabel()
    private let bankBook = UILabel()
    private let accountNum = UILabel()
    private let copyButton = UIButton()
    private let moreButton = UIButton()
    
    private let myMoney = UILabel()
    private let won = UILabel()
    private let refreshButton = UIButton()
    private let transferButton = UIButton()
    private let moneyBoxButton = UIButton()
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: flowLayout)
    private let flowLayout = UICollectionViewFlowLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStyle() {
        transferBackGround.do {
            $0.backgroundColor = .white
            $0.makeCornerRound(radius: 13)
        }
        
        depositWithdraw.do {
            $0.text = "입출금"
            $0.textColor = .gray600
            $0.font = .font(.subhead1)
        }
        
        bankBook.do {
            $0.textColor = .grayWarm400
            $0.font = .font(.subhead1)
        }
        
        accountNum.do {
            $0.textColor = .grayWarm400
            $0.font = .font(.body1)
        }
        
        copyButton.do {
            $0.setImage(ImageLiterals.Home.icCopy, for: .normal)
        }
        
        moreButton.do {
            $0.setImage(ImageLiterals.Home.icMore, for: .normal)
        }
        
        myMoney.do {
            $0.textColor = .gray600
            $0.font = .font(.display5)
        }
        
        won.do {
            $0.text = "원"
            $0.textColor = .gray600
            $0.font = .font(.display4)
        }
        
        refreshButton.do {
            $0.setImage(ImageLiterals.Home.icRefresh, for: .normal)
        }
        
        transferButton.do {
            $0.backgroundColor = .blue100
            $0.setTitle("이체", for: .normal)
            $0.setTitleColor(.blue500, for: .normal)
            $0.titleLabel?.font = .font(.subhead2)
            $0.titleLabel?.textAlignment = .center
            $0.makeCornerRound(radius: 6)
            $0.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
        
        moneyBoxButton.do {
            $0.backgroundColor = .blue100
            $0.setTitle("헤이영 머니박스", for: .normal)
            $0.setTitleColor(.blue500, for: .normal)
            $0.titleLabel?.font = .font(.subhead2)
            $0.titleLabel?.textAlignment = .center
            $0.makeCornerRound(radius: 6)
        }
        
        collectionView.do {
            $0.register(TransferListCollectionViewCell.self, forCellWithReuseIdentifier: TransferListCollectionViewCell.className)
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.dataSource = self
            $0.delegate = self
            $0.backgroundColor = .clear
        }
        
        flowLayout.do {
            $0.itemSize = CGSize(width: 81, height: 43)
            $0.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
            $0.minimumLineSpacing = 6
            $0.minimumInteritemSpacing = 0
            $0.scrollDirection = .horizontal
            $0.estimatedItemSize = .zero
        }
    }
    
    func setLayout() {
        
        contentView.addSubviews(transferBackGround)
        transferBackGround.addSubviews(bankImage,
                                       depositWithdraw,
                                       bankBook,
                                       accountNum,
                                       copyButton,
                                       moreButton,
                                       myMoney,
                                       won,
                                       refreshButton,
                                       transferButton,
                                       moneyBoxButton,
                                       collectionView)
        
        transferBackGround.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bankImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(285)
            $0.size.equalTo(36)
        }
        
        depositWithdraw.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalTo(bankImage.snp.trailing).offset(7)
        }
        
        bankBook.snp.makeConstraints {
            $0.centerY.equalTo(depositWithdraw.snp.centerY)
            $0.leading.equalTo(depositWithdraw.snp.trailing).offset(4)
        }
        
        accountNum.snp.makeConstraints {
            $0.top.equalToSuperview().inset(38)
            $0.leading.equalTo(bankImage.snp.trailing).offset(7)
        }
        
        copyButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(37)
            $0.leading.equalTo(accountNum.snp.trailing).offset(2)
            $0.size.equalTo(14)
        }
        
        moreButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(18)
            $0.size.equalTo(24)
        }
        
        myMoney.snp.makeConstraints {
            $0.top.equalToSuperview().inset(83)
            $0.leading.equalToSuperview().inset(18)
        }
        
        won.snp.makeConstraints {
            $0.top.equalToSuperview().inset(84.5)
            $0.leading.equalTo(myMoney.snp.trailing)
        }
        
        refreshButton.snp.makeConstraints {
            $0.leading.equalTo(won.snp.trailing).offset(2)
            $0.centerY.equalTo(myMoney.snp.centerY)
        }
        
        transferButton.snp.makeConstraints {
            $0.top.equalTo(myMoney.snp.bottom).offset(7)
            $0.leading.equalToSuperview().inset(18)
            $0.trailing.equalToSuperview().inset(239)
            $0.height.equalTo(34)

        }
        
        moneyBoxButton.snp.makeConstraints {
            $0.top.equalTo(myMoney.snp.bottom).offset(7)
            $0.leading.equalToSuperview().inset(107)
            $0.trailing.equalToSuperview().inset(117)
            $0.height.equalTo(34)
        }
    
        collectionView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(18)
            $0.height.equalTo(43)
            $0.width.equalToSuperview()
        }
    }
    
    func configureCell(transfer: Transfer) {
        bankImage.image = transfer.image
        bankBook.text = transfer.bankBook
        accountNum.text = transfer.account
        myMoney.text = transfer.money
    }
    
    @objc
    func backButtonTapped() {
        cellDelegate?.transferButtonTapped()
    }
}

extension TransferCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:TransferListCollectionViewCell.className, for: indexPath) as? TransferListCollectionViewCell else { return UICollectionViewCell() }
        cell.configureCell(dummy[indexPath.item])
        return cell
    }
}
