//
//  VerticalProgressbar.swift
//  Baro_user_ios
//
//  Created by . on 2020/12/12.
//

import UIKit

class VerticalProgressbar : UIView {
    private let progressView : UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.trackTintColor = UIColor.black
        progressView.progress = 0.6
        return progressView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addSubview(progressView)
        
        let height = bounds.height
        let width = bounds.width
        
        progressView.bounds.size.width = height
        progressView.bounds.size.height = width
        rotateProgressView()
    }
    
    func rotateProgressView(){
        progressView.transform = CGAffineTransform(rotationAngle: .pi * -0.5)
    }
}
