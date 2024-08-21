//
//  MyTableViewCell.swift
//  hangge_1175
//
//  Created by hangge on 2016/12/25.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

//表格数据实体类
class ListItem: NSObject {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}

//单元格类
class MyTableViewCell: UITableViewCell, UITextFieldDelegate {
    //单元格内部标签（可输入）
    let label:UITextField
    //单元格左边距
    var leftMarginForLabel: CGFloat = 15.0
    
    //单元格数据
    var listItem:ListItem? {
        didSet {
            label.text = listItem!.text
        }
    }
    
    //单元格是否可编辑
    var labelEditable:Bool? {
        didSet {
            label.isUserInteractionEnabled = labelEditable!
            //如果是可以编辑的话，要加大左边距（因为左边有个删除按钮）
            leftMarginForLabel = labelEditable! ? 45.0 : 15.0
            self.setNeedsLayout()
        }
    }
    
    //初始化
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        //初始化文本标签
        label = UITextField(frame: CGRect.null)
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 16)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //设置文本标签代理
        label.delegate = self
        label.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        //添加文本标签
        //addSubview(label)
        self.contentView.addSubview(label)
    }
    
    //布局
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: leftMarginForLabel, y: 0,
                             width: bounds.size.width - leftMarginForLabel,
                             height: bounds.size.height)
    }
    
    //键盘回车
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //结束编辑
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if listItem != nil {
            listItem?.text = textField.text!
        }
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

