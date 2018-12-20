//
//  DownloadController.swift
//  VideoDownloader
//
//  Created by ちゅーたつ on 2018/12/19.
//  Copyright © 2018年 churabou. All rights reserved.
//

import UIKit
import AVFoundation

final class DownloadController: UIViewController {
    
    private lazy var toolBar: UIToolbar = {
        let t = UIToolbar()
        let backButton = UIBarButtonItem(barButtonSystemItem: .rewind, target: self, action: #selector(actionBack))
        let nextButton = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(actionNext))
        t.items = [backButton, nextButton]
        return t
    }()
    
    @objc private func actionBack() {
        webView.goBack()
    }
    
    @objc private func actionNext() {
        webView.goForward()
    }
    
    private let webView = UIWebView()
    
    override func viewDidLoad() {
        
//        let url = "https://www.youtube.com/watch?v=wS8VUKFQdTk&feature=youtu.be"
        let url = "https://www.google.com"
        webView.loadRequest(URLRequest(url: URL(string: url)!))
        view.addSubview(webView)
        
        downloadButton.setTitle("download", for: .normal)
        downloadButton.layer.cornerRadius = 5
        downloadButton.addTarget(self, action: #selector(actionDownload), for: .touchUpInside)
        downloadButton.isEnabled = false
        downloadButton.alpha = 0.7
        downloadButton.backgroundColor = .orange
        view.addSubview(downloadButton)
        
        
        
        loadingLabel.frame = view.bounds
        view.addSubview(loadingLabel)
        loadingLabel.hide()
        
        
        view.addSubview(toolBar)

        webView.chura.layout
            .left(0).top(view.safeAreaLayoutGuide.topAnchor)
            .right(0).bottom(anchor: toolBar.topAnchor, offSet: -5)
        
        
        toolBar.chura.layout
            .left(0).right(0)
            .height(50).bottom(anchor: downloadButton.topAnchor, offSet: -5)
        
        
        downloadButton.chura
            .layout.left(5).right(-5)
            .bottom(view.safeAreaLayoutGuide.bottomAnchor).height(50)

    }
    
    private let downloadButton = UIButton()
    private var loadingLabel = DownloadProgressView()
    
    @objc private func actionDownload() {
        loadingLabel.isHidden = false
        DonwLoader.shared.download(url: downloadUrl!)
        DonwLoader.shared.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemBecameCurrent), name: NSNotification.Name(rawValue: "AVPlayerItemBecameCurrentNotification"),
                                               object:nil)
    }
    
    private var downloadUrl: String? {
        didSet {
            downloadButton.isEnabled = downloadUrl != nil
            downloadButton.alpha = downloadButton.isEnabled ? 1 : 0.4
        }
    }
    
    @objc func playerItemBecameCurrent(notification:NSNotification){
        
        guard let playerItem: AVPlayerItem = notification.object as? AVPlayerItem,
            let asset: AVURLAsset=playerItem.asset as? AVURLAsset else {
                return
        }
        let path = asset.url.absoluteString
        print("get video url: \(path)")
        downloadUrl = path
    }
}

extension DownloadController: DonwLoaderDelegate {
    
    func updateProgress(to: Float) {
        loadingLabel.updateProgress(to: to)
    }
    
    func sucess(location: URL) {
        let data = try! Data(contentsOf: location)
        let path = NSHomeDirectory() + "/Documents/\(UUID().uuidString).mp4"
        try! data.write(to: URL(fileURLWithPath: path))
        
        DispatchQueue.main.async {
            self.loadingLabel.hide()
            self.downloadUrl = nil
        }
        
    }
    
    func failed() {
        
    }
}




protocol ApplySwift {}

extension ApplySwift {
    func apply(closure: (Self) -> Swift.Void) -> Self {
        closure(self)
        return self
    }
}

extension NSObject: ApplySwift { }

