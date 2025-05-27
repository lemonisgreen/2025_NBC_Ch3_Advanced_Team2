# Allarm

Allarm은 알람, 타이머, 스톱워치 기능을 하나의 앱에서 통합적으로 제공하는 iOS 앱입니다. MVVM 아키텍처 기반으로 설계되었으며, CoreData 및 RxSwift를 활용하여 사용자 설정을 안정적으로 저장하고 관리합니다.

## 목차

1. 프로젝트 소개
2. 주요 기능
3. 기술 스택
4. 화면 구성
5. 팀 소개
6. 폴더 구조
7. 설치 및 실행

---

## 1. 프로젝트 소개

Allarm은 일상을 체계적으로 관리할 수 있도록 도와주는 시계 앱입니다. 기본 알람 앱의 기능을 강화하고, 사용자 경험을 개선한 UI를 제공합니다.

* 프로젝트 기간: 2025.05.20 \~ 2025.05.28
* 기획 목적: 알람, 타이머, 스톱워치를 통합한 직관적인 UX 제공
* 개발 인원: 5명

---

## 2. 주요 기능

### 알람

* 알람 시간 설정, 라벨, 반복 요일 설정
* on/off 스위치로 알람 개별 제어
* CoreData를 통한 알람 저장 및 불러오기

### 타이머

* 원하는 시간 설정 가능
* 타이머 시작/취소
* 진동/소리 설정

### 스톱워치

* 시작/멈춤/리셋/랩타임 기능
* 랩타임 리스트 표시

### 사용자 경험

* 각 기능에 맞는 분리된 ViewController
* MVVM 패턴을 활용한 로직 분리 및 테스트 용이성 확보
* 직관적인 UI 구성 (SnapKit 기반 오토레이아웃)

---

## 3. 기술 스택

### Architecture

* MVVM

### 비동기 처리

* RxSwift

### 데이터 저장

* CoreData
* UserDefaults

### UI & Layout

* UIKit
* SnapKit

---

## 4. 화면 구성

* AlarmListViewController
* AlarmSettingViewController
* TimerListViewController
* TimerSettingViewController
* StopwatchViewController

---

## 5. 팀 소개

| 이름  | 담당 역할 |
| --- | ------------------------------------ |
| 최영건 | 스톱워치 구현, 시간 흐름 로직, ViewModel 구성 |
| 김은서 | 타이머 설정 화면, 시간 전달, ViewModel 바인딩 |
| 전원식 | 타이머 목록 뷰, 최근 사용 타이머, 상태 업데이트 |
| 김형윤 | 알람 설정 화면, CoreData 저장, UI 구성 |
| 이정진 | 알람 목록 뷰, on/off 기능, 삭제, ViewModel 연동 |

---

## 6. 폴더 구조

```
Allarm
├── Alarm
│   ├── AlarmListViewController.swift
│   ├── AlarmSettingViewController.swift
│   ├── AlarmViewModel.swift
│   └── AlarmModel.swift
│
├── Timer
│   ├── TimerListViewController.swift
│   ├── TimerSettingViewController.swift
│   ├── TimerViewModel.swift
│   └── TimerModel.swift
│
├── Stopwatch
│   ├── StopwatchViewController.swift
│   ├── StopwatchViewModel.swift
│   └── StopwatchModel.swift
│
├── Common
│   ├── Extensions.swift
│   ├── Font.swift
│   ├── Color.swift
│   └── Components/
│       └── CustomSwitch.swift
│
├── Resources
│   └── Assets.xcassets
│
├── CoreData
│   └── AllarmDataModel.xcdatamodeld
│
├── AppDelegate.swift
├── SceneDelegate.swift
└── Info.plist
```

---

## 7. 설치

1. 이 저장소를 클론합니다:

```bash
git clone https://github.com/lemonisgreen/2025_NBC_Ch3_Advanced_Team2.git
```
