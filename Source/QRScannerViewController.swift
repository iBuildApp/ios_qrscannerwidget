//
//  QRScannerViewController.swift
//  QRScannerModule
//
//  Created by  Vitaly Potlov on 26/04/2019.
//

import UIKit
import AppBuilderCore
import AppBuilderCoreUI
import AVFoundation

class QRScannerViewController: BaseViewController {
    
    // MARK: - Private properties
    /// Widget type indentifier
    private var type: String?
    
    /// Widger config data
    private var data: DataModel?
    
    // MARK: - Capture Session
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    // MARK: - Controller life cycle methods
    public convenience init(type: String?, data: DataModel?) {
        self.init()
        self.type = type
        self.data = data
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCaptureSession()
        addCloseButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    private func configureCaptureSession() {
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        }
        catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    private func failed() {
        self.showAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", buttonTitle: "OK")
        captureSession = nil
    }
    
    private func found(code: String) {

        let alertController = UIAlertController(title: "QR Code Information", message: code, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: Localization.Browser.Text.openInSafari, style: .default, handler: { _ in
            
            if URL(string: code) != nil {
                UIApplication.shared.open(URL(string: code)!)
            }
            else {
                if let qweryString = code.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), let url = URL(string: "https://www.google.com/search?q=\(qweryString)") {
                    UIApplication.shared.open(url)
                }
            }
            self.captureSession.startRunning()
        }))
        
        alertController.addAction(UIAlertAction(title: Localization.Common.Text.share, style: .default, handler: { [weak self] _ in
            let items = [code]
            let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            activityViewController.completionWithItemsHandler = { (_, _, _, _) in
                self?.captureSession.startRunning()
            }

            self?.present(activityViewController, animated: true, completion: {})
        }))
        
        alertController.addAction(UIAlertAction(title: Localization.Common.Text.cancel, style: .cancel, handler: { [weak self] _ in
            self?.captureSession.startRunning()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func addCloseButton() {
        let closeButton = UIButton(frame: .zero)
        closeButton.backgroundColor = UIColor.white
        closeButton.setTitle(Localization.Common.Text.close, for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        self.view.addSubview(closeButton)
        closeButton.anchor(top: nil, leading: nil, bottom: self.view.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0), size: CGSize(width: 100, height: 50))
        closeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        closeButton.layer.cornerRadius = 25
        closeButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc private func dismissViewController() {
        captureSession.stopRunning()
        self.dismiss(animated: true, completion: nil)
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}
