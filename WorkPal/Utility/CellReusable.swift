//
//  CellReusable.swift
//  iOS-188Asia
//
//  Created by Pat Chang on 2018/4/23.
//  Copyright © 2018 Xuenn Pte Ltd. All rights reserved.
//

import UIKit

public protocol CellReusable {
    static var reuseIdentifier: String { get }
    static var toUINib: UINib { get }
}

extension CellReusable {
    public static var reuseIdentifier: String { return String(describing: self) }
    public static var toUINib: UINib          { return UINib(nibName: reuseIdentifier, bundle: .mainBundle188Asia)
    }
}

extension UICollectionView {
    public func dequeueReusableCell<Cell: CellReusable>(with cellClass: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as! Cell
    }
    public func register<Cell: CellReusable>(with cellClass: Cell.Type) {
        register(cellClass.toUINib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}
extension UICollectionViewCell : CellReusable {}

extension UITableView {
    public func dequeueReusableCell<Cell: CellReusable>(with cellClass: Cell.Type, for indexPath: IndexPath) -> Cell {
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as! Cell
    }
    public func dequeueReusableCell<Cell: CellReusable>(with cellClass: Cell.Type) -> Cell {
        return dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier) as! Cell
    }
    public func register<Cell: CellReusable>(with cellClass: Cell.Type) {
        register(cellClass.toUINib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}
extension UITableViewCell: CellReusable {}

