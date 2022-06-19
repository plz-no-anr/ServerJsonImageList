//
//  QueryModel.swift
//  ServerJson_01
//
//  Created by TJ on 2022/06/19.
//

import Foundation
import UIKit

// 콜백함수
protocol QueryModelProtocol: AnyObject {
    func itemDownLoaded(items: [Movie])
}

struct QueryModel{
    var delegate: QueryModelProtocol!
    let urlPath = "https://zeushahn.github.io/Test/ios/movies.json"
    
    func downloadItems(){
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default) // 세션 생성하여 데이터 통신
        
        let task = defaultSession.dataTask(with: url){ (data, response, error) in
            if error != nil{
                print("Failed to download data")
            } else {
                print("Data is downloaded")
                self.parseJSON(data!)
            }
        }
        
        task.resume()
        
    }
    
    func parseJSON(_ data: Data){
        print("JSON Parsing")
        let str = String(decoding: data, as: UTF8.self)
        print(str)
        
        // JSON파일 변환
        let decoder = JSONDecoder()
        var locations: [Movie] = []
        
        do{
            let movies = try decoder.decode([MovieDTO].self, from: data) // JSON to String
            
            for movie in movies{
                let query = Movie(image: movie.image, title: movie.title)
                locations.append(query)
                
            }
            
        } catch let error{
            print("Fail : \(error.localizedDescription)")
        }
        
        // 비동기 처리
        DispatchQueue.main.async(execute: { () -> Void in
            print("Query Model Async")
            self.delegate.itemDownLoaded(items: locations)
        })
    }
}
