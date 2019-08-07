//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Mobile Computing on 26/09/2018.
//  Copyright © 2018 Mobile Computing. All rights reserved.
//

import UIKit
class CameraViewController: UIViewController {

    @IBOutlet weak var removeButton: UIBarButtonItem!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    
    @IBAction func cameraAction(_ sender: Any) {
        let picker = UIImagePickerController()
        

        
        picker.delegate = self
        picker.sourceType = .camera
        picker.showsCameraControls = true
        let overlayImage = UIImageView(image: UIImage(named: "overlayGrid.png"))
        
        let overlayRect = CGRect(x: 0, y: 0, width: self.view.frame.size.width , height: self.view.frame.size.height )
        
        overlayImage.frame = overlayRect
        
        picker.cameraOverlayView = overlayImage
        present(picker, animated: true, completion: nil)
        
    }
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()
    }
    
    func handlePost() {
        if selectedImage != nil {
            self.shareButton.isEnabled = true
            self.removeButton.isEnabled = true
            self.shareButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            
        } else {
            self.shareButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.shareButton.backgroundColor = .lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func shareButton_TouchUpInside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1){
            print("size \(profileImg.size)")
            let ratio = profileImg.size.width / profileImg.size.height
            HelperService.uploadDataToServer(data: imageData, ratio: ratio, caption: captionTextView.text!, onSuccess: {
                self.clean()
                //NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadUserInfo"), object: nil)
                //self.tabBarController?.selectedIndex = 0
                
            })
            
        } else {
            ProgressHUD.showError("Image can't be empty")
        }
    }
    @IBAction func send_TouchUpInside(_ sender: Any) {
        print("shareImageView_TouchUpInside")
        if let image = self.selectedImage {
          
            
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        self.present(activityController, animated: true, completion: nil)
        }else {
            ProgressHUD.showError("Image can't be empty")
        }
        
    }
    
    
    
    @IBAction func remove_TouchUpInside(_ sender: Any) {
        self.clean()
        handlePost()
    }
    
 
    func clean() {
        self.captionTextView.text = ""
        self.photo.image = UIImage(named: "placeholder-photo")
        self.selectedImage = nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filter_segue" {
            let filterVC = segue.destination as! FilterViewController
            filterVC.selectedImage = self.selectedImage
            filterVC.delegate = self
        }
    }

}

extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            selectedImage =  image
            photo.image = image
            dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "filter_segue", sender: nil)
            })
        }
        
        //dismiss(animated: true, completion: nil)
        
        
    }
}
extension CameraViewController: FilterViewControllerDelegate {
    func updatePhoto(image: UIImage) {
        self.photo.image = image
        self.selectedImage = image
    }
}
