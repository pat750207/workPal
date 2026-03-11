//
//  NoticeBoardViewController.swift
//  iOS-188Asia
//
//  Created by Pat Chang  (XN-188Asia) on 2025/1/15.
//

import UIKit

class NoticeBoardViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  var noticeBoardList: [NoticeBoard] = [] {
    didSet { tableView.reloadData() }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()

    getNoticeBoards()

  }

  private func setupTableView() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    let cellId = "NoticeBoardCell"
    let nib = UINib(nibName: cellId, bundle: nil)
    self.tableView.register(nib, forCellReuseIdentifier: cellId)

    // Add padding to the top of the table view
    let topInset: CGFloat = 30.0
    self.tableView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)

    // Add a footer view
    self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))

    // Enable bouncing for better scrolling experience
    self.tableView.bounces = true

    // Enable always bounce vertical for scrolling even when content is small
    self.tableView.alwaysBounceVertical = true
  }

  func getNoticeBoards() {
    let jsonData = readLocalJSONFile(forName: "NoticeBoards")

    if let data = jsonData {
      if let noticeBoardsObjc = getNoticeBoard(jsonData: data) {
        self.noticeBoardList = noticeBoardsObjc
      }
    }
  }

}

extension NoticeBoardViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return noticeBoardList.count
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 95
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(with: NoticeBoardCell.self, for: indexPath)
    cell.setup(with: noticeBoardList[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.navigationController?.pushViewController(
      NoticeBoardDetailViewController(noticeBoardDetail: self.noticeBoardList[indexPath.row]),
      animated: true)
  }

}
