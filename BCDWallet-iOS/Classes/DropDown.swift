//
//  DropDown.swift
//  YogaEditor
//
//  Created by Evgeniy Lugovoy on 09.10.19.
//  Copyright © 2019 MeadowsPhone. All rights reserved.
//

import UIKit

protocol DropDownDelegate:class {
    func dropdownSelected(_ sender : UIButton, selected: Int) -> Void
}

class DropDown: UIView, UITableViewDelegate, UITableViewDataSource {

    var cellsList: [String] = [String]()
    var view: UIView!
    var buttonSender: UIButton!
    var downImage: UIImageView!
    
    public weak var dropDownDelegate: DropDownDelegate?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0)
        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isOpaque = false
        tableView.backgroundColor = UIColor.init(red: 0.08, green: 0.07, blue: 0.16, alpha: 0.5)
        tableView.backgroundView = nil
        tableView.bounces = false
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(button: UIButton, height: CGFloat, array: [String], downImg: UIImageView) {
        let x = button.frame.origin.x
        let sx = button.superview!.frame.origin.x
//        let rect = CGRect(x: sx + x, y: button.superview!.frame.origin.y + button.frame.size.height,
//                          width: button.frame.size.width, height: height)
        self.init(frame: button.superview!.superview!.frame)
        self.buttonSender = button
        self.downImage = downImg

        self.tableView.layer.masksToBounds = false
        self.tableView.layer.cornerRadius = 8
        self.tableView.layer.shadowRadius = 5
        self.tableView.layer.shadowOpacity = 0.5
        self.tableView.backgroundColor = UIColor.init(red: 0.08, green: 0.07, blue: 0.16, alpha: 0.5)
        self.tableView.layer.shadowOffset = CGSize(width: 5, height: 5.0)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        
        self.tableView.frame = CGRect(x: sx + x,
                                      y: button.superview!.frame.origin.y + button.frame.size.height,
                                      width: button.frame.size.width,
                                      height: 0)
        
        button.superview!.superview!.insertSubview(self, belowSubview: button.superview!)
        self.addSubview(self.tableView)
        self.downImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () -> Void in
                        self.tableView.frame.size.height = height
                        self.downImage.transform = CGAffineTransform(scaleX: 1, y: -1)
        }, completion: {
            (completed: Bool) -> Void in
            self.cellsList = array
            self.tableView.reloadData()
        })
    }
    
    func hideDropDown(button: UIButton, duration: TimeInterval) -> Void {
        self.cellsList.removeAll()
        self.tableView.reloadData()
        self.downImage.transform = CGAffineTransform(scaleX: 1, y: -1)
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.downImage.transform = CGAffineTransform(scaleX: 1, y: 1)
                        self.tableView.frame.size.height = 0.0

        }, completion: {
            (completed: Bool) -> Void in
            self.removeFromSuperview()
        })
    }
    
    //MARK TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = UIColor.init(red: 0.08, green: 0.07, blue: 0.16, alpha: 0.5)
        cell.textLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text  = self.cellsList[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.dropDownDelegate != nil) {
            self.dropDownDelegate?.dropdownSelected(self.buttonSender, selected: indexPath.row)
        }
    }

}
