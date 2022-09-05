import SwiftUI
import PhotosUI
import AVFoundation
import AssetsLibrary
import UIKit

class CameraViewController: UIViewController{
    var captureSession: AVCaptureSession!
//    var myDevice : AVCaptureDevice!
    private var photoOutput: AVCapturePhotoOutput!
    private let videoHeight = 0.8
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }

        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        guard captureSession.canAddInput(videoInput) else { return }
        captureSession.addInput(videoInput)

        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else { return }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        
        captureSession.commitConfiguration()
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
        myVideoLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height*videoHeight)
        myVideoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        captureSession.startRunning()
                                            
        // UIボタンを作成.
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        myButton.backgroundColor = UIColor.red
        myButton.layer.masksToBounds = true
        myButton.setTitle("撮影", for: .normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(
            x: Int(self.view.bounds.width / 2),
            y: culcButtonY(videoAreaRatio: videoHeight, fullHeight: self.view.bounds.height)
        )
        myButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)

        // UIボタンをViewに追加.
        self.view.addSubview(myButton);
    }
    
    @objc func takePhoto(sender: UIButton) {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .auto
        settingsForMonitoring.isHighResolutionPhotoEnabled = false

        photoOutput?.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    func culcButtonY(videoAreaRatio: Double, fullHeight: Double) -> Int{
        let videoAreaHeight = fullHeight * videoAreaRatio
        let buttonAreaHeight = fullHeight - videoAreaHeight
        
        return Int(videoAreaHeight + (buttonAreaHeight/2))
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    private func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        // did receive photo data
        guard error == nil else{
            print("Error broken photo data: \(error!)")
            return
        }
        
        let imageData = photo.fileDataRepresentation()
        let photo = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(photo!, self, nil, nil)
    }
}

struct Camera: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> CameraViewController {
        return CameraViewController()
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
            
    }
}

