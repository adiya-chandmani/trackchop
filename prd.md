# TrackChop - macOS Trackpad Sampler

## Product Requirements Document

**문서 버전:** 1.1  
**제품 유형:** 독립형 macOS 음악 제작 애플리케이션  
**주요 플랫폼:** Apple Silicon 기반 MacBook  
**핵심 입력 장치:** MacBook 내장 트랙패드  
**프로젝트 상태:** 기획 단계  
**이번 개정의 기준:** MVP는 Import, Chop, 16 Pad, Trackpad Performance, 기본 패턴 녹음, 저장, Master WAV Export에 집중한다. GarageBand 연동, 고급 Effect, Piano Roll, Song Mode, Audio Unit, 외부 MIDI는 MVP 이후 범위로 둔다.

---

# 1. 제품 개요

TrackChop은 사용자가 음원을 불러오거나 직접 녹음한 뒤, 음원을 여러 조각으로 자르고 MacBook 트랙패드를 4×4 샘플 패드처럼 사용해 연주할 수 있는 독립형 macOS 샘플러 앱이다.

사용자는 별도의 MIDI 컨트롤러나 하드웨어 샘플러 없이 MacBook만으로 다음 작업을 수행할 수 있다.

- 음원 가져오기
- 마이크 또는 오디오 입력 녹음
- 샘플 편집 및 Chop
- 16개 패드에 샘플 배치
- 트랙패드 핑거 드러밍
- 패턴 녹음
- 비트 편집
- 믹싱 및 이펙트 적용
- 완성된 결과 저장 및 내보내기

GarageBand 연동은 앱의 핵심 기능이 아니라, TrackChop에서 만든 결과를 추가로 편곡하거나 수정하고 싶은 사용자를 위한 선택적 Export 기능으로 제공한다. MVP에서는 GarageBand 전용 내보내기를 포함하지 않고, Master WAV Export만 제공한다.

---

# 2. 제품 비전

> 음원을 자르고, MacBook 트랙패드를 16개의 패드처럼 두드리며, 앱 안에서 완전한 비트까지 만들 수 있는 독립형 macOS 샘플러.

TrackChop은 기존 DAW처럼 복잡한 음악 제작 환경을 제공하는 것이 목적이 아니다.

사용자가 앱을 실행하고 몇 분 안에 다음 경험을 할 수 있어야 한다.

1. 음원을 넣는다.
2. 원하는 부분을 자른다.
3. 트랙패드로 샘플을 연주한다.
4. 연주를 녹음한다.
5. 비트를 완성한다.

제품의 핵심은 기능의 수보다 **샘플을 직접 자르고 손가락으로 연주하는 경험**이다.

---

# 3. 문제 정의

## 3.1 현재 사용자 문제

샘플링과 핑거 드러밍을 시작하려는 사용자는 일반적으로 다음 문제를 겪는다.

- 하드웨어 샘플러, MIDI 패드 등 별도의 장비가 필요하다.
- 전문 DAW는 초보자에게 기능이 지나치게 복잡하다.
- 샘플을 자르고 패드에 넣는 과정이 번거롭다.
- 노트북 키보드는 실제 패드처럼 직관적이지 않다.
- 간단한 아이디어를 만들기 위해 여러 프로그램을 오가야 한다.
- 이동 중에는 별도의 음악 장비를 사용하기 어렵다.

## 3.2 TrackChop의 해결 방식

TrackChop은 MacBook의 내장 트랙패드를 음악 입력 장치로 재해석한다.

- 트랙패드를 4×4 영역으로 구분한다.
- 각 영역을 하나의 샘플 패드로 사용한다.
- 음원을 자동 또는 수동으로 16개의 샘플로 나눈다.
- 사용자의 연주를 앱 내부 시퀀서에 기록한다.
- 앱 안에서 비트를 완성하고 오디오로 내보낸다.

---

# 4. 제품 목표

## 4.1 핵심 목표

### 목표 1. 빠른 샘플링

사용자가 음원을 불러온 뒤 1분 이내에 첫 번째 샘플을 연주할 수 있어야 한다.

### 목표 2. 트랙패드 기반 연주

MacBook 내장 트랙패드를 별도의 설정 없이 4×4 패드로 사용할 수 있어야 한다.

### 목표 3. 독립적인 비트 제작

GarageBand나 다른 DAW를 실행하지 않고도 샘플링, 녹음, 편집, 믹싱, 내보내기를 완료할 수 있어야 한다.

### 목표 4. 하드웨어 샘플러 감성

사용자가 일반적인 macOS 유틸리티가 아니라 실제 음악 장비를 사용하는 느낌을 받아야 한다.

### 목표 5. 초보자와 숙련자 모두 지원

초보자는 자동 Chop과 간단한 패드 연주를 사용할 수 있고, 숙련자는 샘플 시작점, Envelope, Filter, Sequencer 등을 상세하게 편집할 수 있어야 한다.

---

# 5. 비목표

MVP 및 초기 공개 버전에서는 다음 기능을 주요 목표로 삼지 않는다.

- Logic Pro 수준의 전체 DAW 기능
- 보컬 녹음 및 전문 오디오 레코딩 스튜디오
- 영상 편집
- 클라우드 기반 협업
- 실시간 온라인 합주
- 외부 VST 플러그인 호스팅
- 수백 개의 오디오 트랙을 지원하는 대형 프로젝트
- GarageBand 프로젝트 파일 자체 생성
- 타사 로고, 제품명, 저작권이 있는 그래픽 에셋의 직접적인 사용

