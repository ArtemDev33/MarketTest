//
//  QuoteTableViewCell.swift
//  Technical-test
//
//  Created by Артем Гавриленко on 12.02.2023.
//

import UIKit

// MARK: - Delegate

protocol QuoteTableViewCellDelegate: AnyObject {
    
    func quoteCelldidTapLikeButton(_ cell: QuoteTableViewCell, _ quote: Quote)
}

final class QuoteTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var percentageLabel: UILabel!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    var quote: Quote? {
        didSet {
            guard let quote = quote else { return }
            let viewModel = ViewModel(quote: quote)
            configure(with: viewModel)
        }
    }
    
    weak var delegate: QuoteTableViewCellDelegate?
    
    static let identifier: String = "QuoteTableViewCell"
    static func nib() -> UINib {
        UINib(nibName: "QuoteTableViewCell", bundle: nil)
    }
    
    @IBAction private func didTapFavouriteButton(_ sender: UIButton) {
        if let quote = quote {
            delegate?.quoteCelldidTapLikeButton(self, quote)
        }
    }
    
    private func configure(with viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        percentageLabel.text = viewModel.percentage
        percentageLabel.textColor = viewModel.percentageColor
        
        let imageTitle = viewModel.isFavourite ? "favorite" : "no-favorite"
        favouriteButton.setImage(UIImage(named: imageTitle)!, for: .normal)
        favouriteButton.setTitle("", for: .normal)
    }
}

// MARK: - ViewModel

extension QuoteTableViewCell {
    
    struct ViewModel {
        
        let title: String
        let description: String
        let percentage: String
        let percentageColor: UIColor
        let isFavourite: Bool
        
        init(quote: Quote) {
            self.title = quote.name ?? ""
            let currency = quote.currency ?? ""
            self.description = (quote.last ?? "") + (currency.isEmpty ? "" : " \(currency)")
            self.percentage = quote.readableLastChangePercent ?? ""
            
            if quote.variationColor == "red" {
                percentageColor = .red
            } else if quote.variationColor == "green" {
                percentageColor = .green
            } else {
                percentageColor = .black
            }
            
            self.isFavourite = quote.isFavourite ?? false
        }
    }
}
