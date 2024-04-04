//
//  File.swift
//  
//
//  Created by Dania Alogla on 25/09/1445 AH.
//

import Foundation

enum QueryType {
    case store
    case retrieve
    
    var url: URL {
        switch self {
        case .store:
            return URL(string: "https://api.notion.com/v1/pages")!
        case .retrieve:
            return URL(string: "https://api.notion.com/v1/databases/82b21831560d4631976b0b11e7751bfc/query")!
        }
    }
}

public final class RemoteBugsManager {
    
    private let integrationToken: String = "secret_mVCSP3XNO9XAgvhyfXmL7bYBsM5qxY2uKK0hC1jAPA5"
    private let databaseID: String = "82b21831560d4631976b0b11e7751bfc"
    
    private init() {}
    
    static public let shared = RemoteBugsManager()
    
    public func storeBug(_ remoteBugItem: (String,URL), completion: @escaping (Error?) -> Void) {
        if let jsonData = createJSONData(description: remoteBugItem.0, imageUrl: remoteBugItem.1.absoluteString) {
            let request = makeRequest(.store, data: jsonData)
            
            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    completion(error)
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(NSError(domain: "YourDomain", code: 0, userInfo: nil))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    completion(nil)
                } else {
                    completion(NSError(domain: "YourDomain", code: httpResponse.statusCode, userInfo: nil))
                }
            }.resume()
            
        } else {
            completion(NSError.init())
        }
    }
    
    public func getNumberOfBugs(completion: @escaping (Int?,Error?) -> Void){
        let request = makeRequest(.retrieve)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching database contents:", error ?? "Unknown error")
                completion(nil, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]] {
                    let rowCount = results.count
                    completion(rowCount,nil)
                } else {
                    print("Error parsing response.")
                    completion(nil,error)
                }
            } catch {
                print("Error parsing response:", error)
                completion(nil, error)
            }
        }.resume()
        
    }
    
    // MARK: - Helpers
    
    private func createJSONData(description: String, imageUrl: String) -> Data? {
        let parentDict: [String: Any] = ["database_id": databaseID]
        
        let textContentDict = ["content": description]
        let textDict = ["text": textContentDict]
        let titleArray = [textDict]
        let descriptionDict = ["title": titleArray]
        
        let imageDict: [String: Any] = ["type": "url", "url": imageUrl]
        
        let propertiesDict: [String: Any] = ["description": descriptionDict, "image": imageDict]
        
        let data: [String: Any] = ["parent": parentDict, "properties": propertiesDict]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return jsonData
        } catch {
            print("Error creating JSON data: \(error)")
            return nil
        }
    }
    
    private func makeRequest(_ query: QueryType, data: Data? = nil) -> URLRequest {
        var request = URLRequest(url: query.url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(integrationToken)", forHTTPHeaderField: "Authorization")
        request.setValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
        if let data = data {
            request.httpBody = data
        }
        return request
    }
}