TrackChop은 AKAI MPC Sample을 시각적 레퍼런스로 삼아 패널 레이아웃, 패드 그리드, 색상 톤을 가깝게 참고한다. 단, 로고·제품명·저작권 그래픽은 독자적으로 제작한다.

---

# 6. 주요 사용자

## 6.1 입문 비트메이커

- 샘플링에 관심이 있지만 하드웨어 샘플러가 없다.
- GarageBand나 Ableton Live가 복잡하게 느껴진다.
- 빠르게 재미있는 비트를 만들고 싶다.

## 6.2 학생 및 취미 음악 제작자

- MacBook을 주로 사용한다.
- 이동 중에 간단한 음악 아이디어를 만들고 싶다.
- 별도의 장비 구매 부담을 줄이고 싶다.

## 6.3 기존 DAW 사용자

- 메인 DAW를 실행하기 전에 빠르게 샘플을 Chop하고 싶다.
- TrackChop에서 만든 아이디어를 GarageBand, Logic Pro 또는 다른 DAW로 옮기고 싶다.
- 트랙패드를 새로운 퍼포먼스 컨트롤러로 사용하고 싶다.

## 6.4 핑거 드러밍 사용자

- 키보드보다 손가락 위치를 직접 사용하는 인터페이스를 선호한다.
- 16 Levels, Note Repeat, Full Level 등 퍼포먼스 기능을 원한다.

---

# 7. 핵심 가치 제안

## 7.1 장비 없이 샘플링

별도의 하드웨어 샘플러나 MIDI 패드 없이 MacBook 하나만으로 샘플을 연주할 수 있다.

## 7.2 즉각적인 작업 흐름

음원 가져오기부터 Chop, 패드 배치, 녹음까지 최소한의 단계로 연결된다.

## 7.3 촉각 중심 인터페이스

트랙패드의 실제 위치와 멀티터치를 활용하기 때문에 일반 키보드 입력보다 직관적인 연주가 가능하다.

## 7.4 독립형 음악 제작

앱 내부에서 완성된 비트까지 제작할 수 있다.

## 7.5 선택적 DAW 연동

필요한 경우 MIDI, 오디오 Stem, 개별 샘플을 GarageBand로 보내 추가 편집할 수 있다.

---

# 8. 제품 디자인 원칙

## 8.1 Play First

앱을 실행한 직후 사용자가 빠르게 소리를 낼 수 있어야 한다.

## 8.2 Hardware Feel

버튼, 패드, 디스플레이, 미터가 실제 음악 장비처럼 느껴져야 한다.

## 8.3 Clear Modes

현재 사용자가 Sample Edit, Program Edit, Sequencer, Mixer 중 어느 모드에 있는지 명확해야 한다.

## 8.4 Non-Destructive Editing

샘플 Chop과 편집은 가능한 한 원본 파일을 손상시키지 않는 방식으로 처리한다.

## 8.5 Low Latency

손가락이 트랙패드에 닿은 순간과 소리가 재생되는 순간 사이의 지연을 최소화한다.

## 8.6 Progressive Complexity

기본 기능은 단순하게 제공하고, 고급 설정은 필요할 때 펼쳐볼 수 있어야 한다.

---

# 9. 핵심 사용자 흐름

## 9.1 새로운 샘플 프로젝트

1. 사용자가 TrackChop을 실행한다.
2. `New Project`를 선택한다.
3. 음원 파일을 드래그하거나 `Import Sample`을 누른다.
4. 음원의 Waveform이 표시된다.
5. 사용자가 Auto Chop, Equal Slice 또는 Manual Chop을 선택한다.
6. 생성된 Slice가 16개 패드에 배치된다.
7. 사용자가 Trackpad Mode를 켠다.
8. 트랙패드를 두드려 샘플을 연주한다.
9. Record 버튼을 눌러 패턴을 녹음한다.
10. Quantize, Swing, Velocity 등을 편집한다.
11. 프로젝트를 저장하거나 WAV로 내보낸다.

## 9.2 직접 녹음 후 샘플링

1. 사용자가 `Record Sample`을 선택한다.
2. 마이크 또는 연결된 오디오 입력을 선택한다.
3. 녹음을 시작한다.
4. 녹음을 종료한다.
5. 녹음된 Waveform이 Sample Edit 화면에 표시된다.
6. 사용자가 필요한 구간을 Trim한다.
7. Auto Chop 또는 Manual Chop으로 나눈다.
8. 패드에 배치하고 연주한다.

## 9.3 MVP 이후: GarageBand로 보내기

이 흐름은 MVP 완료 후 2차 출시에서 제공한다.

1. 사용자가 프로젝트를 완성한다.
2. Export 메뉴를 연다.
3. `Send to GarageBand`를 선택한다.
4. 다음 항목 중 내보낼 항목을 선택한다.
  - Master WAV
  - Track Stems
  - MIDI Pattern
  - 개별 Slice 파일
5. 앱이 GarageBand용 Export 폴더를 생성한다.
6. 사용자가 GarageBand에서 파일을 불러와 추가 편집한다.

---

# 10. 정보 구조

