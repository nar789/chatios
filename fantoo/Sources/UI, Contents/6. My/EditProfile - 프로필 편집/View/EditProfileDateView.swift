//
//  EditProfileDateView.swift
//  fantoo
//
//  Created by fns on 2022/08/19.
//  Copyright © 2022 FNS CO., LTD. All rights reserved.
//

import SwiftUI

struct EditProfileDateView: View {
    
    private static func weekOfYear(for date: Date) -> Double {
        Double(Calendar.current.component(.weekOfYear, from: date))
    }
    
    private static func weekDay(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from: date)
        return weekDay
    }
    
    @State private var date: Date
    @State private var weekOfYear: Double
    @State private var weekDay: String
    @State private var lastWeekOfThisYear = 53.0
    
    private var dateProxy:Binding<Date> {
        Binding<Date>(get: {self.date }, set: {
            self.date = $0
            self.updateWeekAndDayFromDate()
        })
    }
    
    init() {
        let now = Date()
        self._date = State<Date>(initialValue: now)
        self._weekOfYear = State<Double>(initialValue: Self.weekOfYear(for: now))
        self._weekDay = State<String>(initialValue: Self.weekDay(for: now))
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("s_birthday".localized)
                    .font(Font.title51622Medium)
                Spacer()
            }
            // Date Picker
            DatePicker(selection: dateProxy, displayedComponents: .date, label:{ Text("Please enter a date") }
            )
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
            
            // Week number and day
            Text("Week \(Int(weekOfYear.rounded()))")
            Text("\(weekDay)")
            Button {
                
            } label: {
                CommonButton(title: "d_next".localized, bgColor: Color.stateActivePrimaryDefault)
            }
        }
        .padding(.horizontal, 32)
        
    }
    
    func updateWeekAndDayFromDate() {
        self.weekOfYear = Self.weekOfYear(for: self.date)
        self.weekDay = Self.weekDay(for: self.date)
    }
    
    func updateDateFromWeek() {
        // To do
    }
    
    func setToday() {
        // To do
    }
    
    func getWeekDay(_ date: Date) -> String {
        ""
    }
}
