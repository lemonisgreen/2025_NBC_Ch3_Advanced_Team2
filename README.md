Allarm

Allarm은 알람, 타이머, 스톱워치 기능을 하나로 담은 사용자 친화적 시계 앱입니다.

⸻

목차
	1.	프로젝트 개요
	2.	팀 소개
	3.	프로젝트 일정
	4.	기술 스택
	5.	주요 기능
	6.	폴더 구조
	7.	설치 및 실행 방법

⸻

1. 프로젝트 개요

Allarm은 iOS의 기본 시계 앱에서 한 단계 더 나아간 사용자 친화적인 시계 앱으로, 다음과 같은 기능을 제공합니다.
	•	알람 설정 및 반복 요일 지정
	•	타이머 설정 및 최근 사용 목록
	•	스톱워치 랩타임 저장
	•	MVVM 아키텍처와 RxSwift 기반 설계

⸻

2. 팀 소개

이름	담당 역할
김형윤	알람 설정 화면 및 CoreData 저장 기능 구현
이정진	알람 목록 조회 및 CoreData 연결, 삭제 기능
최영건	스톱워치 UI 및 랩 저장 기능 구현
김은서	타이머 설정 UI 및 실행 기능 구현
전원식	타이머 목록 및 현재 타이머 뷰 구성


⸻

3. 프로젝트 일정
	•	프로젝트 기간: 2025.05.20 ~ 2025.05.28

날짜	주요 작업 내용
05.20	와이어프레임 작성, 전체 설계 및 폴더 구조 설계
05.21	기본 UI 스케치 및 뷰/뷰모델 초기 바인딩 설정
05.22	CoreData 설계 및 로직 연결 작업
05.23	기능별 데이터 처리 및 ViewModel 연동
05.24~27	디버깅, 기능 디테일 마무리, 디자인 폴리싱, 발표 준비
05.28	최종 발표 및 마무리


⸻

4. 기술 스택
	•	iOS 16 / Xcode 16.2
	•	UIKit, SnapKit
	•	RxSwift, RxCocoa
	•	CoreData
	•	MVVM 아키텍처
	•	Swift Concurrency (부분 사용)

⸻

5. 주요 기능

알람
	•	반복 요일, 진동/소리 여부, 라벨 입력, CoreData 저장
	•	알람 On/Off 토글 및 삭제 기능

스톱워치
	•	시작/정지, 랩 기록, 전체 시간 계산 및 테이블뷰 저장

타이머
	•	시간 설정, 시작/취소 버튼
	•	최근 사용한 타이머 목록 저장

공통
	•	MVVM 아키텍처 구조
	•	사용자 친화적인 UI 구성
	•	깔끔한 폴더 및 파일 구조 관리

⸻

6. 폴더 구조

Allarm
├── Alarm+CoreDataClass.swift
├── Alarm+CoreDataProperties.swift
├── Stopwatch+CoreDataClass.swift
├── Stopwatch+CoreDataProperties.swift
├── Timer+CoreDataClass.swift
├── Timer+CoreDataProperties.swift
│
├── Alarm/
│   ├── AlarmListViewController.swift
│   ├── AlarmSettingModel.swift
│   ├── AlarmSettingViewController.swift
│   ├── AlarmSettingViewModel.swift
│
├── Timer/
│   ├── TimerSettingViewController.swift
│   ├── TimerViewModel.swift
│
├── CoreDataManage.swift
├── MainViewController.swift
├── SceneDelegate.swift
├── AppDelegate.swift
├── LaunchScreen.storyboard
├── Assets.xcassets
├── Info.plist


⸻

7. 설치 및 실행 방법
	1.	저장소를 클론합니다.

git clone https://github.com/lemonisgreen/2025_NBC_Ch3_Advanced_Team2.git