최종 제품은 다음 여섯 개의 주요 작업 모드로 구성한다. MVP에서는 Main, Sample Edit, Sequencer의 핵심 기능만 완성하고 Program Edit와 Mixer는 필수 파라미터를 다루는 축약 UI로 제공한다. Song 모드는 MVP 범위에서 제외한다.

1. Main
2. Sample Edit
3. Program Edit
4. Sequencer
5. Mixer
6. Song - MVP 이후

## 10.1 Main

현재 프로젝트와 연주 상태를 한눈에 확인하는 기본 화면이다.

표시 요소:

- 프로젝트 이름
- 현재 Sequence
- 현재 Track
- BPM
- Swing
- 마디 수
- Play, Stop, Record, Overdub
- 선택된 Program
- 16개 패드
- 트랙패드 터치 위치
- Pad 상태
- 기본 Mixer 정보

## 10.2 Sample Edit

원본 오디오를 편집하고 Slice를 생성하는 화면이다.

표시 요소:

- 전체 Waveform
- 확대 및 축소
- Playhead
- Start Marker
- End Marker
- Chop Marker
- Slice 목록
- Trim, Crop, Normalize, Reverse
- Auto Chop
- Equal Slice
- Manual Chop
- Slice to Pads

## 10.3 Program Edit

각 패드에 할당된 샘플의 재생 방식을 편집한다.

표시 요소:

- 선택된 Pad
- 연결된 Sample
- Start 및 End
- Tune
- Fine Tune
- Volume
- Pan
- Filter
- Resonance
- Attack
- Decay
- Sustain
- Release
- One Shot 또는 Hold
- Mono 또는 Poly
- Choke Group
- Velocity 반응
- Reverse
- Pad Color

## 10.4 Sequencer

연주한 내용을 녹음하고 패턴으로 편집한다.

표시 요소:

- Timeline
- Step Grid
- Piano Roll
- Velocity Lane
- Track 목록
- Quantize
- Swing
- Sequence Length
- Loop
- Undo 및 Redo
- Track Mute
- Track Solo

## 10.5 Mixer

패드, 트랙 및 Master의 음량과 이펙트를 조절한다.

표시 요소:

- Pad Mixer
- Track Mixer
- Master Channel
- Volume Fader
- Pan
- Mute
- Solo
- Peak Meter
- Insert Effect
- Send Effect

## 10.6 Song

여러 Sequence를 배열해 곡 구조를 만드는 화면이다.

표시 요소:

- Sequence 목록
- 재생 순서
- 반복 횟수
- Intro, Verse, Hook 등 사용자 Label
- 전체 곡 길이
- Song Export

Song 모드는 MVP 이후에 제공할 수 있다.

---

# 11. 기능 요구사항

이 장은 최종 제품의 기능 후보를 포함한다. MVP 포함 여부는 각 항목의 설명과 20장 MVP 범위를 우선 기준으로 판단한다.

## 11.1 프로젝트 관리

### MVP 필수 기능

- 새 프로젝트 생성
- 프로젝트 이름 변경
- 프로젝트 저장
- 다른 이름으로 저장
- 최근 프로젝트 목록
- 자동 저장
- 앱 종료 시 저장되지 않은 변경 경고

### MVP 이후 기능

- 프로젝트 복제
- 프로젝트 삭제

### 프로젝트에 포함되는 데이터

- 원본 샘플 파일
- 녹음 파일
- Slice 위치
- Pad 배치
- Pad 설정
- Sequence
- Track
- Mixer 설정
- Effect 설정 - MVP 이후
- BPM
- Swing
- UI 상태

---

## 11.2 오디오 Import

### 지원 파일 형식

초기 지원:

- WAV
- AIFF
- MP3
- M4A

### Import 방식

- 파일 선택 창
- Finder Drag and Drop
- Sample Browser에서 선택
- 최근 파일에서 선택

### 요구사항

- Import 시 오디오 길이와 포맷 표시
- 너무 긴 음원은 사용자에게 알림
- 원본 파일을 참조하거나 프로젝트 내부로 복사하는 옵션
- 샘플 로딩 진행 상태 표시
- 지원하지 않는 파일에 대한 오류 안내

---

## 11.3 오디오 녹음

### 입력 소스

- MacBook 내장 마이크
- 연결된 외부 마이크
- 오디오 인터페이스

### 녹음 기능

- 입력 장치 선택
- 입력 레벨 미터
- 모니터링 On/Off
- Record
- Pause
- Stop
- Count-in
- 녹음 취소
- 녹음 후 자동 Trim
- 녹음 이름 지정

### 후속 기능

- 시스템 오디오 녹음
- Loopback 입력
- Resampling
- 앱 내부 Master 출력 재녹음

---

## 11.4 Waveform 편집

### MVP 필수 기능

- Waveform 렌더링
- 재생 위치 표시
- 클릭하여 재생 위치 이동
- 확대 및 축소
- 수평 스크롤
- 구간 선택
- Selection 반복 재생
- Start와 End Marker 이동
- Snap On/Off
- Zero Crossing 보정

### 편집 도구

- Trim
- Crop
- Normalize
- Reverse
- Fade In
- Fade Out
- Silence
- Duplicate
- Delete Selection
- Convert Mono
- Rename

### 편집 원칙

기본 편집은 비파괴 방식으로 저장한다. 사용자가 명시적으로 새로운 오디오 파일을 생성할 때만 렌더링한다.

