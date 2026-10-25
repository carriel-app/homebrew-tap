# Carriel's Homebrew tap

[Carriel](https://carriel.app/) is a small Mac app: a pouch in the menu bar for
the private things you keep around, such as API keys, passwords, recovery
codes, notes and small files. This tap holds its cask.

## Install

```sh
brew install --cask carriel-app/tap/carriel
```

The full name taps `carriel-app/tap` and trusts this one cask, so there is
nothing else to set up. Carriel needs a Mac with Apple silicon and macOS 26
Tahoe or later.

Homebrew installs the same notarized app that
[carriel.app/download](https://carriel.app/download/) offers. Its SHA-256 is
in `Casks/carriel.rb`, on the download page and in
[Carriel's update manifest](https://dl.carriel.dev/pouch/stable.json). After
installing, `codesign -dv /Applications/Carriel.app` shows
`TeamIdentifier=RD9TC9MV83`, and `spctl -a -vv /Applications/Carriel.app`
says `source=Notarized Developer ID`.

## Updates

Carriel keeps itself up to date: Carriel Updater checks Carriel's signed
manifest about once a day, so the cask says `auto_updates true`.
`brew upgrade` replaces Carriel only when the copy on your Mac is older than
this cask, and `brew upgrade --greedy` whenever this cask is newer than the
version Homebrew installed. Either way Homebrew quits Carriel first and opens
it again afterwards. The cask follows the stable
channel only.

## Uninstall

The tidy way is in Carriel itself: **Settings › About › Remove Carriel…**
gives this Mac's place on your license back, deletes Carriel's files and keys
on this Mac, turns off its login item and moves the app to the Trash. Then
`brew uninstall --cask carriel` clears Homebrew's record of it.

`brew uninstall --cask carriel` on its own quits Carriel and removes the app,
and `--zap` also deletes the window's and Carriel Updater's files on this Mac.
Neither gives this Mac's place on your license back or deletes the pouch's
encrypted copy on this Mac (`~/Library/Containers/dev.carriel.app.agent`), and
neither touches your iCloud or iCloud Keychain. macOS may list Carriel in
**System Settings › General › Login Items** until you restart; it won't open.
[Uninstalling Carriel](https://carriel.app/help/uninstall/) says more.

## About this tap

Carriel's developer updates this cask with each stable release. Homebrew
doesn't support third-party taps: for help with Carriel, write to
support@lonelyduck.io.

## 한국어

캐리엘은 API 키, 암호, 복구 코드, 노트와 작은 파일을 담는 Mac 메뉴 막대의
파우치입니다. 터미널에서 다음 명령으로 설치하십시오. Apple 실리콘 Mac과
macOS 26 Tahoe 이상이 필요합니다.

```sh
brew install --cask carriel-app/tap/carriel
```

캐리엘은 스스로 업데이트합니다. 제거할 때는 먼저 캐리엘의
**설정 › 정보 › 캐리엘 제거…**를 고른 뒤 `brew uninstall --cask carriel`
명령을 실행하십시오. 자세한 내용은
[캐리엘 제거하기](https://carriel.app/ko/help/uninstall/)에 있습니다.
