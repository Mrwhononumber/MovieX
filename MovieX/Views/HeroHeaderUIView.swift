//
//  HeroHeaderUIView.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

protocol HeroHeaderUIViewDelegate: AnyObject {
    func didTapTrailerButton(title:Title, videoID: String)
    
}

class HeroHeaderUIView: UIView {
    
    //MARK: - Properties
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.alpha = 0.8
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trailerButton: UIButton = {
        
       let button = UIButton()
      button.setTitle("Trailer", for: .normal)
      button.layer.borderColor = UIColor.white.cgColor
      button.layer.borderWidth = 1
      button.layer.cornerRadius = 5
      button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: HeroHeaderUIViewDelegate?
    
    private var HeroTitle: Title?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureConstraints()
        configureButtonsActions()
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    //MARK: - Helper Methods
    
    func configureUI(){
        addSubview(heroImageView)
        addSubview(trailerButton)
    }
    
    func configureHeroView(with title:Title){
        guard let titleURL = title.poster_path else {return}
        HeroTitle = title
        APICaller.shared.fetchTitleImage(url:Constants.imageBaseURL+titleURL) {[weak self] results in
            switch results {
            case .success(let heroImage):
                self?.heroImageView.image = heroImage
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        heroImageView.layer.addSublayer(gradientLayer)
//        layer.addSublayer(gradientLayer)
    }
    
    func configureConstraints(){
       
        let playButtonConstraints     = [
            trailerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            trailerButton.bottomAnchor.constraint(equalTo:  bottomAnchor, constant: -50),
            trailerButton.widthAnchor.constraint(equalToConstant: 110)]
        
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    //MARK: - Buttons Actions
    
    private func configureButtonsActions(){
        
        trailerButton.addTarget(self, action: #selector(trailerButtonAction), for: .touchUpInside)
    }
    
    @objc private func trailerButtonAction(){
        guard HeroTitle != nil else {return}
        APICaller.shared.getYoutubeTrailerIdWith(query: HeroTitle?.original_name ?? HeroTitle?.original_title ?? "", url: Constants.youtubeSearchBaseURL) { [weak self] results  in
            switch results {
            case .success(let trailerID):
                DispatchQueue.main.async {
                    self?.delegate?.didTapTrailerButton(title: (self?.HeroTitle!)!, videoID: trailerID)
                }
                
            case .failure(let error):
                self?.delegate?.didTapTrailerButton(title: (self?.HeroTitle!)!, videoID: "")
                print(error)
            }
        }
    }
}
