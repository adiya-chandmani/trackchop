# TrackChop 7-Day Development Plan

## 1. 목표

7일 안에 TrackChop의 핵심 경험을 검증 가능한 macOS MVP 빌드로 만든다.

핵심 경험:

1. 사용자가 오디오 파일을 불러온다.
2. Waveform에서 구간을 자르거나 4, 8, 16 Slice로 나눈다.
3. Slice가 16개 Pad에 배치된다.
4. 화면 Pad 또는 MacBook 트랙패드로 Sample을 연주한다.
5. 4마디 Pattern을 녹음하고 반복 재생한다.
6. 프로젝트를 저장하고 다시 연다.
7. 완성된 Loop를 WAV로 Export한다.

## 2. 7일 개발 범위

### 반드시 구현

- Swift, SwiftUI, AppKit 기반 macOS 앱
- New Project
- WAV, AIFF, MP3, M4A Import
- 마이크 녹음
- Waveform 표시
- Start, End Marker 편집
- Manual Chop
- Equal 4, 8, 16 Slice
- Slice to 16 Pads
- 화면 16 Pad 연주
- MacBook 트랙패드 4x4 Pad 입력
- 트랙패드 멀티터치 Spike 및 가능 시 MVP 반영
- One Shot 재생
- Hold 재생
- Pad Volume
- Pad Pan
- Pad Tune
- Pad Reverse
- Choke Group
- BPM
- Metronome
- Record
- Overdub
- Loop playback
- Quantize 1/8, 1/16
- Swing
- 간단한 Step Sequencer
- 프로젝트 Save, Load
- Master WAV Export

### 7일 안에 제외

- Auto Transient Chop
- BPM Slice
- 독립 Effect Chain
- EQ, Compressor, Reverb, Delay, Bitcrusher, Saturation
- Piano Roll
- Song Mode
- 여러 Pad Bank
- Stem Export
- MIDI Export
- Send to GarageBand
- Audio Unit
- 외부 MIDI 입력
- Cloud Sync
- Sample Store
- Time Stretch
- Warp

## 3. 개발 전제

- 대상 OS: macOS 14 이상
- 대상 기기: Apple Silicon MacBook 내장 트랙패드
- 개발 환경: Xcode 최신 안정 버전
- 저장 방식: `.trackchop` 패키지 폴더와 `project.json`
- 오디오 재생: `AVAudioEngine`
- 오디오 파일 로딩 및 Export: `AVFoundation`
- UI: SwiftUI 중심, 트랙패드 입력은 AppKit `NSView` wrapper 사용
- Bundle Identifier: `com.chandmani.trackchop`
- App Sandbox: 처음부터 적용 (마이크 entitlement, 파일 import/저장은 security-scoped bookmark 사용)
- 버전 관리: git, Day/단계별 커밋

## 4. 기술 리스크 컷라인

트랙패드 입력은 Day 1 안에 반드시 Spike로 검증한다.

### Spike 통과 기준

- Trackpad Performance View가 foreground일 때 touch position을 읽을 수 있다.
- 정규화 좌표를 4x4 Pad index로 변환할 수 있다.
- 두 손가락 이상의 입력을 분리할 수 있다.
- 빠른 연타에서 Pad trigger 누락이 심하지 않다.
- p95 입력 지연이 30ms 이하로 측정된다.

### Spike 실패 시 처리

- 화면 Pad와 키보드 입력을 MVP 기본 입력으로 확정한다.
- 트랙패드 기능은 `Experimental Trackpad Mode`로 표시한다.
- Day 2 이후 일정은 트랙패드 안정화보다 오디오, Chop, Sequencer, 저장, Export를 우선한다.

## 5. 일별 계획

### Day 1 - Project Setup and Trackpad Spike

목표:

- 앱 골격을 만들고 트랙패드 입력 가능성을 검증한다.

작업:

- Xcode macOS app 프로젝트 생성
- 기본 폴더 구조 생성
  - `App`
  - `UI`
  - `AudioEngine`
  - `Trackpad`
  - `Sequencer`
  - `Models`
  - `ProjectStorage`
  - `Export`
- Main 화면 shell 구현
- 4x4 Pad Grid UI 구현
- AppKit `NSViewRepresentable`로 Trackpad Capture View 구현
- Touch begin, move, end logging
- Touch position을 Pad index로 변환
- 화면 Pad click trigger 구현
- 단일 Sample test playback spike

