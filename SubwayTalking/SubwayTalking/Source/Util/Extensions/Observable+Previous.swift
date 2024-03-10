//
//  Observable+Previous.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/10/24.
//

import RxSwift

extension ObservableType {
    func withPrevious() -> Observable<(Element?, Element?)> {
        return self.scan((nil, nil)) { (previous, current) in
            return (previous.1, current)
        }
    }
}
