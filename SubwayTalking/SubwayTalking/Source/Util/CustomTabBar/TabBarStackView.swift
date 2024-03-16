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
    let itemTapped = PublishSubject<Int>()
    
    // MARK: UI Property
    
    private let mapItemView = TabBarItemView(item: .map)
    private let chatItemView = TabBarItemView(item: .chat)
    private let settingItemView = TabBarItemView(item: .setting)
    private lazy var customItemViews: [TabBarItemView] = [chatItemView, mapItemView, settingItemView]
        
    init() {
        super.init(frame: .zero)
        
        configureHierachy()
        configureUIComponents()
        addGestureToView()
        selectItem(index: mapItemView.index)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        tappedView.animateClick { [weak self] in
            self?.selectItem(index: tappedView.index)
        }
    }
    
    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        itemTapped.onNext(index)
    }
}

// MARK: UI Configure
extension TabBarStackView {
    private func configureUIComponents() {
        backgroundColor = .label
        distribution = .fillEqually
        alignment = .center
        layer.cornerRadius = 20
    }

    private func configureHierachy() {
        [chatItemView, mapItemView, settingItemView].forEach(addArrangedSubview(_:))
    }
}
