//
//  View.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/9/24.
//

import Foundation

protocol View: AnyObject {
    associatedtype AssociatedState: State
    
    func update(with state: AssociatedState)
}
