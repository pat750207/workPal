//
//  OrderLunchViewController.swift
//  WorkPal
//
//  Created on 2025/5/16.
//

import UIKit

class OrderLunchViewController: UIViewController {

  // MARK: - UI Enhancement Elements

  @IBOutlet private var headerView: UIView!
  @IBOutlet private var headerLabel: UILabel!
  @IBOutlet private var decorationView: UIView!
  @IBOutlet private var scrollView: UIScrollView!
  @IBOutlet private var contentView: UIView!
  @IBOutlet private var titleLabel: UILabel!
  @IBOutlet private var deadlineLabel: UILabel!
  @IBOutlet private var tableView: UITableView!
  @IBOutlet private var orderButton: UIButton!

  // These UI elements are for programmatic UI setup - keep for reference
  private let headerViewProgrammatic: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemBlue
    return view
  }()

  private let headerLabelProgrammatic: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Order Lunch"
    label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    label.textColor = .white
    return label
  }()

  private let decorationViewProgrammatic: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .secondarySystemBackground
    view.layer.cornerRadius = 20
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 6
    view.layer.shadowOpacity = 0.1
    return view
  }()

  // MARK: - UI Elements

  private let scrollViewProgrammatic: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsVerticalScrollIndicator = true
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()

  private let contentViewProgrammatic: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let titleLabelProgrammatic: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Today's Menu"
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.textColor = .label
    return label
  }()

  private let deadlineLabelProgrammatic: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Order Deadline: 10:30 AM"
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .red
    return label
  }()

  private let tableViewProgrammatic: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .singleLine
    tableView.layer.cornerRadius = 12
    tableView.layer.borderWidth = 1
    tableView.layer.borderColor = UIColor.lightGray.cgColor
    tableView.backgroundColor = .secondarySystemBackground
    return tableView
  }()

  private let orderButtonProgrammatic: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Confirm Order", for: .normal)
    button.backgroundColor = .systemBlue
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.layer.cornerRadius = 25
    return button
  }()

  // MARK: - Properties

  private var menuItems: [MenuItem] = [
    MenuItem(
      name: "Fried Chicken Rice", price: 85, image: "chicken_rice",
      description: "Tender fried chicken with special sauce"),
    MenuItem(
      name: "Beef Rice Bowl", price: 95, image: "beef_rice",
      description: "Fresh beef slices with green onions"),
    MenuItem(
      name: "Salmon Sushi Rice", price: 90, image: "salmon_sushi",
      description: "Premium salmon with sushi rice"),
    MenuItem(
      name: "Vegetarian Noodles", price: 75, image: "veggie_noodles",
      description: "Fresh vegetables with healthy noodles"),
    MenuItem(
      name: "Thai Spicy Noodle Soup", price: 85, image: "thai_noodles",
      description: "Mildly spicy Thai soup with pork"),
  ]

  private var selectedItemIndex: Int?

  // MARK: - Lifecycle Methods

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupTableView()
  }

  // MARK: - Setup Methods

  private func setupView() {
    // Setup dark mode background (now handled by background images in XIB)
    view.backgroundColor = UIColor.clear

    // Make header area background transparent
    headerView.backgroundColor = UIColor.clear

    // Make decoration area transparent
    decorationView.backgroundColor = UIColor.clear

    // Setup table view style
    tableView.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 0.7)  // Semi-transparent
    tableView.layer.borderColor = UIColor.veryLightGray.cgColor
    tableView.clipsToBounds = true
    tableView.layer.cornerRadius = 12
    tableView.separatorColor = UIColor.veryLightGray.withAlphaComponent(0.3)  // Set separator line color

    // Setup text
    headerLabel.text = "Order Lunch"
    headerLabel.textColor = UIColor.white

    titleLabel.text = "Today's Menu"
    titleLabel.textColor = UIColor.white

    deadlineLabel.text = "Order Deadline: 10:30 AM"
    deadlineLabel.textColor = UIColor(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0)  // Bright red color

    // Setup button
    orderButton.setTitle("Confirm Order", for: .normal)
    orderButton.applyStyle(.primary)  // Apply unified button style
    // Using unified corner radius style (10), no override
  }

  // Constraints are now managed by the XIB file

  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(MenuItemCell.self, forCellReuseIdentifier: "MenuItemCell")
    tableView.rowHeight = 160  // Further increase row height to ensure price label is visible
  }

  // MARK: - Actions

  @IBAction func orderButtonTapped(_ sender: UIButton) {
    guard let selectedIndex = selectedItemIndex else {
      showAlert(title: "No Selection", message: "Please select an item before ordering")
      return
    }

    let selectedItem = menuItems[selectedIndex]
    showAlert(
      title: "Order Successful",
      message: "You have successfully ordered \(selectedItem.name), price: $\(selectedItem.price)")
  }

  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension OrderLunchViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "MenuItemCell", for: indexPath) as! MenuItemCell
    let item = menuItems[indexPath.row]
    cell.configure(with: item)
    cell.accessoryType = indexPath.row == selectedItemIndex ? .checkmark : .none
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedItemIndex = indexPath.row
    tableView.reloadData()
  }
}

