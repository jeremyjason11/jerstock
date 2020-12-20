//
//  TableViewCell.swift
//  Jestock
//
//  Created by Jeremy Jason on 19/12/20.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var symbolValue: UILabel!
    @IBOutlet weak var openValue: UILabel!
    @IBOutlet weak var lowValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func commonInit(stock: StockQuote) {
        symbolValue.text = stock.symbol
        openValue.text = stock.open
        lowValue.text = stock.low
    }
    
}
