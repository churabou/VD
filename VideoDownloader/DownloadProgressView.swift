//
//  DownloadProgressView.swift
//  VideoDownloader
//
//  Created by chutatsu on 2018/12/20.
//  Copyright © 2018 churabou. All rights reserved.
//

import UIKit

final class DownloadProgressView: UIView {
    
    private var progress = UIProgressView().apply { it in
        it.progressTintColor = .orange
    }
    
    private var label = UILabel().apply { it in
        it.text = "downloading"
        it.textColor = .white
        it.textAlignment = .center
    }
    
    private var indicator = UIActivityIndicatorView().apply { it in
        it.color = .white
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        addSubview(progress)
        addSubview(indicator)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        label.chura.layout
            .centerY(0).centerX(20)
            .width(250).height(40)
        
//        indicator.chura.layout
//            .right(label.leftAnchor).width(50)
//            .height(50).centerY(label.centerYAnchor)
        
        progress.chura.layout
            .left(40).right(-40)
            .top(label.bottomAnchor+30).height(30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateProgress(to: Float) {
        label.text = "progress in \(to)"
        progress.progress = to
    }
    
    func show() {
        indicator.stopAnimating()
        isHidden = false
    }
    
    func hide() {
        indicator.stopAnimating()
        isHidden = true
    }
}
