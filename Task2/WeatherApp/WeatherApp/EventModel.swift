//
//  EventModel.swift
//  WeatherApp
//
//  Created by Dmitry Kopats on 27.12.23.
//

import Foundation

struct Event: Codable {
    var id: String
    var type: String
    var properties: Alert
}

struct Events: Codable {
    var features: [Event]
}

struct Alert: Codable {
    enum CodingKeys: String, CodingKey {
        case event, senderName
        case startDate = "effective"
        case endDate = "ends"
    }
    
    var event: String
    var startDate: Date
    // for some events "ends": nil
    var endDate: Date?
    var senderName: String
    var duration: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        event = try container.decode(String.self, forKey: .event)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decodeIfPresent(Date.self, forKey: .endDate)
        senderName = try container.decode(String.self, forKey: .senderName)
        if let endDate = endDate {
            duration = startDate.distance(to: endDate).stringFromTimeInterval()
        }
    }
}

extension TimeInterval{
    func stringFromTimeInterval() -> String {
        let time = Int(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
}
