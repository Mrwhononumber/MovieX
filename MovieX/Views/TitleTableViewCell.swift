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
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.clipsToBounds = true
        return label
    }()
    
    private let titlePoster: UIImageView = {
        let poster = UIImageView()
        poster.translatesAutoresizingMaskIntoConstraints = false
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        return poster
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let myView = UIActivityIndicatorView()
        myView.hidesWhenStopped = true
        myView.style = .medium
        myView.color = .systemPink
        myView.startAnimating()
        return myView
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = titlePoster.center
    }
    
    //MARK: - Helper functions
    
    private func configureUI(){
        contentView.addSubview(titlePoster)
        contentView.addSubview(titleLabel)
        titlePoster.addSubview(activityIndicatorView)
    }
    
    private func configureContraints(){
        
        let titlePosterConstraints = [
            titlePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
            titlePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9),
            titlePoster.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePoster.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
    
    
    public func configure(with title:Title) {
        guard title.poster_path != nil else {return}
        let posterURL = Constants.imageBaseURL+title.poster_path!
        APICaller.shared.fetchTitleImage(url: posterURL) { [weak self] result in
            switch result {
            case .success(let posterImage):
                self?.titlePoster.alpha = 0
                self?.titlePoster.image = posterImage
                self!.animateImageToFadeIn(source: self!.titlePoster, duration: 0.5)
                self?.activityIndicatorView.stopAnimating()
            case .failure(let error):
                print (error)
            }
        }
        self.titleLabel.text = title.original_title ?? title.original_name ?? "unknown"
    }
    
    private func animateImageToFadeIn(source: UIView, duration: TimeInterval){
        UIView.animate(withDuration: duration) {
            self.titlePoster.alpha = 1
        }
    }
}
