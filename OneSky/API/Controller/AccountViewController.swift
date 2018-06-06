//
//  AccountViewController.swift
//  OneSkyTestApp
//
//  Created by Daniil Vorobyev on 16.05.2018.
//  Copyright © 2018 Daniil Vorobyev. All rights reserved.
//

import Foundation
import UIKit

/**
 View controller for Account settings
 Implementing Account settings button

 - Author:
 OneSky

 */

open class AccountViewController: UIViewController {

    // - MARK: Varaibles

    /// Opening controller style

    public var presentStyle     : OpenStyle!

    /// Current user id

    public var userId           : Int?

    /// One Sky delegate

    weak var delegate           : OneSkyManager?

    /// Opening controller style

    fileprivate var tableView   : UITableView!

    var textInfo = ["language_should_be_displayed".localLocalized]

    // - MARK: Functions

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "locale_settings".localLocalized
        textInfo = ["language_should_be_displayed".localLocalized]
    }

    /// Setup tableview

    fileprivate func setupUI() {
        let rect = CGRect(origin: CGPoint(x: 10, y: 30),
                          size: CGSize(width: self.view.frame.width - 20,
                                       height: 400))
        tableView = UITableView(frame: rect)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = UIColor.lightText
        tableView.reloadData()
    }

}

// - MARK: UITableViewDelegate

extension AccountViewController: UITableViewDelegate {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textInfo.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = textInfo[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .black
        return cell
    }

}

// - MARK: UITableViewDataSource

extension AccountViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let id = userId {
                delegate?.openSettings(from: self,
                                       style: presentStyle,
                                       userId: id)
            } else {
                delegate?.openSettings(from: self,
                                       style: presentStyle)
            }
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

}
