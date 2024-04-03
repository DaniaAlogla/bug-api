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
    
}
