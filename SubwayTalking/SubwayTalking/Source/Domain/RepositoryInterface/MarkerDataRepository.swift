//
//  MarkerDataRepository.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import RxSwift

protocol MarkerDataRepository {
    func fetchData() -> Observable<[SubwayInformation]>
}
