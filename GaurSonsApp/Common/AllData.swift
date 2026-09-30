//
//  AllData.swift
//  FieldBlaze
//
//  Created by Sakshi on 08/04/25.
//  Copyright © 2025 FieldBlazeOrganizationName. All rights reserved.
//

import Foundation

struct ActionItem {
    let actionTitle: String
    let actionImage: String
}

var actionCollectionData: [ActionItem] = [
    ActionItem(actionTitle: "Dashboard", actionImage: "dashboard"),
    ActionItem(actionTitle: "Doctors/CC", actionImage: "doctor"),
    ActionItem(actionTitle: "Attendance", actionImage: "attendance"),
    ActionItem(actionTitle: "Beat Plans", actionImage: "Beatplan"),
    ActionItem(actionTitle: "Tours", actionImage: "Visit"),
//    ActionItem(actionTitle: "Approvals", actionImage: "Approvals"),
    ActionItem(actionTitle: "Tasks", actionImage: "tasks"),
    ActionItem(actionTitle: "Learning", actionImage: "learning"),
]

//Data for Daily Record Table :-
struct DailyRecord{
    let name: String
    let email: String
    let phone: String
    let company:String
    let isCompleted:Bool
}

var dailyRecordData: [DailyRecord] = [
    DailyRecord(name: "John Doe", email: "johndoe@example.com", phone: "+1234567890", company: "ABC Corporation", isCompleted: true),
    DailyRecord(name: "Jane Doe", email: "janedoe@example.com", phone: "+0987654321", company: "XYZ Company", isCompleted: false),
    DailyRecord(name: "Akash", email: "akash@gmail.com", phone: "0000000000", company: "CCC", isCompleted: false),
    DailyRecord(name: "Sumit", email: "akash@gmail.com", phone: "0000000000", company: "CCC", isCompleted: true),
    DailyRecord(name: "Rakshit", email: "akash@gmail.com", phone: "0000000000", company: "CCC", isCompleted: false)
]


struct SalesPersonDataStruct{
    let name:String
    let email:String
    let phone:String
}

struct TodoTasks{
    let title:String
    let description:String
    let isCompleted:Bool
    let id:String
}


