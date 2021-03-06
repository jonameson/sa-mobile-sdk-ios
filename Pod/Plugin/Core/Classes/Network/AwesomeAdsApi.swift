//
//  AwesomeAdsApi.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/04/2020.
//

enum AwesomeAdsApi {
    case ad(placementId: Int, query: AdQuery)
    case impression(query: EventQuery)
    case click(query: EventQuery)
    case videoClick(query: EventQuery)
    case event(query: EventQuery)
    
    var path: String {
        switch self {
        case .ad(let placementId, _): return "/ad/\(placementId)"
        case .impression: return "/impression"
        case .click: return "/click"
        case .videoClick: return "/video/click"
        case .event: return "/event"
        }
    }
}
