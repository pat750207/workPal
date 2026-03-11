

import Foundation
import UIKit

// ⚠️ LeaveType 已遷移至 Features/TakeLeave/Models/LeaveRequest.swift
// 此處改名為 LegacyLeaveType 以避免衝突，僅供舊 UIKit 代碼參考
enum LegacyLeaveType: String, CaseIterable {
    case sickLeave
    case personalLeave
    case annualLeave

    var title: String {
        switch self {
        case .sickLeave:
            return "Sick leave"
        case .personalLeave:
            return "Personal leave"
        case .annualLeave:
            return "Annual leave"
        }
    }
}

protocol MyPickerDelegate {
    func updateText(_ text: String, leaveType: LegacyLeaveType)
}

class MyPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var picker: UIPickerView!
    private let pickerHeight = fullScreenSize.height * (1/4)
        
    var delegate: MyPickerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setView()
        self.set(dataSource: self, delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(tap:)))
        self.backgroundColor = UIColor.init(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        self.isHidden = true
        self.addGestureRecognizer(tapGesture)
                
        self.picker = UIPickerView(frame: CGRect(x: 0, y:fullScreenSize.height, width: fullScreenSize.width, height: self.pickerHeight))
        self.picker.backgroundColor = UIColor.init(displayP3Red: 232/255, green: 232/255, blue: 232/255, alpha: 1)

        self.addSubview(self.picker)
    }
    
    @objc func tap(tap: UITapGestureRecognizer) {
        self.hidePicker()
    }
    
    private func set(dataSource: UIPickerViewDataSource, delegate: UIPickerViewDelegate) {
        self.picker.delegate = delegate
        self.picker.dataSource = dataSource
    }
        
    private func showPicker() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.addSubview(self)
        
        UIView.animate(withDuration: 0.3) {
            self.isHidden = false
            self.picker.frame = CGRect(x: 0, y: fullScreenSize.height , width: fullScreenSize.width, height: -(self.pickerHeight))
        }
    }
    
    func hidePicker() {
        UIView.animate(withDuration: 0.3, animations: {
            self.picker.frame = CGRect(x: 0, y: fullScreenSize.height, width: fullScreenSize.width, height: self.pickerHeight)
        }) { (Bool) in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }
    
    func show() {
        self.picker.reloadAllComponents()
        self.setPickerSelect()
        self.showPicker()
    }
    
    func setPickerSelect() {
        self.picker.selectRow(0, inComponent: 0, animated: true)
    }
    
    //MARK: PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return LegacyLeaveType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return LegacyLeaveType.allCases[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.updateText(LegacyLeaveType.allCases[row].title, leaveType: LegacyLeaveType.allCases[row])
    }

}


