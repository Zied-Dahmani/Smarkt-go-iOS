//
//  QuantityPicker.swift
//  Smarkt Go
//
//  Created by Zied Dahmani on 7/4/2023.
//

import SwiftUI

struct QuantityPicker: View {
    let quantities = Array(1...10)
    @State var selectedQuantity = 1
    @State private var cartScreenViewModel =  CartScreenViewModel()
    let token:String
    var item : Item
    @State private var showAlert = false
    @State private var title = Text("")
    @State private var message = ""
    @Environment(\.presentationMode) var presentationMode

    
    var body: some View {
        VStack {
            Text(Strings.kselectQuantity)
                .font(.title)
                .fontWeight(.bold)
            Picker(Strings.kquantity, selection: $selectedQuantity) {
                ForEach(quantities, id: \.self) { quantity in
                    Text("\(quantity)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 4)
            
            CustomButton(text: Strings.kaddToCart, icon: "basket", textColor: .white, iconColor: .white, backgroundColor: .accentColor, action: {
                self.item.quantity = selectedQuantity
                self.item.price = Float(selectedQuantity) * self.item.price
                
                cartScreenViewModel.addToCart(token: token, supermarketId: item.supermarketId, item: item) { statusCode in
                    if let statusCode = statusCode {
                        switch statusCode {
                        case 200:
                            self.title = Text(Strings.ksuccess).foregroundColor(.accentColor)
                            self.message = Strings.kitemAddedToCart
                        case 201:
                            self.title = Text(Strings.ksuccess).foregroundColor(.accentColor)
                            self.message = Strings.kitemAddedToCart
                        case 400:
                            self.title = Text(Strings.kfailure).foregroundColor(.red)
                            self.message = Strings.kalreadyHaveAnOrder
                        default:
                            print(statusCode)
                        }
                        self.showAlert = true
                    } else {
                        print(Strings.kaddToCartFailed)
                        self.title = Text(Strings.kerror).foregroundColor(.red)
                        self.message = Strings.kaddToCartFailed
                        self.showAlert = true
                    }
                }

            }
                )
            
        }
        .alert(isPresented: $showAlert) {
            Alert(
                    title: self.title,
                    message: Text(message).foregroundColor(.accentColor),
                    dismissButton: .default(
                        Text(Strings.kok).foregroundColor(Color.accentColor),
                        action: {
                            presentationMode.wrappedValue.dismiss()
                        }
                    )
                )
            }
    }
    
}

struct QuantityPicker_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
