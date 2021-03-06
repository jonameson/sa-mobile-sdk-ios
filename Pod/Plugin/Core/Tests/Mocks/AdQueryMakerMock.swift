//
//  AdQueryMakerMock.swift
//  Tests
//
//  Created by Gunhan Sancar on 22/04/2020.
//

@testable import SuperAwesome

class AdQueryMakerMock: AdQueryMakerType {
    
    static let mockQuery = AdQuery(test: true, sdkVersion: "", rnd: 1, bundle: "", name: "", dauid: 1,
                                   ct: .wifi, lang: "", device: "", pos: 1, skip: 1, playbackmethod: 1,
                                   startdelay: 1, instl: 1, w: 1, h: 1   )
    
    var mockAdQuery: AdQuery = AdQueryMakerMock.mockQuery
    var isMakeCalled: Bool = false
    
    func makeAdQuery(_ request: AdRequest) -> AdQuery {
        isMakeCalled = true
        return makeAdQueryInstance()
    }
    
    func makeImpressionQuery(_ request: EventRequest) -> EventQuery {
        isMakeCalled = true
        return makeEventQueryInstance()
    }
    
    func makeClickQuery(_ request: EventRequest) -> EventQuery {
        isMakeCalled = true
        return makeEventQueryInstance()
    }
    
    func makeVideoClickQuery(_ request: EventRequest) -> EventQuery {
        isMakeCalled = true
        return makeEventQueryInstance()
    }
    
    func makeEventQuery(_ request: EventRequest) -> EventQuery {
        isMakeCalled = true
        return makeEventQueryInstance()
    }
}
