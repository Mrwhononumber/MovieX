//
//  HeroHeaderUIView.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class HeroHeaderUIView: UIView {
    
   private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "HeroImage")
        return imageView
        
    }()
    
    private let playButton: UIButton = {
        
       let button = UIButton()
      button.setTitle("Play", for: .normal)
      button.layer.borderColor = UIColor.white.cgColor
      button.layer.borderWidth = 1
      button.layer.cornerRadius = 5
      button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
        
    }()
    
    private let downloadButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        
        applyConstraints()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    private func addGradient() {
        let gradienLayer = CAGradientLayer()
        gradienLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradienLayer.frame = bounds
        layer.addSublayer(gradienLayer)
        
    }
    
    func applyConstraints(){
       
        let playButtonConstraints = [
            // Play Button 
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
            playButton.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 110),
            // Download Button
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
       
        
        
        
    }
    
    
    
}