---

## 11.5 Chop 및 Slice

### Manual Chop

- 사용자가 Waveform을 클릭해 Chop Marker를 추가한다.
- Marker를 드래그해 위치를 수정한다.
- Marker를 선택해 삭제할 수 있다.
- Marker 사이의 영역을 하나의 Slice로 생성한다.

### Equal Slice

다음 분할을 제공한다.

- 2 Slice
- 4 Slice
- 8 Slice
- 16 Slice
- 32 Slice

### MVP 이후: Auto Chop

오디오 Transient를 감지해 자동으로 Slice를 생성한다.

사용자가 민감도를 조절할 수 있어야 한다.

- Low
- Medium
- High
- Custom Threshold

### MVP 이후: BPM Slice

음원의 BPM과 박자를 기준으로 Slice를 생성한다.

예:

- 1 Bar
- 1/2 Bar
- 1/4 Note
- 1/8 Note
- 1/16 Note

### Slice 관리

- Slice 이름 변경
- Slice 색상 변경
- Slice 미리 듣기
- Slice 순서 변경
- Slice 삭제
- Slice 복제
- Slice Reverse
- Slice를 개별 파일로 Export
- Slice를 Pad에 Drag and Drop

---

## 11.6 16개 패드

### 기본 구조

패드는 4×4 Grid로 구성한다.

```text
13  14  15  16
09  10  11  12
05  06  07  08
01  02  03  04

```

트랙패드의 왼쪽 아래 영역은 Pad 1, 오른쪽 위 영역은 Pad 16으로 매핑한다.

### 패드 상태

- Empty
- Loaded
- Selected
- Triggered
- Muted
- Solo
- Recording
- Choked

### 패드 입력 방식

- 트랙패드 터치
- 트랙패드 클릭
- 화면 패드 클릭
- 컴퓨터 키보드
- 외부 MIDI 입력 - MVP 이후

### MVP 이후: Pad Bank

MVP 이후 다음 Bank를 제공할 수 있다.

- Bank A
- Bank B
- Bank C
- Bank D

각 Bank는 16개의 Pad를 포함한다.

---

## 11.7 트랙패드 연주 모드

Trackpad Performance Mode는 제품의 핵심 차별화 기능이다.

### 활성화 방식

사용자는 다음 방식 중 하나를 선택할 수 있다.

- 화면의 Trackpad Mode 버튼
- 지정된 키를 누르고 있는 동안 활성화
- 전체 화면 Performance Mode
- 항상 활성화

기본값은 오작동을 줄이기 위해 `Hold to Activate`로 설정한다.

### 입력 모드

#### Touch Trigger

손가락이 트랙패드에 닿으면 즉시 Pad를 실행한다.

#### Click Trigger

트랙패드를 실제로 클릭했을 때만 실행한다.

#### Slide Trigger

손가락이 다른 Pad 영역으로 이동하면 새로운 Pad를 실행한다.

#### Hold Mode

손가락이 닿아 있는 동안 Sample을 재생하고 손을 떼면 중지한다.

### 멀티터치

- 여러 손가락으로 여러 Pad를 동시에 실행할 수 있어야 한다.
- 각 Touch는 고유 식별자로 관리한다.
- 한 Touch가 같은 Pad 안에서 움직이는 경우 중복 Trigger를 방지한다.
- Slide Trigger가 켜진 경우에만 다른 영역 진입 시 재실행한다.

### 경계 처리

Pad 경계에서 입력이 반복되지 않도록 Dead Zone 또는 Hysteresis를 적용한다.

### 시각적 피드백

화면의 가상 트랙패드에 다음 정보를 표시한다.

- 손가락 위치
- 현재 선택 영역
- 활성 Pad
- 여러 손가락의 위치
- Trigger 상태

### Velocity

MVP에서는 다음 옵션만 제공한다.

- Fixed Velocity
- 사용자 설정 Velocity

터치 크기 또는 이동 속도를 활용한 Velocity 추정과 정확한 압력 기반 Velocity는 기기 지원 범위에 따라 MVP 이후 기능으로 검토한다.

---

## 11.8 Pad Program 설정

각 Pad는 다음 파라미터를 가진다.

### Sample

- 연결된 Sample
- Sample 교체
- Sample 제거
- Layer 추가 - MVP 이후

### 재생 설정

- One Shot
- Hold
- Toggle Loop - MVP 이후
- Mono
- Poly
- Retrigger

### Pitch

- Tune
- Fine Tune
- Root Note - MVP 이후
- Pitch Tracking - MVP 이후

### Amp Envelope

- Attack
- Decay
- Sustain
- Release

### Filter

- Low-pass - MVP 이후
- High-pass - MVP 이후
- Band-pass - MVP 이후
- Cutoff - MVP 이후
- Resonance - MVP 이후
- Filter Envelope Amount - MVP 이후

### Mixer

- Volume
- Pan
- Mute
- Solo
- Output Routing - MVP 이후

### Choke Group

같은 Choke Group의 다른 Pad가 실행되면 이전 Sample 재생을 중단한다.

예:

- Closed Hi-Hat
- Open Hi-Hat

---

## 11.9 퍼포먼스 기능

### MVP 이후: Full Level

모든 Pad를 최대 Velocity로 실행한다.

### MVP 이후: 16 Levels

