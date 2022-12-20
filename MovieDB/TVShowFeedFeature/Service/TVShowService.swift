//
//  TVShowService.swift
//  MovieDB
//
//  Created by Michael Conchado on 19/12/22.
//

import Foundation
import RxSwift
import Combine
import RxCocoa

final class TVShowService<T: Decodable> {

    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getItems(endpoint: Endpoint, page: Int?) -> Single<T> {
        let urlComponents = endpoint.getUrlComponents(queryItems: nil)
        let request = endpoint.request(urlComponents: urlComponents)
        guard let url = request.url else { return Single.error(ApiError.invalidURL) }

        return Single.create { single in
            let task = self.client.request(from: url) { result in
                switch result {
                case let .success((data, response)):
                    do {
                        let mappedResult = try ItemMapper<T>.map(from: data, from: response)
                        single(.success(mappedResult))
                    } catch {
                        single(.failure(ApiError.jsonConversionFailure))
                    }
                case .failure(_):
                    single(.failure(ApiError.jsonParsingFailure))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
}

extension TVShowService {
    func getItems(endpoint: Endpoint) -> Future<T, ApiError> {
        return Future { [weak self] promise in
            let urlComponents = endpoint.getUrlComponents(queryItems: nil)
            let request = endpoint.request(urlComponents: urlComponents)
            guard let url = request.url else { return promise(.failure(ApiError.invalidURL) ) }
            let task = self?.client.request(from: url) { result in
                switch result {
                case let .success((data, response)):
                    print(data)
                    do {
                        let mappedResult = try ItemMapper<T>.map(from: data, from: response)
                        promise(.success(mappedResult))
                    } catch {
                        promise(.failure(ApiError.jsonConversionFailure))
                    }
                case .failure(_):
                    promise(.failure(ApiError.jsonParsingFailure))
                }
            }
        }
    }
}
