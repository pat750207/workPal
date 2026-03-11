//
//  PunchClockViewController.swift
//  iOS-188Asia
//
//  Created by Pat Chang (XN-188Asia) on 2025/1/14.
//

import Combine
import UIKit

class PunchClockViewController: UIViewController {

  @IBOutlet weak var workingHourStack: UIStackView!
  @IBOutlet weak var workingHourLabel: UILabel!
  @IBOutlet weak var weekdayLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var quoteTextField: UITextView!
  @IBOutlet weak var iconBgLayer: UIView!

  var viewModel = PunchClockViewModel()
  var cancellable = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()

    bind()
    renderUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    bind()
    viewModel.checkAutoPunchOut()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    cancellable.removeAll()
  }

  func bind() {
    viewModel.$quoteSubject
      .assign(to: \.text, on: quoteTextField)
      .store(in: &cancellable)

    viewModel.$dateStr
      .assign(to: \.text!, on: dateLabel)
      .store(in: &cancellable)

    viewModel.$weekDayStr
      .assign(to: \.text!, on: weekdayLabel)
      .store(in: &cancellable)

    viewModel.$isPunchIn
      .sink { [weak self] isPunchIn in
        guard let self = self else { return }

        self.workingHourStack.isHidden = !isPunchIn

        let opacity: Float = isPunchIn ? 1 : 0

        let animator = UIViewPropertyAnimator.runningPropertyAnimator(
          withDuration: 0.5,
          delay: 0.15,
          options: .curveEaseInOut
        ) {
          self.workingHourStack.layer.opacity = opacity
        }
        animator.addAnimations(
          {
            self.viewModel.checkOutButton.layer.opacity = opacity
          }, delayFactor: 0.3)
      }.store(in: &cancellable)

    workingHourLabel.text = viewModel.workingHourStr
  }

  private func renderUI() {
    // 增強陰影效果
    iconBgLayer.layer.shadowColor = UIColor.systemBlue.cgColor
    iconBgLayer.layer.shadowOpacity = 0.8
    iconBgLayer.layer.shadowRadius = 15
    iconBgLayer.layer.shadowOffset = CGSize(width: 0, height: 4)

    // 添加漸變背景
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = iconBgLayer.bounds
    gradientLayer.colors = [
      UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 0.6).cgColor,
      UIColor(red: 0.0, green: 0.4, blue: 0.8, alpha: 0.3).cgColor,
    ]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.cornerRadius = 12
    iconBgLayer.layer.insertSublayer(gradientLayer, at: 0)

    viewModel.createCheckInButton(controller: self, action: #selector(checkIn))
    viewModel.createCheckOutButton(controller: self, action: #selector(checkOut))

    // 更生動的提示文本
    viewModel.captionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
    viewModel.captionLabel.textColor = UIColor.white
    viewModel.captionLabel.text = "✨ Double-tap to punch in"

    view.addSubview(viewModel.captionLabel)

    viewModel.captionLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      viewModel.captionLabel.topAnchor.constraint(equalTo: viewModel.checkInButton.bottomAnchor),
      viewModel.captionLabel.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 96),
    ])
  }

  @objc private func checkIn(_ sender: UIButton) {
    // 添加按鈕點擊動畫效果
    UIView.animate(
      withDuration: 0.15,
      animations: {
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      }
    ) { _ in
      UIView.animate(withDuration: 0.15) {
        sender.transform = CGAffineTransform.identity
      }
    }

    // 添加成功打卡粒子效果
    let particleEmitter = CAEmitterLayer()
    particleEmitter.emitterPosition = CGPoint(
      x: sender.frame.origin.x + sender.frame.width / 2,
      y: sender.frame.origin.y + sender.frame.height / 2)
    particleEmitter.emitterShape = .point
    particleEmitter.emitterSize = CGSize(width: 1, height: 1)

    let cell = CAEmitterCell()
    cell.birthRate = 100
    cell.lifetime = 2.0
    cell.velocity = 150
    cell.velocityRange = 50
    cell.emissionRange = CGFloat.pi * 2
    cell.scale = 0.4
    cell.scaleRange = 0.2
    cell.color = UIColor.systemBlue.cgColor
    cell.alphaSpeed = -0.5
    cell.contents = UIImage(systemName: "checkmark.circle.fill")?.cgImage

    particleEmitter.emitterCells = [cell]
    view.layer.addSublayer(particleEmitter)

    // 啟動粒子動畫後自動停止並移除
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      particleEmitter.birthRate = 0
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      particleEmitter.removeFromSuperlayer()
    }

    viewModel.isPunchIn = true
    viewModel.vibrate()

    // 顯示生動的打卡成功消息
    let successLabel = UILabel()
    successLabel.text = "✓ Punch In Success!"
    successLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    successLabel.textColor = UIColor.systemGreen
    successLabel.textAlignment = .center
    successLabel.alpha = 0
    successLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(successLabel)
    NSLayoutConstraint.activate([
      successLabel.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
      successLabel.topAnchor.constraint(equalTo: sender.bottomAnchor, constant: 40),
    ])

    UIView.animate(
      withDuration: 0.5,
      animations: {
        successLabel.alpha = 1
      }
    ) { _ in
      UIView.animate(
        withDuration: 0.5, delay: 1.5, options: [],
        animations: {
          successLabel.alpha = 0
        },
        completion: { _ in
          successLabel.removeFromSuperview()
        })
    }
  }

  @objc private func checkOut(_ sender: UIButton) {
    // 添加按鈕點擊動畫效果
    UIView.animate(
      withDuration: 0.15,
      animations: {
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      }
    ) { _ in
      UIView.animate(withDuration: 0.15) {
        sender.transform = CGAffineTransform.identity
      }
    }

    // 添加成功打卡粒子效果 - 使用不同的顏色和形狀
    let particleEmitter = CAEmitterLayer()
    particleEmitter.emitterPosition = CGPoint(
      x: sender.frame.origin.x + sender.frame.width / 2,
      y: sender.frame.origin.y + sender.frame.height / 2)
    particleEmitter.emitterShape = .point
    particleEmitter.emitterSize = CGSize(width: 1, height: 1)

    let cell = CAEmitterCell()
    cell.birthRate = 100
    cell.lifetime = 2.0
    cell.velocity = 150
    cell.velocityRange = 50
    cell.emissionRange = CGFloat.pi * 2
    cell.scale = 0.4
    cell.scaleRange = 0.2
    cell.color = UIColor.systemOrange.cgColor
    cell.alphaSpeed = -0.5
    cell.contents = UIImage(systemName: "star.fill")?.cgImage

    particleEmitter.emitterCells = [cell]
    view.layer.addSublayer(particleEmitter)

    // 啟動粒子動畫後自動停止並移除
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      particleEmitter.birthRate = 0
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      particleEmitter.removeFromSuperlayer()
    }

    viewModel.isPunchOut = true
    viewModel.vibrate()

    // 顯示生動的打卡成功消息
    let successLabel = UILabel()
    successLabel.text = "✨ Punch Out Success! Have a nice day!"
    successLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    successLabel.textColor = UIColor.systemOrange
    successLabel.textAlignment = .center
    successLabel.alpha = 0
    successLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(successLabel)
    NSLayoutConstraint.activate([
      successLabel.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
      successLabel.topAnchor.constraint(equalTo: sender.bottomAnchor, constant: 40),
    ])

    UIView.animate(
      withDuration: 0.5,
      animations: {
        successLabel.alpha = 1
      }
    ) { _ in
      UIView.animate(
        withDuration: 0.5, delay: 1.5, options: [],
        animations: {
          successLabel.alpha = 0
        },
        completion: { _ in
          successLabel.removeFromSuperview()
          // 顯示恭喜提示
          self.viewModel.displayAlert(self, title: "Congratulations", message: "Hurry off work! 🎉")
        })
    }
  }
  @IBAction func goSetting(_ sender: Any) {
    self.navigationController?.pushViewController(SettingViewController(), animated: true)
  }
}