선택한 Sample 또는 Pad 설정을 16단계로 나눠 전체 Pad에 배치한다.

지원 대상:

- Velocity
- Pitch
- Filter
- Attack
- Pan

### MVP 이후: Note Repeat

선택한 간격에 맞춰 Pad를 반복 실행한다.

지원 간격:

- 1/4
- 1/8
- 1/8T
- 1/16
- 1/16T
- 1/32

### MVP 이후: Pad Mute

Pad를 누르면 해당 Pad의 Mute 상태를 전환한다.

### MVP 이후: Track Mute

Pad를 눌러 Track을 실시간으로 켜거나 끈다.

### Tap Tempo

사용자가 버튼을 반복해서 누르면 BPM을 계산한다.

---

## 11.10 시퀀서

### Transport

- Play
- Stop
- Record
- Overdub
- Return to Start
- Loop
- Metronome
- Count-in

### Sequence 설정

- 이름
- BPM
- Time Signature
- Bar Length
- Loop Range
- Swing
- Quantize

### 녹음

Pad 연주 시 다음 정보를 저장한다.

- Pad ID
- Track ID
- 시작 Beat
- 길이
- Velocity
- 필요 시 Automation 값

### Overdub

기존 패턴을 유지하면서 새로운 연주를 추가한다.

### Erase

재생 중 특정 Pad를 누르면서 해당 Pad의 이벤트를 삭제할 수 있다.

### Quantize

지원 Grid:

- Off
- 1/4
- 1/8
- 1/8T
- 1/16
- 1/16T
- 1/32

### Swing

사용자가 Swing 비율을 조절할 수 있어야 한다.

### Step Sequencer

- 16, 32, 64 Step
- Step On/Off
- Velocity 단계
- Step Probability는 후속 기능
- Micro Timing은 후속 기능

### MVP 이후: Piano Roll

- Event 이동
- 길이 변경
- 복사
- 삭제
- Velocity 편집
- Grid Snap
- 확대 및 축소

Piano Roll은 MVP 이후 제공할 수 있다.

---

## 11.11 Track

초기 버전에서는 최소 8개 Track을 지원한다.

각 Track은 다음 정보를 가진다.

- 이름
- 연결된 Program
- MIDI 이벤트
- Volume
- Pan
- Mute
- Solo
- Effect
- 색상

후속 버전에서는 16개 이상의 Track을 지원한다.

---

## 11.12 Mixer

### Pad Mixer

각 Pad의 음량과 Pan을 조절한다.

### Track Mixer

각 Track의 음량과 Pan을 조절한다.

### Master Mixer

전체 출력의 음량을 조절한다. Master Effect는 MVP 이후 범위로 둔다.

### Meter

- Peak Level
- Clipping 표시
- Master Stereo Meter

---

## 11.13 Effects

### MVP 오디오 처리 범위

MVP에서는 독립 Effect 체인을 구현하지 않는다. 기본 재생 품질과 Export 안정성을 우선한다.

- Pad Volume
- Pad Pan
- Pad Tune
- Pad Reverse
- Choke Group
- Master Volume
- Peak Meter

### MVP 이후 Effect

- Low-pass Filter
- High-pass Filter
- EQ
- Compressor
- Reverb
- Delay
- Bitcrusher
- Saturation

### Effect 위치

- Pad Insert
- Track Insert
- Master Insert

### 장기 Effect 후보

- Chorus
- Phaser
- Flanger
- Stutter
- Tape Stop
- Vinyl Noise
- Performance XY Effect

---

## 11.14 저장 및 Export

### 프로젝트 저장

TrackChop 전용 프로젝트 형식을 사용한다.

예시:

```text
MyBeat.trackchop

```

프로젝트 패키지에는 다음이 포함된다.

```text
MyBeat.trackchop/
├── project.json
├── Samples/
├── Recordings/
├── Cache/
└── Waveforms/

```

### 오디오 Export

- Master WAV
- Master AIFF - MVP 이후
- 개별 Track Stem - MVP 이후
- 개별 Pad Stem - MVP 이후
- Loop Export - MVP 이후
- 선택 구간 Export - MVP 이후

### MVP 이후: MIDI Export

- 전체 Sequence
- 선택된 Track
- Pattern별 MIDI

### MVP 이후: Sample Pack Export

- 사용된 Slice
- Pad Mapping 정보
- Program Preset

---

## 11.15 MVP 이후: GarageBand 연동

GarageBand 연동은 Export 메뉴 안에 부가기능으로 배치한다.

### Send to GarageBand

사용자는 다음 항목을 선택할 수 있다.

- Master WAV
- Track Stems
- MIDI Pattern
- 개별 Slice
- 전체 Sample Pack

Export 결과 예시:

```text
My Beat - GarageBand Export/
├── My Beat.mid
├── Master.wav
├── Stems/
│   ├── Track 01.wav
│   ├── Track 02.wav
│   └── Track 03.wav
├── Samples/
│   ├── Pad 01.wav
│   ├── Pad 02.wav
│   └── Pad 16.wav
└── README.txt

```

초기 버전에서는 GarageBand 프로젝트 파일을 직접 생성하지 않는다.

후속 버전에서 TrackChop Audio Unit 플러그인을 제작하면 GarageBand 안에서 TrackChop의 Pad Program을 직접 불러오고 MIDI로 수정할 수 있다.