// MARK: - MenuItem Model

struct MenuItem {
  let name: String
  let price: Int
  let image: String
  let description: String
}

// MARK: - MenuItemCell

class MenuItemCell: UITableViewCell {

  // MARK: - UI Elements

  private let containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    view.layer.cornerRadius = 12
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 4
    view.layer.shadowOpacity = 0.1
    return view
  }()

  private let menuImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 12
    imageView.backgroundColor = .tertiarySystemBackground
    return imageView
  }()

  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textColor = .white  // Ensure visibility on dark background
    return label
  }()

  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 15)  // Adjusted font size
    label.textColor = .white  // White text for better clarity
    label.numberOfLines = 2  // Limit number of lines to ensure it doesn't overlap the price label
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textColor = .systemBlue  // Bright blue color for better visibility
    return label
  }()

  private let selectionIndicator: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemBlue
    view.layer.cornerRadius = 12
    view.isHidden = true
    return view
  }()

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup Methods

  private func setupViews() {
    selectionStyle = .none
    backgroundColor = .clear

    contentView.addSubview(containerView)

    containerView.addSubview(selectionIndicator)
    containerView.addSubview(menuImageView)
    containerView.addSubview(nameLabel)
    containerView.addSubview(descriptionLabel)
    containerView.addSubview(priceLabel)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      // Increase cell spacing to prevent button overlap
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),  // Increase bottom margin

      selectionIndicator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      selectionIndicator.topAnchor.constraint(equalTo: containerView.topAnchor),
      selectionIndicator.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      selectionIndicator.widthAnchor.constraint(equalToConstant: 6),

      // Adjust image size and position
      menuImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
      menuImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      menuImageView.widthAnchor.constraint(equalToConstant: 90),  // Increase image size
      menuImageView.heightAnchor.constraint(equalToConstant: 90),  // Increase image size

      // Name label
      nameLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16),
      nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),  // Increase top margin
      nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

      // Description label - adjust height and spacing
      descriptionLabel.leadingAnchor.constraint(
        equalTo: menuImageView.trailingAnchor, constant: 16),
      descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),  // Reduce top spacing
      descriptionLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor, constant: -12),
      // Remove fixed height constraint, use maximum height limit to ensure it's not too long
      descriptionLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 40),

      // Price label - adjust constraints for better visibility
      priceLabel.leadingAnchor.constraint(equalTo: menuImageView.trailingAnchor, constant: 16),
      priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),  // Reduce spacing
      priceLabel.bottomAnchor.constraint(
        equalTo: containerView.bottomAnchor, constant: -16),  // Ensure adequate spacing from bottom
    ])
  }

  // MARK: - Configuration

  func configure(with item: MenuItem) {
    nameLabel.text = item.name
    descriptionLabel.text = item.description
    priceLabel.text = "$\(item.price)"

    // Try to set the image
    if let image = UIImage(named: item.image) {
      menuImageView.image = image
    } else {
      // If no image is available, show placeholder background color
      menuImageView.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    }
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Customize selected state appearance
    UIView.animate(withDuration: 0.3) {
      self.selectionIndicator.isHidden = !selected
      self.containerView.backgroundColor =
        selected
        ? UIColor(red: 0.2, green: 0.2, blue: 0.25, alpha: 1.0)
        : UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
      self.containerView.layer.borderWidth = selected ? 1 : 0
      self.containerView.layer.borderColor =
        selected ? UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0).cgColor : nil
    }
  }
}
