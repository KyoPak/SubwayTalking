//
//  TabBarStackView.swift
//  SubwayTalking
//
//  Created by 박효성 on 3/15/24.
//

import UIKit

import RxSwift

final class TabBarStackView: UIStackView {
    
    // MARK: Property
    
    private let disposeBag = DisposeBag()
    let tabBarEvent = PublishSubject<Int>()
    
    // MARK: UI Property
    
    private let mapItemView = TabBarItemView(item: .map)
    private let chatItemView = TabBarItemView(item: .chat)
    private let settingItemView = TabBarItemView(item: .setting)
    private lazy var customItemViews: [TabBarItemView] = [chatItemView, mapItemView, settingItemView]
    private let movingBackgroundView = UIView()
        
    init() {
        super.init(frame: .zero)
        
        addGestureToView()
        configureUIComponents()
        configureHierachy()
        configureSelectLayout()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectItem(index: mapItemView.index)
    }
}

// MARK: Set TapGesture
extension TabBarStackView {
    private func addGestureToView() {
        [chatItemView, mapItemView, settingItemView].forEach { [weak self] view in
            guard let self = self else { return }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? TabBarItemView else { return }
        selectItem(index: tappedView.index)
    }
    
    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        let selectView = customItemViews[index]
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.movingBackgroundView.center = selectView.center
        }
        
        tabBarEvent.onNext(index)
    }
}

// MARK: UI Configure
extension TabBarStackView {
    private func configureUIComponents() {
        spacing = 5
        alignment = .fill
        backgroundColor = .white
        distribution = .fillEqually
        
        layer.cornerRadius = 20
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor =  UIColor.black.cgColor
        
        movingBackgroundView.layer.cornerRadius = 15
        movingBackgroundView.backgroundColor = Constant.Color.tabBarBack
    }

    private func configureHierachy() {
        addSubview(movingBackgroundView)
        [chatItemView, mapItemView, settingItemView].forEach(addArrangedSubview(_:))
    }
    
    private func configureSelectLayout() {
        movingBackgroundView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(settingItemView.snp.width).multipliedBy(0.8)
            make.height.equalTo(settingItemView.snp.height).multipliedBy(0.8)
        }
    }
}
