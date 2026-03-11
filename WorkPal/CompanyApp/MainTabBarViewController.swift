//
//  MainTabBarViewController.swift
//  iOS-188Asia
//
//  Created by Pat Chang (XN-188Asia) on 2025/1/14.
//

import UIKit

class MainTabBarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupTabs()

    // 美化導航欄 - 深色模式
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1.0)  // 更深的背景色
    appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
    appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance

    // 設置登出按鈕
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logout))
    self.navigationItem.rightBarButtonItem?.tintColor = .white

    // 美化TabBar - 深色模式
    let tabBarAppearance = UITabBarAppearance()
    tabBarAppearance.configureWithOpaqueBackground()
    tabBarAppearance.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)  // 深色背景

    self.tabBar.standardAppearance = tabBarAppearance
    if #available(iOS 15.0, *) {
      self.tabBar.scrollEdgeAppearance = tabBarAppearance
    }

    self.tabBar.tintColor = UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0)  // 亮藍色選中項目
    self.tabBar.unselectedItemTintColor = UIColor(white: 0.9, alpha: 1.0)  // 非常淺的灰色，接近白色
  }

  @objc func logout() {

    UIHelper.showDialog(
      title: "Log out",
      message: "Are you sure you want to log out?？",
      okTitle: "logout",
      cancelTitle: "cancel",
      onOK: {
        self.navigationController?.setViewControllers([CompanyAppLoginVC()], animated: false)
      },
      onCancel: {

      }
    )

  }

  //MARK: - Tab setup

  private func setupTabs() {

    let home = self.createNav(
      with: "Punch", and: UIImage(systemName: "clock.fill"), vc: PunchClockViewController())
    let noticeBoard = self.createNav(
      with: "Notices", and: UIImage(systemName: "megaphone.fill"), vc: NoticeBoardViewController())
    let takeLeave = self.createNav(
      with: "Leave", and: UIImage(systemName: "figure.walk.circle.fill"),
      vc: TakeLeaveViewController()
    )
    let orderLunch = self.createNav(
      with: "Lunch", and: UIImage(systemName: "fork.knife.circle.fill"),
      vc: OrderLunchViewController())
    let profiles = self.createNav(
      with: "Profile", and: UIImage(systemName: "person.crop.circle.fill"),
      vc: ProfilesViewController())

    self.setViewControllers(
      [home, orderLunch, noticeBoard, takeLeave, profiles], animated: true)
  }

  private func createNav(with title: String, and image: UIImage?, vc: UIViewController)
    -> UINavigationController
  {
    let nav = UINavigationController(rootViewController: vc)

    nav.tabBarItem.title = title
    nav.tabBarItem.image = image

    nav.viewControllers.first?.navigationItem.title = title
    //        nav.viewControllers.first?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Button", style: .plain, target: nil, action: nil)

    return nav
  }

}
