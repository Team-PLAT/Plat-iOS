//
//  ReportView.swift
//  PLAT
//
//  Created by 조우현 on 9/23/24.
//

import SwiftUI

// MARK: - ReportView

struct ReportView: View {
    
    @Environment(TrackUseCase.self) private var trackUseCase
    @Environment(PathModel.self) private var pathModel
    
    @State private var isReportAlertPresented = false
    @State private var isReportCompleteAlertPresented = false
    
    @State private var reportList = [
        "불법촬영물 등의 유통",
        "상업적 광고 및 판매",
        "게시판 성격에 부적절함",
        "욕설/비하",
        "정당/정치인 비하 및 선거운동",
        "유출/사칭/사기",
        "낚시/놀림/도배"
    ]
    
    var body: some View {
        VStack {
            ReportSection(reportList: $reportList, isReportAlertPresented: $isReportAlertPresented)
            
            Spacer()
                .frame(height: 32)
            
            ReportInfo()
            
            Spacer()
        }
        .navigationTitle("신고하기")
        .navigationBarTitleDisplayMode(.inline)
        .padding(24)
        .background(.platBackground)
        .alert("트랙을 신고하시겠어요?", isPresented: $isReportAlertPresented) {
            Button("취소", role: .cancel) {}
            Button("신고하기", role: .destructive) {
                Task {
                    // TODO: selectedTrackId라는 상수를 통해 넘겨주기
                    trackUseCase.effect(.reportTrack(trackId: Int(trackUseCase.selectedTrackId)))
                    isReportCompleteAlertPresented.toggle()
                }
            }
        }
        .alert("신고가 완료됐어요", isPresented: $isReportCompleteAlertPresented) {
            Button("확인", role: .none) {
                pathModel.pop()
            }
        } message: {
            Text("신고한 트랙은 블라인드 처리 되며, 관리자 검토 후 최대 24시간 이내에 조치 될 예정이에요")
        }
    }
}
    
    // MARK: - ReportSection
    
    private struct ReportSection: View {
        
        @Binding var reportList: [String]
        @Binding var isReportAlertPresented: Bool
        
        var body: some View {
            VStack(alignment: .leading) {
                ForEach(Array(reportList.enumerated()), id: \.offset) { _, report in
                    Button {
                        isReportAlertPresented.toggle()
                    } label: {
                        Text(report)
                            .font(.Body.body1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 48)
                    }
                }
            }
        }
    }
    
    // MARK: - ReportInfo
    
    private struct ReportInfo: View {
        
        var body: some View {
            Text("* 플랫은 모든 사용자가 안전하고 쾌적한 환경에서 서비스를 이용할 수 있도록 최선을 다하고 있어요. 그러나 이를 악용하여 다른 사용자에게 피해를 주는 경우, 제재가 가해질 수 있어요")
                .font(.Body.body5)
                .foregroundStyle(.gray7)
                .lineSpacing(8)
        }
    }
    
    // MARK: - Preview
    
    #Preview {
        ReportView()
            .injectDIContainer()
    }
