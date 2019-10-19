//
//  NetworkManager.swift
//  Bnet_task
//
//  Created by Tianid on 18.10.2019.
//  Copyright © 2019 Tianid. All rights reserved.
//

import Foundation


class NetworkManager {
    
    var session:String?
    var allEntries: [Entry]?
    
    static let shared: NetworkManager = NetworkManager()
    
    func getNewSession(complitionHandler: @escaping ((String?) -> ())) {
        var urlRequest = getRequest()
        let paramString = "a=new_session"
        urlRequest.httpBody = paramString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(NewSessionResponse.self, from: data)
                self?.session = json.data.session
                complitionHandler(self?.session)

            } catch {
                print(error)
            }
 
        }.resume()
    }
    
    
    func getRequest() -> URLRequest {
        let component = URLComponents(string: myAPI)
        let url = component?.url
        var urlRequest = URLRequest(url: url!)
        urlRequest.setValue("\(token)", forHTTPHeaderField: "token")
        urlRequest.httpMethod = "POST"
        return urlRequest
    }
    
    
    func addEntry(text: String) {
        let component = URLComponents(string: myAPI)

        
        let url = component?.url
        var urlRequest = URLRequest(url: url!)
        urlRequest.setValue("\(token)", forHTTPHeaderField: "token")
        urlRequest.httpMethod = "POST"
        let paramString = "a=add_entry&session=\(String(describing: NetworkManager.shared.session!))&body=\(text)"
        urlRequest.httpBody = paramString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: urlRequest) {(data, response, error) in
            }.resume()
    }
    
    func getEntries(complitionHandler: @escaping ((Bool, Error?) -> ())){
        let component = URLComponents(string: myAPI)
        let url = component?.url
        var urlRequest = URLRequest(url: url!)
        urlRequest.setValue("\(token)", forHTTPHeaderField: "token")
        urlRequest.httpMethod = "POST"
        
        let paramString = "a=get_entries&session=\(String(describing: NetworkManager.shared.session!))"
        urlRequest.httpBody = paramString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONDecoder().decode(Entries.self, from: data)
                self?.allEntries = json.data[0]
                complitionHandler(true,nil)
            } catch {
                complitionHandler(false,error)
            }
            
        }.resume()
    }
    
    
    func addLocalAntry(entry: Entry) {
        self.allEntries?.append(entry)
    }
}


