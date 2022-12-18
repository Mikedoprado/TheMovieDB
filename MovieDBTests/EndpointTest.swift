//
//  EndpointTest.swift
//  MovieDBTests
//
//  Created by Michael Conchado on 18/12/22.
//

import XCTest
@testable import MovieDB

final class EndpointTest: XCTestCase {

    func test_init_TVShowFeedEndpoint_URLCreationWithRandomValues() {

        for category in TVShowsFeed.allCases {
            expect(sut: category, existPage: true)
        }

    }
    
    func test_init_InfoByIdTvShowDetailsEndpoint_URLCreationWithRandomValues() {
        let sut = InfoById.tvShowDetails(Int.random(in: 1000..<1415))
        
        expect(sut: sut, existPage: false)

    }
    
    func test_init_InfoByIdTVShowCastEndpoint_URLCreationWithRandomValues() {
        let sut = InfoById.tvShowCast(Int.random(in: 1000..<1415))
        
        expect(sut: sut, existPage: false)

    }
    
    // MARK: Helper
    
    func expect(sut: Endpoint, existPage: Bool, file: StaticString = #file, line: UInt = #line) {
        let page = Int.random(in: 0..<10)
        let expectedURLString = expectedURLString(path: sut.path, existPage: existPage, page: page)
        let urlComponents = sut.getUrlComponents(queryItems: nil, page: existPage ? page : nil)
        let request = sut.request(urlComponents: urlComponents)
        
        XCTAssertEqual(request.url?.absoluteString, expectedURLString, file: file, line: line)
    }
    
    func expectedURLString(path: String, existPage: Bool, page: Int = 1) -> String {
        let page = existPage ? "&page=\(page)" : ""
        return "https://api.themoviedb.org\(String(describing: path))?api_key=f6cd5c1a9e6c6b965fdcab0fa6ddd38a&language=en-US\(page)"
    }

}
