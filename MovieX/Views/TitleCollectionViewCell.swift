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
    }
    
    //MARK: - Helper Methods
    
    func configureUI(){
        contentView.addSubview(posterImageView)
    }
    
    func configureImage(with url: String) {
       let ImageURL = Constants.imageBaseURL+url
        APICaller.shared.fetchTitleImage(url: ImageURL) { [weak self] result in
            switch result {
            case .success(let downloadedImage):
                self?.posterImageView.image = downloadedImage
                
            case .failure(let error):
                print (error.rawValue)
            }
        }
    }
}
