//
//  scheduler.swift
//  Schedule
//
//  Created by Michael Pohily on 23.02.2021.
//

import Foundation

extension URL {
    init(_ string: StaticString) {
        self.init(string: "\(string)")!
    }
}

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }
}

class Scheduler {
    var home: Bool = true
        
    let URLS: [String: StaticString] = [
        "bus_babka": "https://yandex.ru/maps/213/moscow/stops/stop__9641561/?ll=37.652162%2C55.871319&z=17.96",
        "tram": "https://yandex.ru/maps/213/moscow/stops/stop__9642452/?ll=37.652162%2C55.871319&z=17.96",
        "otradnoe": "https://yandex.ru/maps/213/moscow/stops/stop__9641574/?ll=37.652162%2C55.871319&z=17.96",
        "altufan": "https://yandex.ru/maps/213/moscow/stops/stop__9641574/?ll=37.652162%2C55.871319&z=17.96",
        "avt_649": "https://yandex.ru/maps/213/moscow/stops/stop__9711575/?ll=37.652712%2C55.871607&z=18.22",
        "tram_medvedkovo": "https://yandex.ru/maps/213/moscow/stops/stop__9642473/?ll=37.652712%2C55.871607&z=18",
        "iz_otradnogo": "https://yandex.ru/maps/213/moscow/stops/group__461/?ll=37.607256%2C55.863834&z=18.5"
    ]
    
    let TIME_DELTAS = [
        // время от квартиры до остановки
        "bus_babka": 5,
        "tram": 5,
        "otradnoe": 4,
        "avt_649": 3,
        "tram_medvedkovo": 5,
        "altufan": 4,
        "iz_otradnogo": 0,
        "": 0
    ]
    
    let DESTINATION = [
        "bus_babka": "До Бабушкинской:\n\n",
        "tram": "До Бабушкинской:\n\n",
        "otradnoe": "До Отрадного:\n\n",
        "avt_649": "До Бабушкинской:\n\n",
        "tram_medvedkovo": "До Медведково:\n\n",
        "altufan": "До Алтуфьево:\n\n",
        "iz_otradnogo": "Из Отрадного:\n\n",
        "": "Пока не едет"
    ]
    
    func on_time(data: (Int, String, String)) -> Bool {
        var delta = 0
        if home {
            delta = TIME_DELTAS[data.2]!
        }
        if data.0 - delta >= 0 {
            return true
        } else {
            return false
        }
    }
    
    func print_schedule(data: Array<(Int, String, String)>) -> String {
        // время от остановки до места назначения
        var delay: Int = 0
        var result: Array<(Int, Int, String, String)> = []
        for line in data {
            if on_time(data: line) {
                if (line.1 == "17" && line.2 == "tram_medvedkovo") {
                    delay = 13
                } else if (line.1 == "17" && line.2 == "tram") {
                    delay = 4
                } else if (line.1 == "605" || line.1 == "880") && (line.2 == "otradnoe" || line.2 == "iz_otradnogo") {
                    delay = 18
                } else if line.1 == "649" {
                    delay = 7
                } else if (line.1 == "928" && line.2 == "altufan") {
                    delay = 25
                } else {
                    delay = 5
                }
                // до метро: 0, через: 1, маршрут: 2, key: 3
                result.append((line.0 + delay, line.0, line.1, line.2))
            }
        }
        var result_text: String = "Пока не едет"
        if result.count != 0 {
            result_text = DESTINATION[result.last!.3]!
            for line in result.sorted(by: { $0.0 < $1.0 }) {
                if (line.2 != "Пока не едет" && line.2 != "") {
                    result_text += "\(line.2) через \(line.1), доедет через - \(line.0)\n"
                }
            }
        }
        return result_text
    }
    
    func schedule(key: String, good: Array<String>) -> Array<(Int, String, String)> {
        let url = URLS[key]!
        
        // возвращает для конкретной остановки key массив кортежей: 0: время, 1: маршрут, 2: key
        
        func matches(for regex: String, in text: String) -> [String] {
            // возвращает массив подстрок по регулярке из текста
            do {
                let regex = try NSRegularExpression(pattern: regex)
                let results = regex.matches(in: text,
                                            range: NSRange(text.startIndex..., in: text))
                return results.map {
                    String(text[Range($0.range(at: 1), in: text)!])
                }
            } catch let error {
                print("invalid regex: \(error.localizedDescription)")
                return []
            }
        }
        
        // маршруты
        let content = try! NSString(contentsOf: URL(url), encoding: String.Encoding.utf8.rawValue)
        let regex = "<ul class=\"masstransit-brief-schedule-view__vehicles\">(.*?)</ul>"
        let roots: Array<String> = matches(for: regex, in: content as String)
        var merged: Array<(String, String)> = []
        for root in roots {
            let transp_num = matches(for: " (\\d*?) в", in: root as String)
            let time = matches(for: "<span class=\"masstransit-prognoses-view__title-text\">(\\d+?) мин</span>", in: root as String)
            merged = zip(time, transp_num).compactMap { ($0, $1) }
            }
        var result: Array<(Int, String, String)> = []
        for each in merged{
            if good.contains(each.1) {
                result.append((Int(each.0) ?? 0, each.1, key))
            }
        }
        if result.count == 0 {
            return [(0, "", "")]
        } else {
            return result
        }
    }
    
    
    // MARK - массив
    func bus_babka() -> Array<(Int, String, String)> {
        let good_to_babka = ["124", "174", "238", "309", "880", "928", "С15"]
        return self.schedule(key: "bus_babka", good: good_to_babka)
    }

    func tram() -> Array<(Int, String, String)> {
        let good = ["17"]
        return self.schedule(key: "tram", good: good)
    }

    func avt_649() -> Array<(Int, String, String)> {
        let good = ["649"]
        return self.schedule(key: "avt_649", good: good)
    }

    // MARK - расписание
    func metro() -> String {
        var result: Array<(Int, String, String)> = self.avt_649()
        result += self.tram()
        result += self.bus_babka()
        return self.print_schedule(data: result)
    }
    
    func otradnoe() -> String {
        let good_to_otradnoe = ["605", "880"]
        return self.print_schedule(data: self.schedule(key: "otradnoe", good: good_to_otradnoe))
    }

    func altufan() -> String {
        let good = ["928"]
        return self.print_schedule(data: self.schedule(key: "altufan", good: good))
    }
    
    func tram_medvedkovo() -> String {
        let good = ["17"]
        return self.print_schedule(data: self.schedule(key: "tram_medvedkovo", good: good))
    }
    
    func tram_ostankino() -> String {
        let good = ["17"]
        return self.print_schedule(data: self.schedule(key: "tram", good: good))
    }
    
    func iz_otradnogo() -> String {
        let good = ["605", "880"]
        return self.print_schedule(data: self.schedule(key: "iz_otradnogo", good: good))
    }
}
