//
//  Constant.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/10/24.
//

import UIKit

enum Constant { 
    enum Text {
        
        // MARK: Alert
        
        static let locationAlertTitle = "현재 위치를 불러올 수 없습니다."
        static let locationAlertMessage = "위치 서비스를 사용하실 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요."
        static let locationAlertConfirmActionTitle = "설정으로 이동"
        static let alertCancelActionTitle = "취소"
        static let converteAddressFail = "위치정보가 없습니다."
    }
    
    enum Image {
        
        // MARK: Asset Image
        
        static let subwayMarker = UIImage(named: "SubwayMarker") ?? UIImage()
        static let userLocationButton = UIImage(named: "UserLocationButton") ?? UIImage()
        static let addressMarker = UIImage(named: "AddressMarker") ?? UIImage()
    }
    
    enum Font {
        static let lineFontBold = "LINESeedSansKR-Bold"
        static let lineFontRegular = "LINESeedSansKR-Regular"
        static let lineFontThin = "LINESeedSansKR-Thin"
    }
    
    enum Color {
        static let overlay = UIColor(red: 0.4, green: 0.5, blue: 0.98, alpha: 0.3)
    }
    
    enum Error {
        
        // MARK: Bundel Error
        
        static let naverMapsPlistOmit = "NaverMaps.plist 파일이 존재하지 않습니다."
        static let naverMapsIdOmit = "NaverMaps에서 발급받은 NMFClientId을 설정하세요."
        static let fileError = "파일 에러가 발생하였습니다."
        
        // MARK: JSON Data Error
        
        static let dataSetError = "데이터 파일이 올바르지 않습니다."
        static let decodingError = "데이터를 불러오는 과정에서 오류가 발생하였습니다."
    }
    
    enum Value {
        static let distance: Double = 500
    }
}
