//
//  NoticeBoardCell.swift
//  iOS-188Asia
//
//  Created by Pat Chang  (XN-188Asia) on 2025/1/15.
//

import UIKit

class NoticeBoardCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dataLabel: UILabel!
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

    // 將 dataLabel 的文本顏色設置為淺灰色
    self.dataLabel.textColor = UIColor.veryLightGray
  }

  func setup(with noticeBoard: NoticeBoard) {
    self.titleLabel.text = noticeBoard.title
    self.dataLabel.text = noticeBoard.date
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
