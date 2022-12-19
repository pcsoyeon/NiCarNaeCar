# 니카내카
![Frame 12](https://user-images.githubusercontent.com/59593430/190400639-1d3b796d-7950-4aa2-84eb-e718d268fc43.png)

### 한 줄 소개
서울시의 나눔카(쏘카/그린카) 주차 위치 정보 및 실시간 예약 현황을 알 수 있는 서비스

</br>

### 서비스 특징
- 지도를 기반으로 나눔카의 위치를 핀을 통해서 제공 
- 예약 가능한 차량에 대한 간략한 정보 (전기차 여부, 거점지, 거점 ID) 제공 
- 해당 위치에서 쏘카/그린카의 예약 현황을 알 수 있으며 앱 간 이동을 통해 바로 예약이 가능한 앱으로 이동 
  -  거점 리스트 API로 위치를 확인 가능 
  - 해당 위치의 거점 ID로 예약 현황 API에 연결하여 예약 가능한 차량을 조회 가능 
- 지도를 기반으로 서울시에 위치한 공공주차장의 위치를 핀을 통해서 제공 

</br>

### Link
[🔗 앱 스토어 링크 바로 가기](https://apps.apple.com/app/id6443532661) </br>
[🔗 노션 링크 바로 가기](https://www.notion.so/f48a8b496a484bcaa4191a8128683c58)

</br>
</br>

## 🛠️ 사용 기술 및 라이브러리 
- UIKit, AutoLayout
- SnapKit, Then
- Firebase
    - Push Notification
    - Google Analytics
- CoreLocation, Mapkit
- CompositionalLayout, DiffableDataSource
- URLSession
- MVC, MVVM
- RxSwift

</br>
</br>

## 📌 회고 
[🔗 좀 더 상세한 회고가 보고싶다면?](https://so-kyte.tistory.com/157)
</br>

### 🥰 좋았던 점 
아이디어를 고르는 것부터 시작해서 기획/개발 명세서를 작성하고 와이어프레임, UI를 그리는 작업까지 하나의 앱이 만들어지는 모든 과정을 다 다룰 수 있었다. </br>
1차 릴리즈에서는 큰 기능을 많이 넣지 않고 최대한 옹골찬(?) 앱을 만들어보자 .. 라고 목표를 세웠고 그에 맞는 적절한 계획과 Save Day라는 기간을 둘 수 있어서 작업이 밀리지 않은 점이 잘한 부분이라고 생각한다. </br>

</br>

프로젝트 단위에서 성장한 부분은 프레임워크로 모듈화를 하여 리소스를 관리한 것이라고 생각한다. 
기능적으로 공부한 부분은 CLLocation과 MapKit을 사용한 것, DispatchGroup을 사용해서 서버통신의 흐름을 다룬 것, Network 프레임워크를 통해 네트워크 연결 상태에 따른 분기처리를 한 것이라고 생각한다. </br>
이전 프로젝트에서 다뤄보지 않은 부분이라 새롭게 공부할 수 있었고 개발적으로도 성장했으며 사용자 입장에서 보다 원활한 이용과 자연스러운 앱 사용 흐름을 고민할 수 있었다. 

- CLLocation + MapKit (Custom Annotation)
```
import MapKit

import NiCarNaeCar_Resource

class DefaultAnnoationView: MKMarkerAnnotationView {

    static let ReuseID = "defaultAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "default"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = R.Color.black200
    }
}
```

</br>

- DispatchGroup
```
        dispatchGroup.enter()
        SpotListAPIManager.requestSpotList(startPage: startPage, endPage: endPage) { [weak self] data, error in
            guard let self = self else { return }
            guard let data = data else { return }
            
            for item in data.nanumcarSpotList.row {
                self.spotList.append(item)
            }
            self.dispatchGroup.leave()
        }
```

```
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            for spot in self.spotList {
                guard let latitude = Double(spot.la) else { return }
                guard let longtitude = Double(spot.lo) else { return }
                
                let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                self.setAnnotation(center: center, title: spot.positnNm)
            }
            
            self.filteredList = self.spotList
        }
```

</br>
- Network 프레임워크 사용 (네트워크 연결상태 분기)

```
import Foundation
import Network

final class NetworkMonitor {
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    init() {
        monitor = NWPathMonitor()
        dump(monitor)
        print("------------")
    }
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                statusUpdateHandler(path.status)
            }
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
```


### 🤔 아쉬운 부분 
초반부터 좀 더 욕심을 갖고 여러 목표를 세워서 구현했으면 어땠을까 하는 아쉬움이 든다. </br>
SeSAC 과정 중후반에 배운 MVVM을 도입하고 싶었는데 .. 사실 아직도 잘 모르겠어서 .. 이후에 공부를 좀 더 빡세게 하고 적용을 해야겠다고 다짐했다 .. 

</br>
</br>

### 개발 기간
- 전체적인 개발 기간 : 2022.09.07 ~ 2022.10.07
- 세부적인 개발 공수 
  - 일주일 단위로 개발 공수 분리 후 작업 진행
  - 1주차 : 프로젝트 초기 세팅 및 프레임워크 구현, 기획 및 UI 완성
  - 2주차 : 지도, API 연결 등의 기능 구현
  - 3주차 : 각 정보에 대한 세부 화면 UI 및 앱 간 이동, 정보 화면 등의 세부적인 기능 구현
  - 4주차 : 구현 마무리 및 QA 진행 

</br>
</br>

## 📑 개인일지 
| 날짜 | 제목 | 한 줄 요약 | 링크 |
|----|----|----|----|
|2022.09.14| Xcode Update | 업데이트는 마음 먹고 하자. | [📄](https://www.notion.so/8ee0c1ac594e434ab8224980177d0dbb) |
|2022.09.15| UI 완성 | UI 끝 !!! (아마도) | [📄](https://www.notion.so/UI-106cf317f10e41a1810ef66ae888edce) |
|2022.09.16| 검색 기능 추가 | 갑자기 검색? ㅋㅋㅋ 계획은 바뀌니까.. | [📄](https://www.notion.so/10cb07aa377c4f80b0a8150339122edd) |
|2022.09.17| UI 수정 및 코드 정리 | UI도 코드도 예쁘게 개선해보자 | [📄](https://www.notion.so/61f69cdc60134da6b6e6926708fa5b6b) |
|2022.09.18| 행정구/동 검색 | 안되면 되게하자 | [📄](https://www.notion.so/7ef8d95ea0d4444c9f649ec5c1d3bdc3) |
|2022.09.19| Code Refactoring | 힘들었다. | [📄](https://www.notion.so/Code-Refactoring-And-Map-Custom-37b86de094f443da829ecde37475326e) |
|2022.09.20| Error Handling and Map Custom | 오류 해결하고 UI 커스텀하고 바쁘다 바빠; | [📄](https://www.notion.so/821cef30008d47ab84f304ac4911b184) |
|2022.09.21| Bug Fix & Default/Empty UI  | 부가적인 기능 및 empty/loading 뷰 구현 | [📄](https://receptive-humidity-bf2.notion.site/Bug-Fix-Default-Empty-UI-300b0dbeb04b42ddaed2aeb5d5808395) |
|2022.09.23| 중간발표 | 중간발표 및 피드백 | [📄]() |
|2022.09.26| 출시를 해보자 | 일단 출시 해보자. | [📄](https://www.notion.so/a580e028f5f94a2080e03227fc2f8481) |
|2022.09.27| 업데이트를 하자 | 버그 해결 후 버전 업데이트 | [📄](https://www.notion.so/re-plan-1d3ad35500aa4a2dae70d5f049a1202e) |
|2022.09.28| Hue드백 | 수정에 수정을 더해서 ~ | [📄](https://www.notion.so/Hue-ab4fb9f78af84048859ab853b8d09b03) |
|2022.09.29| 1.1.1 버전 업데이트 | 네트워크 연결 상태 확인 및 앱스토어 리다이렉션 업데이트 | [📄](https://www.notion.so/1-1-1-d9afbd7f5cf64f369255ececb5031d04) |
|2022.09.30| 1.1.2 버전 업데이트 | 업데이트 유도 로직, 리뷰 및 평가 기능 추가 | [📄](https://www.notion.so/1-1-2-0241e2ee2c3c4d6c8ee623863c7f2424) |
|2022.10.01| 기획 추가 | 공영주차장 정보 추가 | - |
|2022.10.12| 추가된 기획 구현 | 푸시 알림, 공영주차장 지도 추가 | [📄](https://www.notion.so/5172f7e1bde0420b9ba000d1cd7e637c) |
|2022.10.14| 기획 추가 | 주차장 상세 화면 기획 추가 및 디자인 | [📄](https://www.notion.so/07c45f2a45194f3c924e4178f04c8871) |
|2022.10.19| 상세화면 구현 | 주차장 상세 화면 구현 | [📄](https://www.notion.so/b27e65674ed24709a75cd08f44430e55) |
|2022.10.20| 상세화면 구현 | MVVM, DiffableDateSource+CompositionalLayout   | [📄](https://www.notion.so/MVVM-DiffableDateSource-CompositionalLayout-2b033842c8da442d9617867deb7c88b1) |
|2022.10.27| 코드 개선 | 설정화면 코드 개선 (DffiableDataSource+CompositionalLayout) | [📄](https://www.notion.so/DiffableDataSource-CompositionalLayout-245d48d113364e5f8a7644c1da664b53) |
|2022.10.29| 코드 개선 | 검색화면 코드 개선 (MVVM+Rx) | [📄](https://www.notion.so/RxSwift-RxCocoa-aaadc1466afd4399b1a88d1ff9641fa2) |
|2022.10.31| 코드 개선 | 거점지 상세화면 코드 개선 (MVVM+Rx) | [📄](https://www.notion.so/RxSwift-RxCocoa-c57eaf99fe4c473fb20df0ae4cb02ebb) |
|2022.11.03| 코드 개선 및 업데이트 | 전반적으로 코드 개선 및 필요없는 코드 삭제 (추가적인 코드개선) | [📄](https://www.notion.so/edd056fe6cf44edf82bbe1e0a481c181) |
