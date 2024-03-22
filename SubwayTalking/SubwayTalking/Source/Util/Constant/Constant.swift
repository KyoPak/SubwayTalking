//
//  Constant.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/10/24.
//

import UIKit

enum Constant {
    enum Text {
        
        // MARK: Log In
        
        static let appName = "SubTalk"
        static let loginComment = "간편하게 로그인하고 \n썹톡에서 다양한 이야기를 나눠보세요."
        static let emphasizeComment = "썹톡에서 다양한 이야기를 나눠보세요."
        static let kakaoSign = "카카오로 시작하기"
        static let naverSign = "네이버로 시작하기"
        static let appleSign = "애플로 시작하기"
        
        // MARK: Alert
        
        static let locationAlertTitle = "현재 위치를 불러올 수 없습니다."
        static let locationAlertMessage = "위치 서비스를 사용하실 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요."
        static let locationAlertConfirmActionTitle = "설정으로 이동"
        
        static let alertErrorTitle = "오류발생"
        static let alertCancelActionTitle = "취소"
        static let converteAddressFail = "위치정보가 없습니다."
        
        // MARK: Title
        
        static let chat = "채팅"
        static let map = "지도"
        static let setting = "설정"
    }
    
    enum Image {
        
        // MARK: Asset Image
        
        static let signLogo = UIImage(named: "SignLogo") ?? UIImage()
        static let subwayMarker = UIImage(named: "SubwayMarker") ?? UIImage()
        static let userLocationButton = UIImage(named: "UserLocationButton") ?? UIImage()
        static let addressMarker = UIImage(named: "AddressMarker") ?? UIImage()
        
        static let kakaoLogo = UIImage(named: "kakao") ?? UIImage()
        static let naverLogo = UIImage(named: "naver") ?? UIImage()
        static let appleLogo = UIImage(named: "apple") ?? UIImage()
        
        // MARK: TabBar Image
        
        static let map = UIImage(systemName: "map") ?? UIImage()
        static let chat = UIImage(systemName: "message") ?? UIImage()
        static let setting = UIImage(systemName: "gearshape") ?? UIImage()
        
        static let mapSelected = UIImage(systemName: "map.fill") ?? UIImage()
        static let chatSelected = UIImage(systemName: "message.fill") ?? UIImage()
        static let settingSelected = UIImage(systemName: "gearshape.fill") ?? UIImage()
    }
    
    enum Color {
        static let overlay = UIColor(red: 75/255, green: 137/255, blue: 220/255, alpha: 0.3)
        static let tabBarBack = UIColor(red: 75/255, green: 137/255, blue: 220/255, alpha: 0.5)
        static let subTalkBlue = UIColor(red: 4/255, green: 120/255, blue: 180/255, alpha: 1)
        static let naverGreen = UIColor(red: 3/255, green: 199/255, blue: 90/255, alpha: 1)
        static let kakaoYellow = UIColor(red: 254/255, green: 229/255, blue: 0/255, alpha: 1)
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
