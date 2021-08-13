//
//  GenericJsonDecoder.swift
//  DominicScafatiAPI
//
//  Created by Dom Scafati on 8/13/21.
//

import Foundation

protocol JsonDecodable {
    associatedtype OUT:Decodable
    func decode(input:Data) -> OUT?
}

extension JsonDecodable {
    func decode(input:Data) -> OUT? {
        do {
           return  try JSONDecoder().decode(OUT.self, from: input)
        }catch {
            return nil
        }
    }
}
