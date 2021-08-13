//
//  MoviesViewModelTests.swift
//  DominicScafatiAPITests
//
//  Created by Dom Scafati on 8/13/21.
//

import XCTest
@testable import DominicScafatiAPI

class MoviesViewModelTests: XCTestCase {

    var viewModel:MoviesViewModel<ServiceMock<MovieResult>>!
    var serviceMock:ServiceMock<MovieResult>!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let viewController = MoviesViewController()
        serviceMock = ServiceMock<MovieResult>()
        viewModel = MoviesViewModel(delegate:viewController, service:serviceMock)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchWhenSearctTextEmptyorNil() {
        // when search text is nil
        viewModel.searchMovies(searchText: nil)
        XCTAssertEqual(viewModel.numberofMovies, 0 , "Movie Result is not nil")
        
        // when search text is Empty
        viewModel.searchMovies(searchText: "")
        XCTAssertEqual(viewModel.numberofMovies, 0 , "Movie Result is not nil")
    }
    
    func testSearchSuccess() {
        
        // when search text not empty Success Scenario
        serviceMock.responseFileName = "movieSuccessResponse"
        viewModel.searchMovies(searchText:"abc")
        XCTAssertEqual(viewModel.numberofMovies, 10 , "Movie Result is nil")
        
        let movie =  viewModel.getMovie(for:0)
        
        XCTAssertNotNil(movie.title)
        XCTAssertNotNil(movie.posterUrl)
        XCTAssertNotNil(movie.year)

        XCTAssertGreaterThan(movie.title.count, 0, "title is empty")
        XCTAssertGreaterThan(movie.year.count, 0, "year is empty")
        XCTAssertGreaterThan(movie.posterUrl.count, 0, "poster url is empty")
        
        let movie1 =  viewModel.getMovie(for:10)
        
        XCTAssertEqual(movie1.title, "" , "Title found for out of index")
        XCTAssertEqual(movie1.year, "" , "Year found for out of index")
        XCTAssertEqual(movie1.posterUrl, "" , "Poster found for out of index")

    }
    
    func testSearchFailure() {
        
        // when search text not empty Success Scenario
        serviceMock.responseFileName = "movieFailureResponse"
        viewModel.searchMovies(searchText:"abc")
        XCTAssertEqual(viewModel.numberofMovies, 0 , "Movie Result not nil")
                
        let movie1 =  viewModel.getMovie(for:0)
        
        XCTAssertEqual(movie1.title, "" , "Title found for out of index")
        XCTAssertEqual(movie1.year, "" , "Year found for out of index")
        XCTAssertEqual(movie1.posterUrl, "" , "Poster found for out of index")

    }
}


class ServiceMock<Model:Decodable>: Servicable, JsonDecodable{
    typealias OUT = Model
    var responseFileName = ""
    func searchMovies(baseUrl: String, path: String, params: String, completionHandler: @escaping CompletonHandler<Model>) {
            // Obtain Reference to Bundle
            let bundle = Bundle(for: type(of: self))

        guard let url = bundle.url(forResource:responseFileName, withExtension:"json"),
            let data = try? Data(contentsOf: url),
                 let output = self.decode(input:data)
               else {
            completionHandler(.failure(NetworkError.dataParsinFailed(message:"Failed to get response")))
             return
           }

        completionHandler(.success(output))
    }
}
