//
//  MapMarkRepository.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import UIKit

import RxSwift

protocol MapMarkRepository {
    func fetchData() -> Observable<[SubwayInformation]>
}

final class DefaultMapMarkRepository: MapMarkRepository {
    
    func fetchData() -> Observable<[SubwayInformation]> {
        return Observable.create { observer in
            do {
                let subwayInformations = try self.decodeSubwayData()
                observer.onNext(subwayInformations)
                observer.onCompleted()
            } catch {
                observer.onError(JSONDataError.decodingError)
            }
            
            return Disposables.create()
        }
    }
    
    private func decodeSubwayData() throws -> [SubwayInformation] {
        guard let subwayData = NSDataAsset.init(name: "SubwayInformation") else { throw JSONDataError.dataSetError }
        
        let datas = try JSONDecoder().decode([SubwayInformationDTO].self, from: subwayData.data)
        let subwayInformations = datas.map { $0.toEntity() }
        
        return subwayInformations
    }
}
