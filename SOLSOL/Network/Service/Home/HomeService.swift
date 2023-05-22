//
//  HomeService.swift
//  SOLSOL
//
//  Created by 김민재 on 2023/05/21.
//

import Foundation

protocol HomeServiceProtocol {
    func getAccountsList(queryDTO: AccountsListRequestDTO, completion: @escaping (NetworkResult<BaseResponse<[AccountsListResponseDTO]>>) -> Void)
}


final class HomeService: APIRequestLoader<HomeTarget>, HomeServiceProtocol {
    func getAccountsList(queryDTO: AccountsListRequestDTO, completion: @escaping (NetworkResult<BaseResponse<[AccountsListResponseDTO]>>) -> Void) {

        fetchData(
            target: .getAccountsList(queryDTO),
            responseData: BaseResponse<[AccountsListResponseDTO]>.self, completion: completion)
    }
}

