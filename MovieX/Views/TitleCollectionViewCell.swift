//
//  TitleCollectionViewCell.swift
//  MovieX
//
//  Created by Basem El kady on 2/11/22.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let idintifier = "TitleCollectionViewCell"
  
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let imageIndicatorView: UIActivityIndicatorView = {
        let myView = UIActivityIndicatorView()
        myView.hidesWhenStopped = true
        myView.style = .medium
        myView.color = .systemPink
        myView.startAnimating()
        return myView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        posterImageView.frame = contentView.bounds
        imageIndicatorView.center = contentView.center
    }
    
    //MARK: - Helper Methods
    
    func configureUI(){
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(imageIndicatorView)
    }
    
    func configureImage(with url: String) {
        let ImageURL = Constants.imageBaseURL+url
        APICaller.shared.fetchTitleImage(url: ImageURL) { [weak self] result in
            switch result {
            case .success(let downloadedImage):
                self?.posterImageView.alpha = 0
                self?.posterImageView.image = downloadedImage
                self!.fadeImageIn(source: self!.posterImageView, duration: 0.5)
                self?.imageIndicatorView.stopAnimating()
                
            case .failure(let error):
                print (error.rawValue)
            }
        }
    }
    
    func fadeImageIn(source: UIView, duration: TimeInterval){
        UIView.animate(withDuration: duration) {
            self.posterImageView.alpha = 1
        }
    }
}
