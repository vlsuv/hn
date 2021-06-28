//
//  NetworkService.swift
//  hn
//
//  Created by vlsuv on 15.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire

enum NetworkServiceError: Error {
    case forbidden
    case notFound
    case conflict
    case internalServerError
}

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(_ request: URLRequestConvertible) -> Observable<T>
}

extension NetworkServiceProtocol {
    func fetch<T: Decodable>(_ request: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observable -> Disposable in
            
            let request = AF.request(request).responseDecodable(of: T.self) { (response) in
                switch response.result {
                case .success(let value):
                    observable.onNext(value)
                    observable.onCompleted()
                case .failure(let error):
                    
                    switch response.response?.statusCode {
                    case 403:
                        observable.onError(NetworkServiceError.forbidden)
                    case 404:
                        observable.onError(NetworkServiceError.notFound)
                    case 409:
                        observable.onError(NetworkServiceError.conflict)
                    case 500:
                        observable.onError(NetworkServiceError.internalServerError)
                    default:
                        observable.onError(error)
                    }
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
