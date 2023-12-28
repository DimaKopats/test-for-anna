//
//  Presenter.swift
//  WeatherApp
//
//  Created by Dmitry Kopats on 27.12.23.
//

import Foundation

struct Constants {
    static let eventsUrlsString = "https://api.weather.gov/alerts/active?status=actual&message_type=alert"
    static let imageUrlString = "https://picsum.photos/1000"
}

protocol AlertsViewDelegate: NSObjectProtocol {
    func display(_ events: [Event])
}

class AlertsPresenter {
    
    weak var delegate: AlertsViewDelegate?
    
    func setViewDelegate(delegate: AlertsViewDelegate?){
        self.delegate = delegate
    }
    
    func getALerts() {
        getData(from: Constants.eventsUrlsString) { (data, response, error) in
            guard let data = data, error == nil else { return }
            self.parse(json: data)
        }
    }
    
    func getImageData(completion: @escaping (Data) -> ()) {
        getData(from: Constants.imageUrlString) { (data, response, error) in
            guard let data = data, error == nil else { return }
            completion(data)
        }
    }
    
    private func getData(from urlString: String, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let jsonEvents = try decoder.decode(Events.self, from: json)
            delegate?.display(jsonEvents.features)
        } catch let DecodingError.dataCorrupted(context) {
            debugPrint(context)
        } catch let DecodingError.keyNotFound(key, context) {
            debugPrint("Key '\(key)' not found:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            debugPrint("Value '\(value)' not found:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            debugPrint("Type '\(type)' mismatch:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch {
            debugPrint("error: ", error)
        }
    }
}
