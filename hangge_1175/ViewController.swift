//
//  ViewController.swift
//  hangge_1175
//
//  Created by hangge on 2016/12/25.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,
UITableViewDataSource{
    
    //表格
    var tableView:UITableView?
    //表格数据
    var listItems = [ListItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("before update date.......")
        
        //初始化数据
        listItems = [ListItem(text: "这是条目1"), ListItem(text: "这是条目2"),
                     ListItem(text: "这是条目3")]
        
        //创建表视图
        self.tableView = UITableView(frame:self.view.frame, style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(MyTableViewCell.self, forCellReuseIdentifier: "tableCell")
        self.view.addSubview(self.tableView!)
        
        //监听键盘弹出通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(keyboardWillShow(_:)),
                         name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //监听键盘隐藏通知
        NotificationCenter.default
            .addObserver(self,selector: #selector(keyboardWillHide(_:)),
                         name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //导航栏编辑按钮点击
    @IBAction func editBarBtnClick(_ sender: UIBarButtonItem) {
        //在正常状态和编辑状态之间切换
        if(self.tableView!.isEditing == false){
            self.tableView!.setEditing(true, animated:true)
            sender.title = "保存"
        }
        else{
            self.tableView!.setEditing(false, animated:true)
            sender.title = "编辑"
        }
        //重新加载表数据（改变单元格输入框编辑/只读状态）
        self.tableView?.reloadData()
    }
    
    //在本例中，有1个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //返回表格行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
            as! MyTableViewCell
        //设置单元格内容
        let item = listItems[(indexPath as NSIndexPath).row]
        cell.listItem = item
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        //内容标签是否可编辑
        cell.labelEditable = tableView.isEditing
        return cell
    }
    
    // UITableViewDelegate 方法，处理列表项的选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // 获取点击的cell
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        NSLog("---------deselectRow.....")
        self.tableView!.deselectRow(at: indexPath, animated: true)
        let itemString = listItems[(indexPath as NSIndexPath).row].text
        let alertController = UIAlertController(title: "提示!",
                                                message: "你选中了【\(itemString)】",
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath)->Bool
    {
        return true
    }
    
    //是否有删除功能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)
        -> UITableViewCellEditingStyle
    {
        if(self.tableView!.isEditing == false){
            return UITableViewCellEditingStyle.none
        }else{
            return UITableViewCellEditingStyle.delete
        }
    }
    
    //删除提示
    func tableView(_ tableView: UITableView,
                   titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath)
        -> String? {
            return "确定删除？"
    }
    
    //编辑完毕（这里只有删除操作）
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete)
        {
            self.listItems.remove(at: (indexPath as NSIndexPath).row)
            self.tableView!.reloadData()
            print("你确认了删除按钮")
        }
    }
    
    //在编辑状态，可以拖动设置cell位置
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //移动cell事件
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath,
                   to toIndexPath: IndexPath) {
        NSLog("---------move.....")
        if fromIndexPath != toIndexPath{
            //获取移动行对应的值
            let itemValue:ListItem = listItems[(fromIndexPath as NSIndexPath).row]
            //删除移动的值
            listItems.remove(at: (fromIndexPath as NSIndexPath).row)
            //如果移动区域大于现有行数，直接在最后添加移动的值
            if (toIndexPath as NSIndexPath).row > listItems.count{
                listItems.append(itemValue)
            }else{
                //没有超过最大行数，则在目标位置添加刚才删除的值
                listItems.insert(itemValue, at:(toIndexPath as NSIndexPath).row)
            }
        }
    }
    
    // 键盘显示
    @objc func keyboardWillShow(_ notification: Notification) {
        NSLog("---------keyboard.....")
        let userInfo = (notification as NSNotification).userInfo!
        //键盘尺寸
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey]
            as! NSValue).cgRectValue
        var contentInsets:UIEdgeInsets
        //判断是横屏还是竖屏
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if UIInterfaceOrientationIsPortrait(statusBarOrientation) {
            contentInsets = UIEdgeInsetsMake(64.0, 0.0, (keyboardSize.height), 0.0);
        } else {
            contentInsets = UIEdgeInsetsMake(64.0, 0.0, (keyboardSize.width), 0.0);
        }
        //tableview的contentview的底部大小
        self.tableView!.contentInset = contentInsets;
        self.tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    // 键盘隐藏
    @objc func keyboardWillHide(_ notification: Notification) {
        NSLog("---------keyboard off .....")
        //还原tableview的contentview大小
        let contentInsets:UIEdgeInsets = UIEdgeInsetsMake(64.0, 0.0, 0, 0.0);
        self.tableView!.contentInset = contentInsets
        self.tableView!.scrollIndicatorInsets = contentInsets
    }
    
    //页面移除时
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("---------view disappear.....")
        //取消键盘监听通知
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        NSLog("--------- didReceiveMemoryWarning.....")
        super.didReceiveMemoryWarning()
    }
}

