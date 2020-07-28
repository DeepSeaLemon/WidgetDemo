//
//  ViewController.swift
//  WidgetDemo
//
//  Created by 曹宇明 on 2020/7/27.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI() {
        self.view.addSubview(picker)
        self.view.addSubview(sureButton)
    }
    
    //MARK:@objc===========
    @objc func sureButtonClick(_ sender:UIButton) {
        let pickerDate = picker.date
        // 保存到UserDefaults
        let userDefaults = UserDefaults(suiteName: kGroupName)
        userDefaults?.setValue(pickerDate, forKey: kUserDate)
        userDefaults?.synchronize()
    }
    
    //MARK:Lazy============
    lazy var picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.frame = CGRect(x: 0, y: 300, width: self.view.frame.width, height: 50)
        picker.layer.borderWidth = 1
        picker.layer.borderColor = UIColor.gray.cgColor
        picker.datePickerMode = .dateAndTime
        picker.locale = Locale.init(identifier: "zh_CN")
        return picker
    }()
    
    lazy var sureButton: UIButton = {
        let sure = UIButton()
        sure.frame = CGRect(x: self.view.frame.width - 70, y: 300, width: 60, height: 50)
        sure.setTitle("确定", for: .normal)
        sure.setTitleColor(.systemBlue, for: .normal)
        sure.setTitleColor(.white, for: .highlighted)
        sure.addTarget(self, action: #selector(sureButtonClick(_:)), for: .touchUpInside)
        return sure
    }()
}

