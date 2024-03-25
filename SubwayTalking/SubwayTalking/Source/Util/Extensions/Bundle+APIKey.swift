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
            fatalError(Constant.Error.naverMapsPlistOmit)
        }
        
        guard let resource = NSDictionary(contentsOfFile: file) else { fatalError(Constant.Error.fileError) }
        guard let clientID = resource["NMFClientId"] as? String else { fatalError(Constant.Error.naverMapsIdOmit) }
        
        return clientID
    }
    
    var kakaoNativeKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String else {
            fatalError(Constant.Error.kakaoAppKeyOmit)
        }
        
        return apiKey
    }
}
