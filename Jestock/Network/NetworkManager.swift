//
//  NetworkManage.swift
//  Jestock
//
//  Created by Jeremy Jason on 20/12/20.
//

//import Foundation
//
//struct NetworkManager {
//    
//    static let shared = NetworkManager()
//    
//    func fetch<T: Decodable>(_ object: T.Type, from endpoint: String, completion: @escaping (Result<T,Error>) -> Void ) {
//        
//        if let urlString = endpoint.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString) {
//            
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    completion(.failure(error))
//                } else {
//                    if let data = data {
//                        self.decode(object, data: data, completion: completion)
//                    }
//                }
//            }.resume()
//            
//        }
//        
//    }
//    
//    private func decode<T: Decodable>(_ object: T.Type, data: Data, completion: @escaping(Result<T,Error>) -> Void) {
//        let jsonDecoder = JSONDecoder()
//        do {
//            let decoded = try jsonDecoder.decode(object, from: data)
//            completion(.success(decoded))
//        } catch let error as NSError {
//            completion(.failure(error))
//        }
//    }
//    
//    
//}
