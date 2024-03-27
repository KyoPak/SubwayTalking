//
//  AddMarkerUseCase.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import RxSwift

protocol AddMarkerUseCase {
    func fetchMarkerData() -> Single<[SubwayInformation]>
}

final class DefaultAddMarkerUseCase: AddMarkerUseCase {
    private let markerDataRepository: MarkerDataRepository
    
    init(markerDataRepository: MarkerDataRepository) {
        self.markerDataRepository = markerDataRepository
    }
    
    func fetchMarkerData() -> Single<[SubwayInformation]> {
        return markerDataRepository.fetchData()
            .map({ infos in
                return infos.filter { $0.latitude != .zero && $0.longitude != .zero }
            })
    }
}
