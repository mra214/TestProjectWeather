//
//  WeatherAPIComClient.swift
//  WeatherApp
//
//  Created by Rauf Mehdiyev on 1/27/25.
//
import Foundation
import WeatherAPI

public enum WeatherAPIComError: Error {
    case invalidStatusCode
    case api(WeatherApiCom.Error)
    case unknown(Error)
}

public final class WeatherAPIComClient: Sendable {
    
    private let baseUrl: String = "https://api.weatherapi.com/v1/"
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func currentWeather(
        _ query: String,
        lang: WeatherApiCom.Language? = nil
    ) async throws -> WeatherApiCom.CurrentWeather? {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let langParam = lang == nil ? "" : "&\(lang!.queryStringParameter)"
        
        let request = URLRequest(
            url: URL(
                string: "\(baseUrl)current.json?key=\(apiKey)&q=\(escapedQuery)\(langParam)"
            )!
        )
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw WeatherAPIComError.invalidStatusCode
            }
            
            if statusCode == 200 {
                return try JSONDecoder().decode(WeatherApiCom.CurrentWeather.self, from: data)
            }
            
            let error = try JSONDecoder().decode(WeatherApiCom.Error.self, from: data)
            
            if [400,401,403].contains(statusCode) {
                switch error.code {
                case 1006: // No location found matching parameter 'q'
                    return nil
                default:
                    throw WeatherAPIComError.api(error)
                }
            } else {
                throw WeatherAPIComError.api(error)
            }
        } catch let error as WeatherAPIComError {
            throw error
        } catch {
            throw WeatherAPIComError.unknown(error)
        }
    }
    
    public func search(
        _ query: String
    ) async throws -> [WeatherApiCom.Location] {
        let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let request = URLRequest(
            url: URL(
                string: "\(baseUrl)search.json?key=\(apiKey)&q=\(escapedQuery)"
            )!
        )
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw WeatherAPIComError.invalidStatusCode
            }
            
            if statusCode == 200 {
                return try JSONDecoder().decode([WeatherApiCom.Location].self, from: data)
            }
            
            let error = try JSONDecoder().decode(WeatherApiCom.Error.self, from: data)
            
            if [400,401,403].contains(statusCode) {
                switch error.code {
                case 1006: // No location found matching parameter 'q'
                    return []
                default:
                    throw WeatherAPIComError.api(error)
                }
            } else {
                throw WeatherAPIComError.api(error)
            }
        } catch let error as WeatherAPIComError {
            throw error
        } catch {
            throw WeatherAPIComError.unknown(error)
        }
    }
}

public enum WeatherApiCom {
    
    public enum Language: String, Codable {
        case arabic = "ar"
        case bengali = "bn"
        case bulgarian = "bg"
        case chineseSimplified = "zh"
        case chineseTraditional = "zh_tw"
        case czech = "cs"
        case danish = "da"
        case dutch = "nl"
        case finnish = "fi"
        case french = "fr"
        case german = "de"
        case greek = "el"
        case hindi = "hi"
        case hungarian = "hu"
        case italian = "it"
        case japanese = "ja"
        case javanese = "jv"
        case korean = "ko"
        case mandarin = "zh_cmn"
        case marathi = "mr"
        case polish = "pl"
        case portuguese = "pt"
        case punjabi = "pa"
        case romanian = "ro"
        case russian = "ru"
        case serbian = "sr"
        case sinhalese = "si"
        case slovak = "sk"
        case spanish = "es"
        case swedish = "sv"
        case tamil = "ta"
        case telugu = "te"
        case turkish = "tr"
        case ukrainian = "uk"
        case urdu = "ur"
        case vietnamese = "vi"
        case wuShanghainese = "zh_wuu"
        case xiang = "zh_hsn"
        case cantonese = "zh_yue"
        case zulu = "zu"
    }
    
    public struct Error: Decodable, Sendable {
        let code: Int
        let message: String
    }
    
    public struct CurrentWeather: Decodable, Sendable {
        let location: Location
        let current: WeatherData
    }
    
    public struct Location: Decodable, Sendable {
        public let name: String
        public let region: String
        public let country: String
        public let lat: Double
        public let lon: Double
    }

    public struct WeatherData: Decodable, Sendable {
        public let temp_c: Double
        public let temp_f: Double
        public let feelslike_c: Double
        public let feelslike_f: Double
        public let uv: Double
        public let humidity: Double
        public let condition: WeatherApiCom.WeatherCondition
    }

    public struct WeatherCondition: Decodable, Sendable {
        public let text: String
        public let icon: String
        public let code: Int
    }
}

extension WeatherApiCom.WeatherCondition {
    enum CodingKeys: String, CodingKey {
        case text, icon, code
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        text = try container.decode(String.self, forKey: .text)
        code = try container.decode(Int.self, forKey: .code)
        let icon = try container.decode(String.self, forKey: .icon)
        self.icon = icon.hasPrefix("//") ? "https:" + icon : icon
    }
}

extension WeatherApiCom.Language {
    internal var queryStringParameter: String {
        "lang=\(rawValue)"
    }
}
