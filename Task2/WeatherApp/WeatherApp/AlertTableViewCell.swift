//
//  AlertTableViewCell.swift
//  WeatherApp
//
//  Created by Dmitry Kopats on 27.12.23.
//

import UIKit

class AlertTableViewCell: UITableViewCell {
    @IBOutlet weak var squareImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        squareImageView.image = nil
        eventNameLabel.text = ""
        startDateLabel.text = ""
        endDateLabel.text = ""
        durationLabel.text = ""
        senderNameLabel.text = ""
    }
}
