//
//  Bundle+APIKey.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/6/24.
//

import Foundation

extension Bundle {
    
    var naverMapsClientID: String {
        guard let file = self.path(forResource: "NaverMaps", ofType: "plist") else {
            fatalError("NaverMaps.plist 파일이 존재하지 않습니다.")
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError("파일 에러가 발생하였습니다.") }
        guard let clientID = resource["NMFClientId"] as? String else {
            fatalError("NaverMaps에서 발급받은 NMFClientId을 설정하세요.")
        }
        
        return clientID
    }
}
