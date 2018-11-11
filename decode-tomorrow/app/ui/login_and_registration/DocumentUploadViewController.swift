//
//  DocumentUploadViewController.swift
//  decode-tomorrow
//
//  Created by Mark on 11/11/2018.
//  Copyright © 2018 Just Because. All rights reserved.
//

import Foundation
import UIKit

class DocumentUploadViewController: UIViewController, Storyboarded {
    
    static var storyboardId: String = "DocumentUploadViewController"
    static var storyboard: String = "LoginAndRegistration"
    
    // MARK: - Outlets
    @IBOutlet weak var idNumberTextField: UITextField!
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var courseOrSpecializationTextField: UITextField!
    // END OUTLETS
    
    var feature: DocumentUploadFeature?
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFeature()
        initViews()
    }
    
    private func initViews() {
        idNumberTextField.style()
        courseOrSpecializationTextField.style()
        documentImageView.addDashedBorder()
        verifyButton.style()
    }
    
    private func initFeature() {
        self.feature = DocumentUploadFeature(self)
    }
    
    // MARK: - Actions
    
    @IBAction func didTapPhotoButton(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let useCamera = UIAlertAction(title: "Use Camera", style: .default) { _ in self.presentImagePicker(.camera) }
        let useGallery = UIAlertAction(title: "Select from Gallery", style: .default) { _ in self.presentImagePicker(.savedPhotosAlbum) }
        alert.addAction(useCamera)
        alert.addAction(useGallery)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func presentImagePicker(_ sourceType: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.sourceType = sourceType
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func didTapVerifyButton(_ sender: Any) {
        guard let documentImage = documentImageView.image else { return }
        guard let data = documentImage.jpegData(compressionQuality: 0.50) else { return }
        showHUD()
        self.feature?.uploadDocument(data)
    }
    
}

extension DocumentUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        // print out the image size as a test
        self.documentImageView.image = image
    }
    
}

extension DocumentUploadViewController: DocumentUploadFeatureDelegate {
    
    func documentUploadSuccess() {
        hideHUD()
        let action = UIAlertController.AffirmativeAction.init(name: "OK") {
            DashboardViewController.shouldReload = true
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        showAlert(.info, title: "Registration Complete!", message: "Tap OK to continue.", affirmativeAction: action)
    }
    
    func documentUploadError(error: String) {
        hideHUD()
        showAlert(.error, message: error)
    }
    
}
