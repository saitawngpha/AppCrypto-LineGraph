//
//  Home.swift
//  AppCrypto
//
//  Created by Steve Pha on 1/30/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    
    @State var currentCoin: String = "BTC"
    @Namespace var anitmation
    @StateObject var appViewModel = AppViewModel()
    
    var body: some View {
        VStack{
            if let coins = appViewModel.coins, let coin = appViewModel.currentCoin {
                //MARK: Sample UI
                HStack(spacing: 15){
                    AnimatedImage(url: URL(string: coin.image))
                        .resizable()
//                    Circle()
//                        .fill(.red)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:  50, height: 50)
                    
                    VStack{
                        Text(coin.name)
                            .font(.callout)
                        Text(coin.symbol.uppercased())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }//end vstack
                }//end hstack
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                CustomControl(coins: coins)
                
                VStack(alignment: .leading, spacing: 8){
                    Text(coin.current_price.convertToCurrency())
                        .font(.largeTitle.bold())
                    
                    //MARK: Profit / loss
                    Text("\(coin.price_change > 0 ? "+" : "")\(String(format: "%0.2f", coin.price_change))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(coin.price_change < 0 ? .white : .black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background{
                            Capsule()
                                .fill(coin.price_change < 0 ? .red : Color("LightGreen"))
                        }
                }//end vstack
                .frame(maxWidth: .infinity, alignment: .leading)
               
                
                GraphView(coin: coin)
                
                Controls()
            }else {
                ProgressView()
                    .tint(Color("LightGreen"))
            }
            
        }//end vstack
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    //MARK: Line Graph
    @ViewBuilder
    func GraphView(coin: CryptoModel) -> some View{
        GeometryReader{_ in
             
            LineGraph(data: coin.last_7days_price.price, profit: coin.price_change > 0)
            
        }
        .padding(.vertical, 30)
        .padding(.bottom, 20)
    }
    
    
    //MARK: Custom Segmented Control
    @ViewBuilder
    func CustomControl(coins: [CryptoModel]) -> some View {
        //Sample Data
        //let coins = ["BTC", "ETH", "BNB"]
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 16){
                ForEach(coins){ coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background{
                            if currentCoin == coin.symbol.uppercased() {
                                Rectangle()
                                    .fill(Color("TAB"))
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: anitmation)
                            }
                        }
                        .onTapGesture {
                            withAnimation {
                                appViewModel.currentCoin = coin
                                currentCoin = coin.symbol.uppercased()
                            }
                        }
                }
            }//end hstack
            .background{
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            }
            .padding(.vertical)
        }
    }
    
    //MARK: Controls
    @ViewBuilder
    func Controls() -> some View{
        HStack(spacing: 20){
            Button{
                
            }label: {
                Text("Sell")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.white)
                    }
            }
            
            Button{
                
            }label: {
                Text("Buy")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background{
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color("LightGreen"))
                    }
            }
        }//end hstack
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}


//MARK: Converting double to currency
extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
}
