//
//  TitleCollectionViewCell.swift
//  MovieX
//
//  Created by Basem El kady on 2/11/22.
//

import UIKit

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let idintifier = "TitleCollectionViewCell"
  
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        posterImageView.frame = contentView.bounds
    }
    
    func configureImage(with url: String) {
       let ImageURL = Constants.imageBaseURL+url
        APICaller.shared.fetchTitleImage(url: ImageURL) { result in
            switch result {
            case .success(let downloadedImage):
                self.posterImageView.image = downloadedImage
                
            case .failure(let error):
                print (error.rawValue)
                
            }
        }
    }
}
