//
//  File.swift
//  
//
//  Created by Dania Alogla on 25/09/1445 AH.
//

import Foundation

public enum QueryType {
    case store
    case retrieve
    
    public var url: URL {
        switch self {
        case .store:
            return URL(string: "https://api.notion.com/v1/pages")!
        case .retrieve:
            return URL(string: "https://api.notion.com/v1/databases/82b21831560d4631976b0b11e7751bfc/query")!
        }
    }
}
