//
//  NextWidget.swift
//  WidgetDemo
//
//  Created by 曹宇明 on 2020/8/21.
//

import WidgetKit
import SwiftUI
import Intents

enum NextDataError: Error {
    case NotFound
    case IsNil
}

struct NextCommit {
    let message: String
}

struct NextCommitLoader {
    static func fetch(completion: @escaping (Result<NextCommit, NextDataError>) -> Void) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        if userdate != nil {
            let commit = NextCommit(message: timeBetweenDate(toDate: userdate as! Date))
            completion(.success(commit))
        } else {
            completion(.failure(NextDataError.NotFound))
        }
    }
}

struct NextProvider: TimelineProvider {
    public typealias Entry = NextSimpleEntry
        
    public func snapshot(with context: Context, completion: @escaping (NextSimpleEntry) -> ()) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        if userdate != nil {
            let commit = NextCommit(message: daysBetweenDate(toDate: userdate as! Date))
            completion(NextSimpleEntry(date: Date(),commit: commit, useDate: Date()))
        } else {
            let fakeCommit = NextCommit(message: "Test")
            completion(NextSimpleEntry(date: Date(),commit: fakeCommit,useDate: Date()))
        }

    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let userdate = UserDefaults(suiteName: kGroupName)!.value(forKey: kUserDate)
        let components = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: Date(), to: userdate as! Date)
        let futureDate = Calendar.current.date(byAdding: components, to: Date())!
        let entry:NextSimpleEntry
        if userdate != nil {
            let commit = NextCommit(message: daysBetweenDate(toDate: userdate as! Date))
            entry = NextSimpleEntry(date: Date(),commit: commit,useDate: futureDate)
        } else {
            let fakeCommit = NextCommit(message: "Test")
            entry = NextSimpleEntry(date: Date(),commit: fakeCommit,useDate: Date())
        }
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct NextSimpleEntry: TimelineEntry {
    public let date: Date
    public let commit:NextCommit
    public let useDate:Date
}

struct NextPlaceholderView : View {
    var body: some View {
        Text("Placeholder")
    }
}

struct NextWidgetEntryView : View {
    var entry: NextProvider.Entry
    var body: some View {
        HStack {
            TestSmallView()
        }
    }
}

struct NextWidget: Widget {
    private let kind: String = "NextWidget"
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NextProvider(), placeholder: NextPlaceholderView()) { entry in
            NextWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CYM Next Widget Test")
        .description("This is an widget demo.")
        .supportedFamilies([.systemSmall])
    }
}
