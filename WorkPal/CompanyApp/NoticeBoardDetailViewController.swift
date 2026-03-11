//
//  NoticeBoardDetailViewController.swift
//  iOS-188Asia
//
//  Created by Pat Chang  (XN-188Asia) on 2025/1/16.
//

import UIKit

class NoticeBoardDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var noticeBoardDetail: NoticeBoard?

    init(noticeBoardDetail: NoticeBoard) {
        self.noticeBoardDetail = noticeBoardDetail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
//        contentTextView.sizeToFit()
//        contentTextView.translatesAutoresizingMaskIntoConstraints = false
        contentTextView.clipsToBounds = true
    }
    
    private func setupView() {
        guard let noticeBoardDetail = noticeBoardDetail else { return }
        self.titleLabel.text = noticeBoardDetail.title
        self.dateLabel.text = noticeBoardDetail.date
        let contentStr = noticeBoardDetail.content?.replacingOccurrences(of: "\\n", with: "\n")
        self.contentTextView.text = contentStr
        self.contentTextView.isEditable = false
    }
    
}
