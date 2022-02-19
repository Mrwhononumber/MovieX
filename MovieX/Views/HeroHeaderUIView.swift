//
//  HeroHeaderUIView.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    //MARK: - Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
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
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradient()
        configureUI()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    //MARK: - Helper Methods
    
    func configureUI(){
        addSubview(imageView)
        addSubview(playButton)
        addSubview(downloadButton)
    }
    
    
    func configure(with title:Title){
        guard let titleURL = title.poster_path else {return}
        APICaller.shared.fetchTitleImage(url:Constants.imageBaseURL+titleURL) {[weak self] results in
            switch results {
            case .success(let heroImage):
                self?.imageView.image = heroImage
                
            case .failure(let error):
                print(error)
            }
        }
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
    
    func configureConstraints(){
       
        let playButtonConstraints     = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 75),
            playButton.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 110)]
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -75),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
}
