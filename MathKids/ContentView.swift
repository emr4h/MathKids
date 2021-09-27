//
//  ContentView.swift
//  MathKids
//
//  Created by Emrah Yıldırım on 23.09.2021.
//

import SwiftUI

// Soru ve cevapların yapısı
struct Question {
    var ask : String
    var answer : Int
}

struct ContentView: View {
    @State private var tableChoose = 1
    @State private var askNum = ["5","10","15","20"]
    @State private var askNumSelect = "5"
    @State private var start = false
    @State private var images = ["buffalo","cow","duck","moose","parrot","pig","snake","zebra"].shuffled()
    @State private var arrayQuestions = [Question]()
    @State private var correctQuestion = Int.random(in: 0...3)
    @State private var score = 0
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var animationFalse = false
    @State private var animationTrue = false
    @State private var selectedList = 0
    
    var body: some View {
        
        if start == false {
            Group {
                NavigationView {
                    Form {
                        Section {
                            Text("Lütfen çalışmak istediğiniz çarpım tablosuna kadar seçiniz  ")
                            Stepper(value: $tableChoose, in: 1...10) {
                                Text("\(tableChoose)")
                            }
                        }
                        
                        Section {
                            Text("Lütfen soru sayısını seçiniz")
                            Picker(selection: $askNumSelect, label: Text("")) {
                                ForEach(askNum, id: \.self) { x in
                                    Text("\(x)")
                                }
                            }.pickerStyle(SegmentedPickerStyle())
                        }
                        
                        Image("mathKids")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 400, alignment: .center)
                    }
                    .navigationBarTitle(Text("MATH KIDS"))
                    .navigationBarItems(trailing: Button(action: {
                        score = 0
                        QuestionsCreate()
                        self.start = true
                    }, label: {
                        Image(systemName: "gamecontroller")
                        Text("BAŞLA")
                    }))
                    
                }
            }
        } else if start == true {
            Group {
                NavigationView {
                    Section {
                        Text("\(arrayQuestions[correctQuestion].ask)")
                            .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.10, alignment: .center)
                            .font(.title)
                            
                            .cornerRadius(3.0)
                            
                            .background(Color.white)
                            .shadow(radius: 10)
                            
                        
                        List(0..<4) { x in
                            Button(action: {
                                withAnimation(.linear(duration: 1.0)) {
                                    selectTapped(selected: x)
                                }
                                newQuestion()
                                
                            }, label: {
                                HStack {
                                    Image(images[x])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .overlay(Rectangle().stroke(Color.black, lineWidth: 5))
                                        .shadow(radius: 10)
                                    Spacer()
                                    Text("\(arrayQuestions[x].answer)")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.orange)
                                    Spacer()
                                }
                                .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.11, alignment: .leading)
                                .rotation3DEffect(
                                    .degrees(self.animationFalse && correctQuestion != x && selectedList == x ?  360 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .rotation3DEffect(
                                    .degrees(self.animationTrue && correctQuestion == x && selectedList == x ? 360 : 0),
                                    axis: (x: 1, y: 0, z: 0)
                                )
                                
                                
                            })
                            .alert(isPresented: $showAlert, content: {
                                Alert(title: Text("\(alertTitle)"), message: Text("Toplam puanın : \(score)"), dismissButton: .default(Text("Yeniden Başla"), action: {
                                    score = 0
                                    askNumSelect = "10"
                                    arrayQuestions.removeAll()
                                    QuestionsCreate()
                                    newQuestion()
                                    
                                }))
                            })
                        }
                        VStack {
                            Text("Toplam Doğru Sayısı : \(score)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.blue)
                            Text("Geriye Kalan Soru Sayısı : \(askNumSelect)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.red)
                        }
                        .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.10, alignment: .center)
                    }
                    .navigationBarItems(leading: Button(action: {
                        arrayQuestions.removeAll()
                        score = 0
                        self.start = false
                        
                    }, label: {
                        Image(systemName: "gamecontroller")
                        Text("BİTİR")
                    }))
                        
                }
            }
        }
        
     
    }
    
    // tableChoose seçimi kadar soru oluşturur.
    func QuestionsCreate() {
        for i in 1...tableChoose {
            for j in 1...10 {
                let addQuestion = Question(ask: "\(i) * \(j) = ?", answer: i * j)
                arrayQuestions.append(addQuestion)
            }
        }
        arrayQuestions.shuffle()
    }
    // Yeni soru geçişi için
    func newQuestion() {
            arrayQuestions.shuffle()
            correctQuestion = Int.random(in: 0...3)
            animationTrue = false
            animationFalse = false
            
        }
    // Seçim yapıldığında buton aksiyon
    func selectTapped(selected:Int)  {
        selectedList = selected
        if selected == correctQuestion && Int(askNumSelect) != 1 {
            animationTrue.toggle()
            score = score + 1
            askNumSelect = String(Int(askNumSelect)! - 1)
            images.shuffle()
        } else if selected == correctQuestion && Int(askNumSelect) == 1 {
            animationTrue.toggle()
            score = score + 1
            askNumSelect = "0"
            images.shuffle()
            showAlert = true
        } else {
            animationFalse.toggle()
            images.shuffle()
            score = score - 1
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
