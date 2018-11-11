//
//  DashboardViewController.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController, Storyboarded {
    
    static var shouldReload: Bool = false
    static var amountOwed: String = "0.00"
    
    static var storyboardId: String = "DashboardViewController"
    static var storyboard: String = "Dashboard"
    
    // MARK: - Outlets
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tasksListTableView: UITableView!
    // END OUTLETS
    
    private var tasks: [TaskViewModel] = []
    private var tasksListTableDataSource: TasksListTableDataSource?
    
    // MARK: - Init

    private var loginFeatureDelegate: LoginFeatureDelegate?
    private var tasksListFeature: TasksListFeature?
    
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFeatures()
        initViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard AppStates.userIsLoggedIn.evaluate else {
            self.navigate(to: .login(self))
            return
        }
        
        if DashboardViewController.amountOwed != "0.00" {
            
            self.owedValue = NSDecimalNumber(string: DashboardViewController.amountOwed).doubleValue
            displayLink = CADisplayLink(target: self, selector: #selector(update))
            displayLink.add(to: .current, forMode: .common)
            startDate = Date()
            
        } else {
            
            let cached = self.amountLabel.text
            self.amountLabel.text = "0.00"
            
            LoanAmount.shared.getLoanAmount { (err, amount) in
                
                guard err == nil else {
                    self.amountLabel.text = cached
                    self.showAlert(.error, message: err!.localizedDescription)
                    return
                }
                
                self.amountLabel.text = "0.00"
                self.owedValue = NSDecimalNumber(value: amount!).doubleValue
                self.displayLink = CADisplayLink(target: self, selector: #selector(self.update))
                self.displayLink.add(to: .current, forMode: .common)
                self.startDate = Date()
                
                if amount == 0 {
                    self.tasksListTableView.isUserInteractionEnabled = true
                    self.tasksListTableView.alpha = 1.0
                } else {
                    // already pre-disabled
                }
                
                if DashboardViewController.shouldReload {
                    self.showHUD()
                    self.tasksListFeature?.fetchTasksList(category: .office)
                    DashboardViewController.shouldReload = false
                }
                
            }
            
        }
        
    }
    
    private var shouldDisableCell: Bool = false
    
    // MARK: - Eye Candy
    var displayLink: CADisplayLink!
    var owedValue: Double = 0.0
    var startDate: Date!
    // END EYE CANDY
    
    @objc func update() {
        
        let rate = Date().timeIntervalSince(startDate) / 1.0
        
        let res = self.owedValue * rate
        if res >= self.owedValue {
            let string = String(format: "%.2f", self.owedValue)
            self.amountLabel.text = string
            displayLink.remove(from: .current, forMode: .common)
            return
        }
        
        let string = String(format: "%.2f", res)
        self.amountLabel.text = string
    }
    
    private func initFeatures() {
        self.tasksListFeature = TasksListFeature(self)
    }
    
    fileprivate func initTasksListTableView() {
        let nib = UINib(nibName: TasksListTableViewCell.identifier, bundle: nil)
        self.tasksListTableView.register(nib, forCellReuseIdentifier: TasksListTableViewCell.identifier)
        self.tasksListTableView.delegate = self
        self.tasksListTableDataSource = TasksListTableDataSource()
        self.tasksListTableView.dataSource = self.tasksListTableDataSource
        self.tasksListTableView.separatorStyle = .none
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
        self.tasksListTableView.refreshControl = refreshControl
        
        
        // MARK: - Initially disable
        self.tasksListTableView.isUserInteractionEnabled = false
        self.tasksListTableView.alpha = 0.30
    }
    
    private func initViews() {
        initTasksListTableView()
        self.amountLabel.text = DashboardViewController.amountOwed
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutHandler))
    }
    
    // MARK: - Action
    @objc private func refreshControlAction() {
        showHUD()
        refreshControl.beginRefreshing()
        self.tasksListFeature?.fetchTasksList(category: .office)
    }
    
    @objc private func logoutHandler() {
        CredentialsManager.shared.clearToken()
        viewDidAppear(false)
    }
    
}

extension DashboardViewController: CallsAnApiBehindLogin {
    
    func callApi(_ loginFeatureDelegate: LoginFeatureDelegate) {
        self.loginFeatureDelegate = loginFeatureDelegate
        self.tasksListFeature?.fetchTasksList(category: .office)
    }
    
}

extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = self.tasksListTableDataSource else { return }
        let task = dataSource.tasks[indexPath.row]
        self.navigate(to: .taskDetails(task))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
}

extension DashboardViewController: TasksListFeatureDelegate {
    
    func getTaskListSuccess(_ viewModel: [TaskViewModel]) {
        hideHUD()
        refreshControl.endRefreshing()
        
        self.tasks = viewModel
        self.tasksListTableDataSource?.reloadData(self.tasks, tableView: tasksListTableView)
        
        self.loginFeatureDelegate?.loginSuccess()
        self.loginFeatureDelegate = nil
        
    }
    
    func getTaskListError(error: String) {
        hideHUD()
        refreshControl.endRefreshing()
        
        self.loginFeatureDelegate?.loginFailed(error: error)
        self.loginFeatureDelegate = nil

    }
    
}