---

# 12. 화면 디자인 요구사항

## 12.1 디자인 방향

- 하드웨어 샘플러 워크스테이션 감성
- 다크 차콜 또는 블랙 배경
- 높은 정보 밀도
- 물리 장비처럼 구분된 패널
- 밝은 LED 포인트
- 두껍고 입체적인 Pad
- 작은 LCD 스타일 정보 영역
- 명확한 상태 표시

## 12.2 색상 방향

기본 색상 예시:

- Background: Charcoal Black
- Panel: Dark Gray
- Text: Warm White
- Primary Accent: Amber 또는 Orange
- Record: Red
- Play: Green
- Selected Pad: Yellow 또는 Orange
- Waveform: Cyan 또는 Mint

## 12.3 인터페이스 독창성

AKAI MPC Sample의 패널 레이아웃, Pad 그리드 배치, 색상 톤은 시각적 레퍼런스로 가깝게 따른다. 다음 요소는 자체적으로 디자인한다.

- 로고
- 아이콘
- 글꼴
- Tab 구조
- 메뉴 배치

---

# 13. 메인 화면 레이아웃

메인 화면은 하드웨어 샘플러에서 기대되는 물리적 조작감, 높은 정보 밀도, 명확한 패드 영역을 참고하되 특정 제품의 시각 구성을 복제하지 않는다.

16개 패드는 Main 화면에서 항상 접근 가능해야 한다.

---

# 14. 키보드 단축키

초기 단축키 예시:

- Space: Play / Stop
- R: Record
- O: Overdub
- M: Metronome
- Command + S: Save
- Command + Z: Undo
- Command + Shift + Z: Redo
- 숫자 및 문자 키: 16 Pads
- Shift Hold: Trackpad Mode 활성화
- Delete: 선택 이벤트 삭제
- Command + E: Export

사용자가 단축키를 변경할 수 있는 설정을 후속 버전에서 제공한다.

---

# 15. 설정

## 오디오

- Input Device
- Output Device
- Sample Rate
- Buffer Size
- Monitoring
- Master Volume

## Trackpad

- Activation Mode
- Touch 또는 Click
- Slide Trigger
- Dead Zone
- Fixed Velocity
- Pad 방향
- 왼손잡이 Layout
- Finger 표시 On/Off

## Appearance

- UI Scale
- Waveform 색상
- Pad 밝기
- Animation On/Off

## Project

- Auto Save Interval
- Default BPM
- Default Bars
- Default Export Format

---

# 16. 기술 요구사항

## 16.1 개발 언어 및 프레임워크

- Swift
- SwiftUI
- AppKit
- AVFoundation
- AVAudioEngine
- Core MIDI
- SwiftData 또는 프로젝트 JSON 저장 구조

## 16.2 권장 구조

```text
TrackChop/
├── App/
├── UI/
│   ├── Main/
│   ├── SampleEditor/
│   ├── ProgramEditor/
│   ├── Sequencer/
│   ├── Mixer/
│   └── Components/
├── AudioEngine/
│   ├── Playback/
│   ├── Recording/
│   ├── Mixer/
│   ├── Effects/
│   └── Rendering/
├── Trackpad/
│   ├── TouchCapture/
│   ├── PadMapping/
│   └── GestureState/
├── Sequencer/
├── Models/
├── ProjectStorage/
├── Export/
└── Utilities/

```

## 16.3 트랙패드 구현

- AppKit 기반 Custom NSView 사용
- 간접 Touch 입력 수신
- 정규화된 트랙패드 좌표를 4×4 영역으로 변환
- Touch Identity별 상태 관리
- 멀티터치 동시 입력 처리
- Touch Begin, Move, End 처리
- NSView를 SwiftUI에서 사용할 수 있도록 Wrapper 구성

### 기술 검증 조건

트랙패드 구현은 본 개발 전에 별도 Spike로 검증한다. Spike가 실패하면 MVP 입력 체계는 화면 Pad와 키보드를 기본으로 하고, 트랙패드 연주는 실험 기능으로 낮춘다.

검증 대상:

- macOS 14 이상, Apple Silicon MacBook 내장 트랙패드
- 앱이 foreground이고 Trackpad Performance View가 활성화된 상태
- AppKit `NSEvent` Touch 이벤트에서 Touch identity, normalized position, phase를 안정적으로 읽을 수 있는지 확인
- 두 손가락 이상의 동시 입력이 Pad trigger로 분리되는지 확인
- 일반 cursor 이동, scroll, system gesture와 충돌하지 않는 activation mode 확인
- Force Touch pressure 값은 필수 입력값으로 사용하지 않음

MVP에서 보장하지 않는 항목:

- 모든 외장 트랙패드 지원
- background 상태 입력
- 시스템 gesture를 가로채는 동작
- 정밀 pressure 기반 Velocity
- macOS accessibility 권한 없이 전역 트랙패드 입력 수집

## 16.4 오디오 엔진

오디오 엔진은 다음 기능을 지원해야 한다.

- 동시에 여러 Sample 재생
- 낮은 지연 시간
- Pad별 Mixer
- Choke Group
- Pitch 변경
- Envelope - MVP 이후
- Filter - MVP 이후
- Effect Chain - MVP 이후
- Offline Rendering
- WAV Export

UI Thread와 오디오 재생 처리 Thread를 분리해야 한다.

