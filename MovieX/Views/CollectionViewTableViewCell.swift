//
//  CollectionViewTableViewCell.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    
    func CollectionViewTableViewCellDidGetTapped(_cell: CollectionViewTableViewCell, title: Title)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    
    //MARK: - Properties
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles:[Title] = [Title]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.idintifier)
        return collectionView
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    //MARK: - Helper methods
    
    public func configureCellTitles(with titles:[Title]){
        DispatchQueue.main.async { [weak self] in
            self?.titles = titles
            self?.collectionView.reloadData()
        }
    }
    private func configureUI(){
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
    }
    
    private func configureCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}
//MARK: - CollectionView Implementation

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.idintifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let posterURL = titles[indexPath.row].poster_path  {
            
            cell.configureImage(with: posterURL)
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedTitle = titles[indexPath.row]
        delegate?.CollectionViewTableViewCellDidGetTapped(_cell: self, title: selectedTitle)
    }
}
