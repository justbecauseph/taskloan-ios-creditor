//
//  TaskDetailViewController.swift
//  decode-tomorrow
//
//  Created by Mark on 10/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, Storyboarded {

    static var storyboardId: String = "TaskDetailViewController"
    static var storyboard: String = "Dashboard"

    // MARK: - Outlets
    @IBOutlet weak var taskTitle: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var taskedByNameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var detailCardView: UIView!
    @IBOutlet weak var descriptionCardView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var claimButton: UIButton!
    
    @IBOutlet weak var userIconLabel: UILabel!
    @IBOutlet weak var clockIconLabel: UILabel!
    // END OUTLETS

    var feature: ClaimTaskFeature?

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        initFeature()
    }
    
    private var taskViewModel: TaskViewModel!
    
    func initValues(_ taskViewModel: TaskViewModel) {
        self.taskViewModel = taskViewModel
    }
    
    private func initViews() {
        
        let m = self.taskViewModel.model
        taskTitle.text = m.title ?? ""
        
        
        let cat = TasksCategories(m.category ?? "")
        categoryLabel.text = cat.text
        categoryView.backgroundColor = cat.color
        
        amountLabel.text = m.amount ?? ""
        
        amountLabel.text = "PHP " + String((m.amount?.split(separator: ".")[0])!)
        
        taskedByNameLabel.text = "tasked by \(m.user!.name)"
        hoursLabel.text = m.duration ?? ""
        
        descriptionTextView.text = m.description ?? ""
        
        categoryView.cornerRadius = 5
        amountView.cornerRadius = 5
        
        userIconLabel.font = UIFont.fontAwesome(ofSize: 12, style: .regular)
        userIconLabel.text = String.fontAwesomeIcon(name: .user)
        clockIconLabel.font = UIFont.fontAwesome(ofSize: 12, style: .regular)
        clockIconLabel.text = String.fontAwesomeIcon(name: .clock)
        
        detailCardView.cornerRadius = 10
        descriptionCardView.cornerRadius = 10
        descriptionCardView.clipsToBounds = true
        descriptionTextView.font = Fonts.AvenirNextMedium.font(14)
        descriptionTextView.textColor = Colors.textGray.uiColor
        contactButton.styleWhiteBorder()
        claimButton.styleInverted()
    }

    private func initFeature() {
//        self.feature = ClaimTaskFeature(self)
    }

    // MARK: - Actions
    @IBAction func didtTapContactButton(_ sender: Any) {
    }
    
    @IBAction func didTapClaimButton(_ sender: Any) {
        self.navigate(to: .loan)
    }
}

extension TaskDetailViewController: ClaimTaskFeatureDeletage {
    
    func claimTaskSuccess(_ viewModel: ClaimTaskViewModel) {
    }
    
    func claimTaskError(error: String) {
    }

}
