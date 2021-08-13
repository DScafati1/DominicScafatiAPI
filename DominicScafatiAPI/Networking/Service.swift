//
//  Service.swift
//  DominicScafatiAPI
//
//  Created by Dom Scafati on 8/13/21.
//

import Foundation
import Reachability

enum NetworkError: Error {
    case malformedURL(message:String)
    case errorWith(response:URLResponse?)
    case dataParsinFailed(message:String)
    case networkNotAvailalbe(message:String)

}

typealias CompletonHandler<OUT:Decodable> =  ((Result<OUT, NetworkError>) -> Void)

protocol Servicable {
    associatedtype OUT: Decodable
    func searchMovies(baseUrl:String, path:String, params:String, completionHandler:@escaping CompletonHandler<OUT>)
}

class Service<Model:Decodable>: Servicable, JsonDecodable  {
    typealias OUT = Model
    private let urlSesson = URLSession(configuration: .default)
    private var dataTask:URLSessionDataTask?
    let reachability = try? Reachability()
    
    func searchMovies(baseUrl: String, path: String, params: String, completionHandler: @escaping CompletonHandler<Model>) {
        dataTask?.cancel()
        // Checking if network is not rechable then return from here
        reachability?.whenUnreachable = { _ in
            completionHandler(.failure(.networkNotAvailalbe(message:"Network not avaible pls check  network connection")))
            return
        }
        // Combining baseUrl, Path, Params using URLComponents
        guard var urlComponents = URLComponents(string:baseUrl + path) else {
            completionHandler(.failure(.malformedURL(message:"URL is not correct")))
            return
        }
        urlComponents.query = "\(params)"
        guard let url = urlComponents.url else {
            completionHandler(.failure(.malformedURL(message:"URL is nil")))
            return
        }
        dataTask =  urlSesson.dataTask(with:url) { (data, responce, error)  in
            guard let data = data , let _responce = responce as? HTTPURLResponse , _responce.statusCode == 200 else {
                completionHandler(.failure(.errorWith(response: responce)))
                return
            }
            // Parsin data using JsonDecoder
            if let result =  self.decode(input: data) {
                completionHandler(.success(result))
            }else {
                completionHandler(.failure(.dataParsinFailed(message:"Result is Empty")))
            }
        }
        dataTask?.resume()
    }
}