---

# 17. 성능 요구사항

## 오디오 지연

트랙패드 또는 화면 Pad 입력부터 Sample 재생 시작까지의 지연은 다음을 목표로 한다.

- p50 15ms 이하
- p95 30ms 이하
- 최악의 경우에도 50ms 이하

측정 기준은 메모리에 로드된 16bit 또는 24bit WAV Sample을 재생하는 상황으로 한다. 디스크 로딩, waveform 분석, export 작업은 입력 처리 경로에서 분리한다.

## 동시 재생

최소 16개 Sample을 동시에 안정적으로 재생할 수 있어야 한다. 4마디 Loop 재생 중 audible drop-out이 없어야 하며, 10분간 반복 재생 테스트에서 오디오 엔진 crash가 없어야 한다.

## 프로젝트 규모

MVP 권장 기준:

- 최대 8 Track
- Track당 최대 2,000개 Event
- 최대 64개 Sample
- 최대 10분 길이의 원본 Sample

## Waveform

10분 길이의 stereo WAV 파일을 불러올 때 UI thread가 100ms 이상 연속으로 멈추지 않아야 한다. Waveform peak data는 비동기로 생성하고 프로젝트 Cache에 저장한다.

## 저장

자동 저장은 오디오 재생 thread와 분리한다. 재생 중 자동 저장으로 audible drop-out이 발생하면 release blocker로 처리한다.

---

# 18. 개인정보 및 권한

앱은 다음 권한을 사용할 수 있다.

- 마이크 접근
- 사용자가 선택한 파일 접근
- 오디오 입력 장치 접근

앱은 사용자의 오디오 파일을 기본적으로 외부 서버에 전송하지 않는다.

모든 샘플 편집 및 비트 제작은 로컬에서 처리한다.

---

# 19. 오류 및 예외 처리

다음 상황에 대한 안내가 필요하다.

- 지원하지 않는 오디오 파일
- 손상된 오디오 파일
- 마이크 권한 거부
- 오디오 장치 연결 해제
- 저장 공간 부족
- Sample 파일 위치 변경
- 프로젝트 파일 손상
- Export 실패
- Audio Engine 시작 실패
- 트랙패드 Touch 입력을 사용할 수 없는 기기

MacBook 외 Mac에서는 화면 Pad와 키보드를 기본 입력 수단으로 제공한다. 외부 MIDI 입력은 MVP 이후 범위로 둔다.

---

# 20. MVP 범위

## 반드시 포함

- 새 프로젝트
- WAV, MP3, AIFF, M4A Import
- 마이크 녹음
- Waveform 표시
- Start 및 End 편집
- Manual Chop
- Equal 4, 8, 16 Slice
- Slice를 16 Pad에 자동 배치
- 화면 16 Pad
- MacBook 트랙패드 4×4 입력 - Phase 0 Spike 통과 조건
- 멀티터치 - Phase 0 Spike 통과 조건
- One Shot 및 Hold
- Volume
- Pan
- Tune
- Reverse
- Choke Group
- BPM
- Metronome
- Record
- Overdub
- Loop
- Quantize
- Swing
- 간단한 Step Sequencer
- 프로젝트 저장 및 불러오기
- Master WAV Export

## MVP에서 제외

- Auto Transient Chop
- BPM Slice
- 독립 Effect Chain
- Piano Roll
- Song Mode
- 여러 Pad Bank
- Advanced Time Stretch
- Audio Unit
- 클라우드 동기화
- 온라인 Sample Store
- Stem Export
- MIDI Export
- Send to GarageBand
- GarageBand 자동 프로젝트 생성
- 외부 플러그인

---

# 21. 2차 출시 기능

- Auto Chop
- Transient Sensitivity
- 16 Levels
- Note Repeat
- Full Level
- Pad Mute
- Track Mute
- Pad Bank A-D
- Filter 및 ADSR 확장
- Track Mixer
- Insert Effect
- Stem Export
- MIDI Export
- Send to GarageBand
- Piano Roll
- Sample Browser
- 기본 Sample Pack

---

# 22. 장기 기능

- Song Mode
- Time Stretch
- Warp
- Resampling
- Audio Unit Instrument
- GarageBand 및 Logic Pro 내부 플러그인
- 외부 MIDI Controller
- MIDI Learn
- 사용자 Sample Pack 제작
- 커뮤니티 Sample Pack
- 프로젝트 공유
- Cloud Backup
- iPad Companion
- macOS 메뉴바 Performance Mode

---

# 23. 출시 단계

## Phase 0 - 기술 검증

목표:

- 트랙패드 전체 좌표 감지
- 4×4 영역 계산
- 멀티터치 처리
- Sample 즉시 재생
- 오디오 지연 확인

완료 기준:

- 서로 다른 영역을 터치했을 때 정확한 Pad가 실행된다.
- 두 개 이상의 Pad를 동시에 실행할 수 있다.
- 빠른 연타 시 입력 누락이 심하지 않다.
- p95 입력 지연이 30ms 이하로 측정된다.
- 트랙패드 입력이 불안정한 환경에서는 화면 Pad와 키보드 fallback이 즉시 사용 가능하다.

## Phase 1 - Sample Playground

목표:

- Import
- Waveform
- Chop
- 16 Pads
- Trackpad Mode

완료 기준:

