//
//  DefaultMarkerDataRepository.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/8/24.
//

import UIKit

import RxSwift

final class DefaultMarkerDataRepository: MarkerDataRepository {
    func fetchData() -> Single<[SubwayInformation]> {
        return Single<[SubwayInformation]>.create { single in
            do {
                let subwayInformations = try self.decodeSubwayData()
                single(.success(subwayInformations))
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
    
    private func decodeSubwayData() throws -> [SubwayInformation] {
        guard let subwayData = NSDataAsset.init(name: "SubwayInformation") else { throw JSONDataError.dataSetError }
        guard let datas = try? JSONDecoder().decode([SubwayInformationDTO].self, from: subwayData.data) else {
            throw JSONDataError.decodingError
        }
        
        let subwayInformations = datas.map { $0.toEntity() }
        
        return subwayInformations
    }
}
