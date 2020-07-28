//
//  MainWidget.swift
//  MainWidget
//
//  Created by 曹宇明 on 2020/7/27.
//

import WidgetKit
import SwiftUI
import Intents

enum DataError: Error {
    case NotFound
    case IsNil
}

struct Commit {
    let message: String
}

struct CommitLoader {
    static func fetch(completion: @escaping (Result<Commit, DataError>) -> Void) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        if userdate != nil {
            let commit = Commit(message: timeBetweenDate(toDate: userdate as! Date))
            completion(.success(commit))
        } else {
            completion(.failure(DataError.NotFound))
        }
    }
}

struct Provider: TimelineProvider {
    public typealias Entry = SimpleEntry
        
    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        if userdate != nil {
            let commit = Commit(message: timeBetweenDate(toDate: userdate as! Date))
            completion(SimpleEntry(date: Date(),commit: commit, useDate: Date()))
        } else {
            let fakeCommit = Commit(message: "Test")
            completion(SimpleEntry(date: Date(),commit: fakeCommit,useDate: Date()))
        }
        
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date(), to: userdate as! Date)
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        let entry:SimpleEntry
        if userdate != nil {
            let commit = Commit(message: timeBetweenDate(toDate: userdate as! Date))
            entry = SimpleEntry(date: Date(),commit: commit,useDate: futureDate)
        } else {
            let fakeCommit = Commit(message: "Test")
            entry = SimpleEntry(date: Date(),commit: fakeCommit,useDate: Date())
        }
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let commit: Commit
    public let useDate:Date
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder")
    }
}

struct MainWidgetEntryView : View {
    var entry: Provider.Entry
    var body: some View {
        ZStack {
            Image("testBack")
                .resizable()
            VStack {
                Text(entry.useDate, style: .timer)
                    .font(.system(size: 19, weight: .light, design: .default))
                    .foregroundColor(.red)
                    .fixedSize()
            }
        }
    }
}

@main

struct MainWidget: Widget {
    private let kind: String = "MainWidget"
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
            MainWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CYM Widget Test")
        .description("This is an widget demo.")
        .supportedFamilies([.systemMedium])
    }
}
