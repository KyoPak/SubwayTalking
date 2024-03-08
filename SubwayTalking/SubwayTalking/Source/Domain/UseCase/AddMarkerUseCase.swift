//
//  AddMarkerUseCase.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import RxSwift

protocol AddMarkerUseCase {
    func fetchMarkerData() -> Observable<[SubwayInformation]>
}

final class DefaultAddMarkerUseCase: AddMarkerUseCase {
    
    private let markerDataRepository: MarkerDataRepository
    
    init(markerDataRepository: MarkerDataRepository) {
        self.markerDataRepository = markerDataRepository
    }
    
    func fetchMarkerData() -> Observable<[SubwayInformation]> {
        return markerDataRepository.fetchData()
    }
}
