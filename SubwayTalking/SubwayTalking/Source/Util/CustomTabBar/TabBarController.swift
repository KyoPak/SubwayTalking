//
//  TabBarController.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/16/24.
//

import UIKit

import RxSwift
import SnapKit

final class TabBarController: UITabBarController {
    
    // MARK: Property
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Property
    
    private let tabBarView = TabBarStackView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIComponents()
        configureHierachy()
        configureLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func bind() {
        tabBarView.tabBarEvent
            .bind(with: self, onNext: { owner, index in
                owner.selectedIndex = index
            })
            .disposed(by: disposeBag)
    }
}

// MARK: UI Configure
extension TabBarController {
    private func configureUIComponents() {
        tabBar.isHidden = true
    }
    
    private func configureHierachy() {
        view.addSubview(tabBarView)
    }
    
    private func configureLayout() {
        tabBarView.snp.makeConstraints { component in
            component.leading.trailing.equalToSuperview().inset(50)
            component.bottom.equalToSuperview().offset(-50)
            component.height.equalTo(80)
        }
    }
}
