//
//  VideoListCell.swift
//  VideoDownloader
//
//  Created by ちゅーたつ on 2018/11/14.
//  Copyright © 2018年 churabou. All rights reserved.
//
import UIKit

final class VideoListCell: BaseTableViewCell {
    
    static let height: CGFloat = 62
    
    private var thumbnailView = UIImageView().apply { it in
        it.layer.cornerRadius = 2
        it.clipsToBounds = true
        it.layer.backgroundColor = UIColor.blue.cgColor
    }
    
    private var nameLabel = UILabel().apply { it in
        it.textAlignment = .left
    }
    
    private var dateLabel = UILabel().apply { it in
        it.textAlignment = .right
        it.font = .systemFont(ofSize: 12)
    }
    
    private var sizeLabel = UILabel().apply { it in
        it.textAlignment = .right
        it.font = .systemFont(ofSize: 14)
    }
    
    override func initializeView() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(sizeLabel)
    }
    
    override func initializeConstraints() {
        
        thumbnailView.chura.layout
            .width(60).height(60)
            .centerY(0).left(10)
        
        nameLabel.chura.layout
            .top(10).height(20)
            .left(thumbnailView.rightAnchor + 20).right(-10)
        
        dateLabel.chura.layout
            .bottom(-10).height(20)
            .left(thumbnailView.rightAnchor+10).right(sizeLabel.leftAnchor-10)
        
        sizeLabel.chura.layout
            .bottom(-10).height(20)
            .right(-10).width(60)
    }
    
    func configure(video: VideoData) {
        
        DispatchQueue.global(qos: .default).async {
            let image = video.getThumbnail()
            DispatchQueue.main.sync {
                self.thumbnailView.image = image
            }
        }
        nameLabel.text = video.filePath
//        sizeLabel.text = video.data?.mbString
//        dateLabel.text = video.createdAt.dateString
    }
}


// TODO: extension
private extension Data {
    
    var mbString: String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        return bcf.string(fromByteCount: Int64(count))
    }
}

private extension Date {
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMdkHms ",
                                                        options: 0,
                                                        locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: self)
    }
}

import AVFoundation

private extension VideoData {
    
    func getThumbnail() -> UIImage? {
        let fileURL: URL = URL(fileURLWithPath: filePath)
        do {
            let asset = AVURLAsset(url: fileURL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: .zero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch let error {
            return nil
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
    }
}

struct VideoData {
    var filePath: String
    
    var data: Data? {
        return try? Data(contentsOf: URL(fileURLWithPath: filePath))
    }
}
