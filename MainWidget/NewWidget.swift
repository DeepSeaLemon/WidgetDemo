//
//  NewWidget.swift
//  WidgetDemo
//
//  Created by 曹宇明 on 2020/8/21.
//

import WidgetKit
import SwiftUI
import Intents

enum NewDataError: Error {
    case NotFound
    case IsNil
}

struct NewCommit {
    let message: String
}

struct NewCommitLoader {
    static func fetch(completion: @escaping (Result<NewCommit, NewDataError>) -> Void) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        if userdate != nil {
            let commit = NewCommit(message: timeBetweenDate(toDate: userdate as! Date))
            completion(.success(commit))
        } else {
            completion(.failure(NewDataError.NotFound))
        }
    }
}

struct NewProvider: TimelineProvider {
    public typealias Entry = NewSimpleEntry
        
    public func snapshot(with context: Context, completion: @escaping (NewSimpleEntry) -> ()) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        if userdate != nil {
            let commit = NewCommit(message: daysBetweenDate(toDate: userdate as! Date))
            completion(NewSimpleEntry(date: Date(),commit: commit, useDate: Date()))
        } else {
            let fakeCommit = NewCommit(message: "Test")
            completion(NewSimpleEntry(date: Date(),commit: fakeCommit,useDate: Date()))
        }

    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date(), to: userdate as! Date)
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        let entry:NewSimpleEntry
        if userdate != nil {
            let commit = NewCommit(message: daysBetweenDate(toDate: userdate as! Date))
            entry = NewSimpleEntry(date: Date(),commit: commit,useDate: futureDate)
        } else {
            let fakeCommit = NewCommit(message: "Test")
            entry = NewSimpleEntry(date: Date(),commit: fakeCommit,useDate: Date())
        }
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct NewSimpleEntry: TimelineEntry {
    public let date: Date
    public let commit:NewCommit
    public let useDate:Date
}

struct NewPlaceholderView : View {
    var body: some View {
        Text("Placeholder")
    }
}

struct NewWidgetEntryView : View {
    var entry: NewProvider.Entry
    var body: some View {
        ZStack {
            Image("testBack")
                .resizable()
            VStack {
                Text(entry.commit.message)
                    .font(.system(size: 19, weight: .light, design: .default))
                    .foregroundColor(.red)
                    .fixedSize()
            }
        }
    }
}

struct NewWidget: Widget {
    private let kind: String = "NewWidget"
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NewProvider(), placeholder: NewPlaceholderView()) { entry in
            NewWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CYM New Widget Test")
        .description("This is an widget demo.")
        .supportedFamilies([.systemLarge])
    }
}
