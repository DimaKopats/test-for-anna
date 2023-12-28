//
//  ViewController.swift
//  WeatherApp
//
//  Created by Dmitry Kopats on 27.12.23.
//

//Create a single screen iOS weather alerts app.
//The screen displays all the current active US alerts in a scrollable list:
//you can obtain the data by performing a GET request to
//https://api.weather.gov/alerts/active?status=actual&message_type=alert
//more official documentation is available at
//https://www.weather.gov/documentation/services-web-api#/default/get_alerts_active
//each cell should contain the following details of an alert:
//event name "event", start date "effective", end date "ends", source "senderName" & duration (start date - end date)
//a unique random image obtain by a GET to https://picsum.photos/1000
//each cell must show a different image, but keep showing its original image when you scroll back to it
//You can use any external libraries to help with network requests, JSON processing, etc.

import UIKit

struct Colors {
    static let peachColor = UIColor(red: 255/255, green: 229/255, blue: 204/255, alpha: 1)
    static let mintColor = UIColor(red: 204/255, green: 255/255, blue: 229/255, alpha: 1)
}

class AlertsTableViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter = AlertsPresenter()
    
    // we don’t have a specific link for each image, so we can’t cache it
    // and store it directly as UIImage (which is not the best approach)
    private var images = [UIImage]()
    private var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        presenter.setViewDelegate(delegate: self)
        presenter.getALerts()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        218
    }
}

extension AlertsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alertData = events[indexPath.row].properties
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                       for: indexPath) as? AlertTableViewCell else { return UITableViewCell() }
        
        if images.count <= indexPath.row {
            cell.squareImageView.image = UIImage(named: "previewImage")
            presenter.getImageData { data in
                guard let image = UIImage(data: data) else { return }
                self.images.append(image)
                DispatchQueue.main.async {
                        cell.squareImageView.image = image
                }
            }
        } else {
            cell.squareImageView.image = images[indexPath.row]
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY MMM d, HH:mm:ss"
        
        cell.eventNameLabel.text = alertData.event
        cell.startDateLabel.text = dateFormatter.string(from: alertData.startDate)
        cell.durationLabel.text = alertData.duration
        cell.senderNameLabel.text = alertData.senderName
        
        if let endDate = alertData.endDate {
            cell.endDateLabel.text = dateFormatter.string(from: endDate)
        }
        
        cell.backgroundColor = indexPath.row % 2 == 0 ? Colors.peachColor : Colors.mintColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
}

extension AlertsTableViewController: AlertsViewDelegate {
    func display(_ events: [Event]) {
        self.events = events
        DispatchQueue.main.async() { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
