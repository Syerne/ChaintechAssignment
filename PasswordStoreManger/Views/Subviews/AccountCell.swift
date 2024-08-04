import SwiftUI

struct AccountCell: View {
    
    let accountType: String
    
    var body: some View {
        HStack {
            HStack {
                Text(accountType.capitalized)
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .foregroundStyle(Color(hex: "333333"))
                    .padding(.leading)
                Text("******")
                    .font(.system(size: 20, weight: .regular, design: .default))
                    .frame(alignment: .centerFirstTextBaseline)
                    .foregroundStyle(Color(hex: "C6C6C6"))
                    .padding(.leading, 12)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            Image("detailArrow")
                .renderingMode(.template)
                .resizable()
                .tint(Color(hex: "333333"))
                .scaledToFit()
                .frame(width: 10, height: 14)
                .padding()
        }
        .frame(height: 68)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 35.0)
                .fill(Color(hex: "FFFFFF"))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 35.0)
                .stroke(Color(hex: "EDEDED"), lineWidth: 2.0)
        }
        
    }
}

#Preview {
    AccountCell(accountType: "Facebook")
}
