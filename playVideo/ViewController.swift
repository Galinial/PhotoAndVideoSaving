//
//  ViewController.swift
//  playVideo
//
//  Created by gal linial on 05/01/2022.
//

import UIKit
import AVKit
import MobileCoreServices

class ViewController: UIViewController{
    var videoAndImageReview = UIImagePickerController()
    var videoURL: URL?
    
    @IBOutlet weak var btnPicture: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.backgroundColor = .secondarySystemBackground

    }
    @IBAction func didTapPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func recordActions(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{return}
    }
    
    
    @IBAction func playAct(_ sender: Any) {
        videoAndImageReview.sourceType = .savedPhotosAlbum
               videoAndImageReview.delegate = self
               videoAndImageReview.mediaTypes = ["public.movie"]
               present(videoAndImageReview, animated: true, completion: nil)
    }
    
    @IBAction func openGallery(_ sender: Any) {
        videoAndImageReview.allowsEditing = false
        videoAndImageReview.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(videoAndImageReview, animated: true, completion: nil)
    }
    
    
}
extension ViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate{

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]){
        
        dismiss(animated: true, completion: nil)
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? String,
            mediaType == (kUTTypeMovie as String),
              let url = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL,UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
        else {return}
        
       UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)),
        nil)
        }
    
    
    
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
            let title = (error == nil) ? "Success" : "Error"
            let message = (error == nil) ? "Video was saved" : "Video failed to save"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    
    func videoAndImageReview(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as? URL
            print("videoURL:\(String(describing: videoURL))")
            self.dismiss(animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                // we got back an error!
                let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            } else {
                let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       picker.dismiss(animated: true, completion: nil)
       
       if let chosenImage = info[.originalImage] as? UIImage{
           UIImageWriteToSavedPhotosAlbum(chosenImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
           imageView.image = chosenImage
       }else{
           if let imageUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
               UISaveVideoAtPathToSavedPhotosAlbum(imageUrl.path, self, #selector(video(_:didFinishSavingWithError:contextInfo:)),
                nil)

           }
    }


    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
    }

}
}
