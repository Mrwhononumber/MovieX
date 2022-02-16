//
//  TitleTableViewCell.swift
//  MovieX
//
//  Created by Basem El kady on 2/12/22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let idintifier = "TitleTableViewCell"
 
     let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titlePoster: UIImageView = {
        let poster = UIImageView()
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        return poster
    }()
    
  //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePoster)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton )
        configureContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper functions
    
    func configureContraints(){
        
        let titlePosterConstraints = [
            titlePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            titlePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9),
            titlePoster.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePoster.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: playTitleButton.leadingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    
    func configure(with title:Title) {
        guard title.poster_path != nil else {return}
        let posterURL = Constants.imageBaseURL+title.poster_path!
        APICaller.shared.fetchTitleImage(url: posterURL) { result in
            switch result {
            case .success(let posterImage):
                self.titlePoster.image = posterImage
            case .failure(let error):
                print (error)
            }
        }
        
        self.titleLabel.text = title.original_title ?? title.original_name ?? "unknown"
        
    }
    
    

}