- 사용자가 음원을 넣고 16개 Slice를 만든 뒤 트랙패드로 연주할 수 있다.

## Phase 2 - Beat Recording

목표:

- BPM
- Metronome
- Record
- Overdub
- Quantize
- Loop
- Step Sequencer

완료 기준:

- 사용자가 4마디 이상의 반복 패턴을 만들고 저장할 수 있다.

## Phase 3 - Sound Design

목표:

- Tune
- Envelope
- Filter
- Choke
- Mixer
- Effects

완료 기준:

- 사용자가 앱 안에서 기본적인 믹싱과 사운드 편집을 완료할 수 있다.

## Phase 4 - Export

목표:

- Master WAV
- Stems
- MIDI
- GarageBand Export

완료 기준:

- TrackChop에서 만든 결과를 다른 음악 제작 앱으로 옮길 수 있다.

---

# 24. 성공 지표

## 사용자 경험 지표

- 앱 실행부터 첫 Sample 재생까지 걸리는 시간
- 첫 프로젝트에서 Chop 완료율
- Trackpad Mode 사용률
- 프로젝트 저장 완료율
- 비트 Export 완료율
- 사용자당 평균 연주 세션 길이

## 핵심 목표

- 신규 사용자의 70% 이상이 첫 실행에서 Sample을 Import하거나 녹음한다.
- 신규 사용자의 50% 이상이 첫 세션에서 Trackpad Mode를 사용한다.
- 신규 사용자의 30% 이상이 첫 세션에서 패턴을 녹음한다.
- 사용자가 5분 이내에 첫 Loop를 완성할 수 있다.

---

# 25. 주요 위험 요소

## 트랙패드 입력 제약

macOS의 Touch 이벤트 전달 방식과 앱 활성 상태에 따라 입력 범위가 달라질 수 있다.

대응:

- 기술 검증을 가장 먼저 진행한다.
- Trackpad Mode 활성 상태를 명확하게 표시한다.
- 화면 Pad와 키보드 입력을 대체 수단으로 제공한다.

## 오디오 지연

지연이 크면 제품의 핵심 경험이 무너진다.

대응:

- Sample을 미리 메모리에 로딩한다.
- 재생 시 파일을 새로 읽지 않는다.
- 적절한 Buffer Size 설정을 제공한다.
- 오디오 Thread에서 무거운 작업을 수행하지 않는다.

## 기능 과다

처음부터 하드웨어 샘플러의 모든 기능을 구현하면 개발 범위가 지나치게 커질 수 있다.

대응:

- MVP에서는 Import, Chop, Trackpad, Recording에 집중한다.
- 고급 기능은 단계별로 추가한다.
- 핵심 경험을 방해하는 기능은 후순위로 둔다.

## 브랜드 유사성

AKAI MPC Sample을 레이아웃·색상 레퍼런스로 가깝게 따르기로 했으므로, 로고·제품명·저작권 그래픽 노출은 법적 또는 브랜드 문제를 일으킬 수 있다.

대응:

- 제품명과 로고, 아이콘, 글꼴은 독립적으로 제작한다.
- AKAI, MPC 등 타사 명칭과 로고는 UI, 자료, 마케팅에 노출하지 않는다.
- 패널 레이아웃, Pad 그리드, 색상 톤은 참고하되 저작권 그래픽 에셋(사진, 아이콘 이미지 등)은 직접 사용하지 않고 새로 그린다.

---

# 26. MVP 완료 기준

다음 시나리오가 모두 작동하면 MVP가 완성된 것으로 본다. 단, 트랙패드 입력은 Phase 0 Spike 통과를 전제로 한다. Spike가 실패한 경우에는 화면 Pad와 키보드 입력으로 동일한 시나리오를 완료하고, 트랙패드 기능은 실험 기능으로 표시한다.

1. 사용자가 앱을 실행한다.
2. MP3 또는 WAV 파일을 불러온다.
3. Waveform에서 16개의 Slice를 만든다.
4. Slice가 16개 Pad에 배치된다.
5. 사용자가 트랙패드의 서로 다른 위치를 터치해 Sample을 연주한다.
6. 여러 손가락으로 동시에 Sample을 실행한다.
7. 연주를 4마디 Pattern으로 녹음한다.
8. BPM, Quantize, Swing을 변경한다.
9. Pattern을 반복 재생한다.
10. 프로젝트를 저장하고 다시 연다.
11. 완성된 Loop를 WAV로 Export한다.

---

# 27. 최종 제품 정의

TrackChop은 단순한 트랙패드 MIDI 컨트롤러가 아니다.

TrackChop은 다음 요소를 하나의 앱에 결합한 독립형 음악 제작 도구다.

- Sample Recorder
- Waveform Editor
- Sample Chopper
- 16 Pad Sampler
- Trackpad Instrument
- Pattern Sequencer
- Mixer
- Effect Processor
- Audio Exporter

제품에서 가장 우선해야 하는 경험은 다음과 같다.

> 사용자가 좋아하는 음원을 넣고, 원하는 부분을 자르고, MacBook 트랙패드를 직접 두드려 자신만의 비트를 만드는 것.

GarageBand 연동은 이 경험을 대체하지 않는다. TrackChop에서 완성한 결과를 더 큰 프로젝트로 확장하고 싶은 사용자를 위한 선택적 기능으로 제공한다.
