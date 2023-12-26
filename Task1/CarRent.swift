import Foundation

// Basic program that calculates a statement of a customer's charges at a car rental store.
//
// A customer can have multiple "Rental"s and a "Rental" has one "Car"
// As an ASCII class diagram:
//          Customer 1 ----> * Rental
//          Rental   * ----> 1 Car
//
// The charges depend on how long the car is rented and the type of the car (economy, muscle or supercar)
//
// The program also calculates frequent renter points.
//
//
// Refactor this class how you would see it.
//
// The actual code is not that important, as much as its structure. You can even use "magic" functions (e.g. foo.sort()) if you want

enum CarType: Int {
    case economy
    case supercar
    case muscle
}

struct Car {
    private(set) var title: String
    private(set) var carType: CarType
}

struct Rental {
    private(set) var car: Car
    private let daysRented: Int
    var rentalCost: Double { calculateRentalCost() }
    var frequentRenterPoints: Int { calculateFrequentRenterPoints() }
    
    init(car: Car, daysRented: Int) {
        self.car = car
        self.daysRented = daysRented
    }
    
    private func calculateRentalCost() -> Double {
        var cost: Double = 0
        
        // the rental price depends on the type of car rented
        switch car.carType {
        case .economy:
            cost += 80
            if (daysRented > 2) {
                cost += (Double(daysRented - 2)) * 30.0
            }
        case .supercar:
            cost += Double(daysRented) * 200.0
        case .muscle:
            cost += 200
            if (daysRented > 3) {
                cost += (Double(daysRented - 3)) * 50.0
            }
        }
        return cost
    }
    
    private func calculateFrequentRenterPoints() -> Int {
        // regular frequent renter points
        var frequentRenterPoints = 1
        // add bonus for a two day new release rental
        if (car.carType == .supercar && daysRented > 1) {
            frequentRenterPoints += 1
        }
        return frequentRenterPoints
    }
}

struct Customer {
    private let name: String
    private var rentals = [Rental]()
    private var totalRentalPayment: Double = 0
    private var frequentRenterPoints: Int = 0
    
    init(name: String) {
        self.name = name
    }
    
    mutating func add(rental: Rental) {
        rentals.append(rental)
        totalRentalPayment += rental.rentalCost
        frequentRenterPoints += rental.frequentRenterPoints
    }
    
    func billingStatement() -> String {
        var result = "Rental Record for \(name) \n"
        
        for rental in rentals {
            // show figures for this rental
            result += "\t" + rental.car.title + "\t" + String(rental.rentalCost) + "\n"
        }
        
        // add footer lines
        result += "Final rental payment owed " + String(totalRentalPayment) + "\n"
        result += "You received an additional " + String(frequentRenterPoints) + " frequent customer points"
        
        return result
    }
}

let rental1 = Rental(car: Car(title: "Mustang", carType: .muscle), daysRented: 5)
let rental2 = Rental(car: Car(title: "Lambo", carType: .supercar), daysRented: 20)
var customer = Customer(name: "Dmitry")
customer.add(rental: rental1)
customer.add(rental: rental2)

print(customer.billingStatement())
