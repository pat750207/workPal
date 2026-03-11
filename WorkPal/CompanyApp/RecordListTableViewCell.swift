//
//  RecordListTableViewCell.swift
//  iOS-188Asia
//
//  Created by Pat Chang (XN-188Asia) on 2025/1/16.
//

import UIKit

class RecordListTableViewCell: UITableViewCell {

  @IBOutlet weak var punchinDateLabel: UILabel!

  @IBOutlet weak var punchoutDateLabel: UILabel!

  override var frame: CGRect {
    didSet {
      var newFrame = frame
      newFrame.origin.x += 16.0
      newFrame.size.width -= 32.0
      newFrame.size.height -= 20.0
      super.frame = newFrame
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.veryLightGray.cgColor
    self.layer.cornerRadius = 5
  }

  func bind(data: TimeRecord) -> Self {
    punchinDateLabel.text = data.inTimeString
    punchoutDateLabel.text = data.outTimeString

    return self
  }

}
