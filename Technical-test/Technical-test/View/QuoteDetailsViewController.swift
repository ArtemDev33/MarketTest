//
//  QuoteDetailsViewController.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import UIKit

class QuoteDetailsViewController: UIViewController {
    
    private var quote:Quote? = nil
    
    let symbolLabel = UILabel()
    let nameLabel = UILabel()
    let lastLabel = UILabel()
    let currencyLabel = UILabel()
    let readableLastChangePercentLabel = UILabel()
    let favoriteButton = UIButton()
    
    
    
    
    init(quote:Quote) {
        super.init(nibName: nil, bundle: nil)
        self.quote = quote
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
        setupAutolayout()
        symbolLabel.text = quote?.symbol
        nameLabel.text = quote?.name
        lastLabel.text = quote?.last
        currencyLabel.text = quote?.currency
        readableLastChangePercentLabel.text = quote?.readableLastChangePercent
        
    }
    
    func addSubviews() {
        
        symbolLabel.textAlignment = .center
        symbolLabel.font = .boldSystemFont(ofSize: 40)
        
        nameLabel.textAlignment = .center
        nameLabel.font = .systemFont(ofSize: 30)
        nameLabel.textColor = .lightGray
        
        lastLabel.textAlignment = .right
        lastLabel.font = .systemFont(ofSize: 30)
        
        currencyLabel.font = .systemFont(ofSize: 15)
        
        readableLastChangePercentLabel.textAlignment = .center
        readableLastChangePercentLabel.layer.cornerRadius = 6
        readableLastChangePercentLabel.layer.masksToBounds = true
        readableLastChangePercentLabel.layer.borderWidth = 1
        readableLastChangePercentLabel.layer.borderColor = UIColor.black.cgColor
        readableLastChangePercentLabel.font = .systemFont(ofSize: 30)
        
        favoriteButton.setTitle("Add to favorites", for: .normal)
        favoriteButton.layer.cornerRadius = 6
        favoriteButton.layer.masksToBounds = true
        favoriteButton.layer.borderWidth = 3
        favoriteButton.layer.borderColor = UIColor.black.cgColor
        favoriteButton.addTarget(self, action: #selector(didPressFavoriteButton), for: .touchUpInside)
        favoriteButton.setTitleColor(.black, for: .normal)
        
        
        view.addSubview(symbolLabel)
        view.addSubview(nameLabel)
        view.addSubview(lastLabel)
        view.addSubview(currencyLabel)
        view.addSubview(readableLastChangePercentLabel)
        view.addSubview(favoriteButton)
    }
    
    
    func setupAutolayout() {
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        readableLastChangePercentLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30),
            symbolLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            symbolLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            symbolLabel.heightAnchor.constraint(equalToConstant: 44),
            
            nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 44),
            
            lastLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            lastLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            lastLabel.widthAnchor.constraint(equalToConstant: 150),
            lastLabel.heightAnchor.constraint(equalToConstant: 44),
            
            currencyLabel.topAnchor.constraint(equalTo: lastLabel.topAnchor),
            currencyLabel.leadingAnchor.constraint(equalTo: lastLabel.trailingAnchor, constant: 5),
            currencyLabel.widthAnchor.constraint(equalToConstant: 50 ),
            currencyLabel.heightAnchor.constraint(equalToConstant: 44),
            
            readableLastChangePercentLabel.topAnchor.constraint(equalTo: lastLabel.topAnchor),
            readableLastChangePercentLabel.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 5),
            readableLastChangePercentLabel.widthAnchor.constraint(equalToConstant: 150),
            readableLastChangePercentLabel.bottomAnchor.constraint(equalTo: lastLabel.bottomAnchor),
                        
            favoriteButton.topAnchor.constraint(equalTo: readableLastChangePercentLabel.bottomAnchor, constant: 30),
            favoriteButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 150),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            
        ])
    }
    
    
    @objc func didPressFavoriteButton(_ sender:UIButton!) {
        // TODO
    }
}
