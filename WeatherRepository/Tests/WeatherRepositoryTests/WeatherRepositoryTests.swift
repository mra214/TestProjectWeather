import Foundation
import Testing
import WeatherAPI
@testable import WeatherRepository

final class UUserDefaultsCitySelectionRepositoryTests {

    @Test
    func saveAndReadCity() {
        let repository = UserDefaultsCitySelectionRepository(
            UserDefaults(suiteName: String(describing: self) + #function)!
        )
        let city = City(id: "123", name: "Test")
        repository.save(city)
        let savedCity = repository.get()
        #expect(city == savedCity)
    }
    
    @Test
    func resetCity() {
        let repository = UserDefaultsCitySelectionRepository(
            UserDefaults(suiteName: String(describing: self) + #function)!
        )
        let city = City(id: "123", name: "Test")
        repository.save(city)
        repository.clear()
        let savedCity = repository.get()
        #expect(savedCity == nil)
    }
}