완료 기준:

- 앱이 실행된다.
- 16개 화면 Pad가 보인다.
- 화면 Pad를 누르면 test sound가 난다.
- 트랙패드 touch 좌표가 화면에 표시된다.
- 트랙패드 touch가 Pad 1-16 중 하나로 매핑된다.
- Day 1 종료 전에 trackpad go/no-go를 결정한다.

### Day 2 - Audio Import, Recording, Waveform, Basic Playback

목표:

- 사용자가 오디오 파일을 불러오거나 마이크로 녹음하고 waveform을 보며 재생할 수 있게 한다.

작업:

- File Import dialog 구현
- WAV, AIFF, MP3, M4A 로딩
- Audio file metadata 표시
  - file name
  - duration
  - sample rate
  - channel count
- 마이크 권한 요청 (App Sandbox mic entitlement)
- 입력 장치 선택, 입력 레벨 미터
- Record, Pause, Stop
- 녹음본을 프로젝트 Recordings/에 저장
- Waveform peak data 생성
- Waveform rendering
- Playhead 표시
- Start, End Marker 표시
- Start, End Marker drag 편집
- 선택 구간 playback
- 긴 파일 로딩 시 progress 표시

완료 기준:

- 오디오 파일을 import할 수 있다.
- 마이크로 녹음하고 녹음된 waveform을 볼 수 있다.
- 10분 이하 오디오의 waveform이 표시된다.
- Start, End Marker를 움직일 수 있다.
- 선택 구간을 재생할 수 있다.
- 지원하지 않는 파일에 오류 메시지가 나온다.

### Day 3 - Chop and Slice to Pads

목표:

- 오디오를 Slice로 나누고 16 Pad에 배치한다.

작업:

- Manual Chop Marker 추가, 이동, 삭제
- Marker 사이 구간을 Slice로 변환
- Equal 4 Slice
- Equal 8 Slice
- Equal 16 Slice
- Slice list 구현
- Slice preview playback
- Slice to Pads 자동 배치
- Pad loaded, selected, triggered 상태 표시
- Pad별 sample start, end 참조 저장

완료 기준:

- 사용자가 waveform 위에서 Chop Marker를 만들 수 있다.
- Equal 4, 8, 16 Slice가 정확히 생성된다.
- Slice가 16 Pad에 순서대로 배치된다.
- 각 Pad를 누르면 해당 Slice가 재생된다.

### Day 4 - Pad Program and Low Latency Playback

목표:

- Pad 연주 품질을 MVP 수준으로 만든다.

작업:

- `AVAudioEngine` 기반 Sample playback manager 구현
- Pad별 One Shot
- Pad별 Hold
- Pad Volume
- Pad Pan
- Pad Tune
- Pad Reverse
- Choke Group
- 동시 16 Sample 재생 테스트
- Pad trigger latency 측정 helper 추가
- Trackpad Mode UI 상태 표시
- Dead Zone 또는 hysteresis 적용
- 키보드 16 Pad mapping 추가

완료 기준:

- 16개 Pad가 빠르게 연타되어도 앱이 멈추지 않는다.
- 최소 16개 Sample 동시 재생이 가능하다.
- One Shot과 Hold가 구분된다.
- Choke Group이 동작한다.
- 화면 Pad, 키보드, 트랙패드 입력 중 사용 가능한 입력으로 연주할 수 있다.

### Day 5 - Sequencer, Record, Loop

목표:

- 사용자가 연주를 4마디 Pattern으로 녹음하고 반복 재생할 수 있게 한다.

작업:

- Transport 구현
  - Play
  - Stop
  - Record
  - Overdub
  - Return to Start
  - Loop
- BPM 설정
- Metronome 구현
- Count-in 최소 구현
- Sequence model 구현
- Pad event recording
  - pad id
  - start beat
  - length
  - velocity
- 4마디 Loop playback
- Quantize 1/8, 1/16
- Swing 적용
- 간단한 Step Sequencer 구현
- Undo는 최소 1단계만 지원하거나 Day 7로 이동

완료 기준:

- 4마디 Pattern을 녹음할 수 있다.
- Overdub로 새 Pad event를 추가할 수 있다.
- Pattern이 loop로 반복 재생된다.
- BPM 변경이 playback timing에 반영된다.
- Quantize와 Swing이 들리는 수준으로 적용된다.

