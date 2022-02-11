//
//  CollectionViewTableViewCell.swift
//  MovieX
//
//  Created by Basem El kady on 2/10/22.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    
    //MARK: - Properties

static let identifier = "CollectionViewTableViewCell"
   
   private var titles:[Title] = [Title]()
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.idintifier)
        return collectionView
    }()
    
    
    
    
    
    //MARK: - Init
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    



//MARK: - Helper methods

func configureCellTitles(with titles:[Title]){
    self.titles = titles
    DispatchQueue.main.async {
        self.collectionView.reloadData()
    }
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
    
    
    
    
    
    
    
    
}
