//
//  ContentView.swift
//  OrganizingApp
//
//  Created by Kevin Mo on 6/9/20.
//  Copyright © 2020 Kevin Mo. All rights reserved.
//

import SwiftUI

class UserSettings: ObservableObject {
    @Published var arr = [String]()
}

struct ContentView: View {
    @ObservedObject var settings = UserSettings()
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                NavigationLink(destination: DetailView()) {
                    Text("To Do List")
                    .frame(minWidth: 0, maxWidth: 500, minHeight: 0, maxHeight: 100)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                }
                
                NavigationLink(destination: DetailView1()) {
                    Text("Optimal Wake Up Time")
                    .frame(minWidth: 0, maxWidth: 400, minHeight: 0, maxHeight: 100)
                    .padding(10)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                }
                
                NavigationLink(destination: DetailView2()) {
                    Text("Finances")
                    .frame(minWidth: 0, maxWidth: 400, minHeight: 0, maxHeight: 100)
                    .padding(10)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                }
            }
            .navigationBarTitle("Organizer App", displayMode: .inline)
        }
        
    }
}

struct DetailView: View {
//    @State private var arr = [String]()
    @State private var task = ""
    @State private var index = 0
    @ObservedObject var settings = UserSettings()
    
    var body: some View{
        NavigationView {
            VStack {
                Text("Do more.")
                TextField("Tasks", text: $task, onCommit: addTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                List(settings.arr, id: \.self) {
                    Text($0)
                }
            }
        } .navigationBarTitle ("To Do", displayMode: .inline)
    }
    
    func addTask() {
        settings.arr.insert(task, at: index)
        index += 1;
        task = ""
    }
}

struct DetailView1: View {
    @State private var totalAmount = ""
    @State private var selectedP = 0
    @State private var selectedT = 0
    @State private var index = 0
    let tipPercent = [0, 5, 10, 15, 20]
    let numbers = [1, 2, 3, 4, 5, 6, 7]
    
    var myPay: Double {
        let totalCost = Double(totalAmount) ?? 0
        let peopleQuan = Double(numbers[selectedP])
        let tip = Double(tipPercent[selectedT])
        let costBefore = totalCost/peopleQuan
        let myTip = costBefore * (tip/100)
        return costBefore + myTip
    }
    
    var body: some View {
        
        VStack {
            Form {
                Section {
                    TextField("Total Ride Cost", text: $totalAmount)
                }
                
                Section(header: Text("Total Passengers")) {
                    Picker("Total Passengers", selection: $selectedP) {
                        ForEach(0 ..< numbers.count) {
                            Text("\(self.numbers[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Tip Percentage")) {
                    Picker("Tip Percent", selection: $selectedT) {
                        ForEach(0 ..< tipPercent.count) {
                            Text("\(self.tipPercent[$0]) %")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Amount I Pay")) {
                    Text("\(myPay, specifier: "%.2f")")
                }
            }
        }
    }
}

struct DetailView2: View {
    @State private var leisure = ""
    @State private var extracir = ""
    @State private var homework = ""
    @State private var meal = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Leisure Time", text: $leisure)
                    }
                    
                    Section {
                        TextField("Extracirricular Time", text: $extracir)
                    }
                    
                    Section {
                        TextField("Homework Time", text: $homework)
                    }
                    
                    Section {
                        TextField("Meal Time", text: $meal)
                    }
                    
                    Section(header: Text("Recommended Sleep")) {
                        Text("\(averageHours(), specifier: "%.2f")")
                            .font(.largeTitle)
                    }
                }
            }
        }
        .navigationBarTitle("Recommended Sleep")
    }
    
    func averageHours() -> Double {
        let mlModel = HourPredict_1()
        var averageSleep = 0.0
        
        do { // the ML connection and ability to predict
            let prediction = try mlModel.prediction(Leisure_Time: Double(leisure) ?? 0, EC_Time: Double(extracir) ?? 0, HW_Time: Double(homework) ?? 0, Meal_Time: Double(meal) ?? 0)
            averageSleep = prediction.Average_Sleep
        } catch {

        }
        
        return averageSleep
        
    }
}

struct ContentView_Previews: PreviewProvider {
//    @Binding var arr: [String]

    static var previews: some View {
        ContentView()
    }
}
