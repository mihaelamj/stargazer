//
//  CircleInitialLabel.swift
//  Stargazer
//
//  Created by Mihaela MJ on 15/07/2019.
//  Copyright © 2019 Mihaela MJ. All rights reserved.
//

import UIKit

@IBDesignable @objcMembers
class CircleInitialLabel: UILabel {

  enum CircleType: Int, CaseIterable {
    case small
    case big
  }

  // MARK: -
  // MARK: Init -

  override open func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  convenience init() {
    self.init(frame: .zero)
  }

  // MARK: -
  // MARK: Public Properties -

  public var type: CircleType = .small {
    didSet {
      updateType()
    }
  }

  // MARK: -
  // MARK: IB Properties -

  @IBInspectable var typeIndex: Int {
    get { return self.type.rawValue }
    set(newValue) {
      self.type = CircleType(rawValue: type.rawValue) ?? .small
    }
  }

}

// MARK: -
// MARK: FW Overrides -

extension CircleInitialLabel {

  override func layoutSubviews() {
    super.layoutSubviews()
    let cornerRadius: CGFloat = frame.size.height / 2.0
    layer.cornerRadius = cornerRadius
    clipsToBounds = true
    layer.masksToBounds = true
  }
}

// MARK: -
// MARK: Setup -

private extension CircleInitialLabel {

  func updateType() {
    switch type {
    case .small:
      backgroundColor = .lightGray
      textColor = .white
      font = font.withSize(17)
      textAlignment = .center
    case .big:
      backgroundColor = .lightGray
      textColor = .black
      font = font.withSize(60)
      textAlignment = .center
    }
  }

  func setupView() {
    textAlignment = .center
    updateType()
    let widthC = widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0); widthC.identifier = "widthC"; widthC.isActive = true
  }
}