### Day 6 - Project Save, Load, WAV Export

목표:

- 만든 프로젝트를 저장, 복원, WAV Export할 수 있게 한다.

작업:

- `.trackchop` package 구조 구현
  - `project.json`
  - `Samples`
  - `Recordings`
  - `Cache`
  - `Waveforms`
- Project JSON schema 정의
- Import file copy/reference 정책 구현
- Save
- Save As
- Load
- Recent Projects 최소 구현
- Unsaved changes warning
- Offline rendering pipeline 구현
- Master WAV Export
- Export progress 표시
- Export 실패 오류 처리

완료 기준:

- 프로젝트를 저장하고 앱 재실행 후 다시 열 수 있다.
- Pad mapping, Slice, Pattern, BPM이 복원된다.
- 4마디 Loop가 WAV 파일로 Export된다.
- Export한 WAV를 Finder에서 재생할 수 있다.

### Day 7 - Integration, QA, Polish

목표:

- 데모 가능한 안정 빌드로 묶는다.

작업:

- 전체 MVP flow QA
- 오류 상태 점검
  - unsupported file
  - missing sample file
  - microphone permission denied
  - audio engine start failure
  - export failure
- UI polish
  - Pad 상태 색상
  - transport 상태
  - waveform marker visibility
  - trackpad active indicator
- 성능 점검
  - p95 trigger latency 30ms 이하 목표
  - 16 voice playback
  - 10분 audio waveform load
  - 10분 loop playback stability
- crash fix
- README 또는 demo note 작성
- build archive 생성

완료 기준:

- 새 프로젝트에서 Export까지 1회 이상 끊김 없이 성공한다.
- 앱 crash 없이 10분간 4마디 Loop를 반복 재생한다.
- 저장한 프로젝트를 다시 열어 같은 Pattern을 재생한다.
- known issue가 `plan.md` 하단에 정리된다.

## 6. 매일 점검할 체크리스트

- 앱이 빌드된다.
- 앱이 실행된다.
- 기존 성공 flow가 깨지지 않았다.
- 오디오 재생 중 UI 조작으로 crash가 나지 않는다.
- 저장 파일이 열리지 않는 문제가 없다.
- 새로 추가한 기능은 최소 1개 수동 테스트 시나리오가 있다.
- scope creep 항목은 7일 범위 밖으로 이동했다.

## 7. 최종 MVP Acceptance Test

7일 차 종료 시 아래 시나리오를 녹화 또는 수동 기록으로 검증한다.

1. 앱 실행
2. New Project 생성
3. MP3 또는 WAV Import
4. Waveform 표시 확인
5. Equal 16 Slice 실행
6. Slice가 16 Pad에 자동 배치되는지 확인
7. 화면 Pad로 16개 Slice 재생
8. 가능한 경우 트랙패드 4x4 입력으로 Slice 재생
9. BPM 설정
10. Metronome 켜기
11. Record 시작
12. 4마디 Pattern 녹음
13. Quantize 1/16 적용
14. Swing 적용
15. Pattern loop playback
16. 프로젝트 저장
17. 앱 재실행
18. 프로젝트 다시 열기
19. Pattern 정상 재생 확인
20. Master WAV Export
21. Export된 WAV 파일 재생 확인

## 8. Known Issue 기록란

Day 7 종료 시 남은 문제를 여기에 기록한다.

- 작성 시점에는 없음. Day 7 종료 시 실제 남은 문제로 교체한다.

## 9. 개발 우선순위 원칙

7일 안에 판단이 필요한 경우 다음 순서로 우선한다.

1. 소리가 즉시 나는가
2. Chop과 Pad 배치가 작동하는가
3. Pattern을 녹음하고 반복 재생할 수 있는가
4. 프로젝트를 저장하고 다시 열 수 있는가
5. WAV Export가 되는가
6. 트랙패드 입력이 안정적인가
7. UI가 보기 좋고 명확한가

트랙패드가 핵심 차별점이지만, 트랙패드 안정화 때문에 Import, Chop, Playback, Recording, Save, Export가 밀리면 안 된다. Day 1 Spike가 불안정하면 fallback 입력으로 MVP를 완성한 뒤 트랙패드는 실험 기능으로 남긴다.
