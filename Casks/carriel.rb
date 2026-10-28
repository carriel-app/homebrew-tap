# ============================================================
# carriel.rb — the Homebrew cask for Carriel
# ============================================================
# WHY THIS EXISTS   2026-10-25. Carriel is sold directly as a notarized
#                   Developer ID download (D74), and its cask lives in its
#                   own tap, github.com/carriel-app/homebrew-tap (D78; live
#                   since launch day, 2026-10-25). From Carriel's
#                   .ai/docs/1.0.0/homebrew/carriel.rb (lane h3a, 2026-10-24,
#                   after 0.x's and subtank's). People install it by full
#                   name, which trusts this one cask and nothing else in the
#                   tap (Homebrew 6's tap trust):
#                     brew install --cask carriel-app/tap/carriel
# WHAT IT DOES      Installs the notarized dmg from dl.carriel.dev/pouch/,
#                   tells Homebrew the app updates itself (Carriel Updater,
#                   from Carriel's signed manifest), quits the window and the
#                   agent before an uninstall or an upgrade, and lists what
#                   zap may remove.
# WHAT IT CANNOT DO Remove what isn't a file (see the note above zap), follow
#                   the beta channel (stable only), or update itself: each
#                   stable `cr release` writes version and sha256 here from
#                   its release/carriel.rb and pushes them (step m, D88).
# VERSION, SHA256   The stable dmg's, as `cr release` built, notarized and
#                   published it; the same SHA-256 is in stable.json and on
#                   carriel.app/download/. The copy beside Carriel's source
#                   says @VERSION@ and @SHA256@: that one is the template.
# ============================================================
cask "carriel" do
  version "1.0.7"
  sha256 "1e7f63ceb262ff060ade6a5304bd076c1a19fb2dd0d0a24c96f4d32c7139ab66"

  url "https://dl.carriel.dev/pouch/Carriel-#{version}-arm64.dmg"
  name "Carriel"
  desc "Menu bar pouch for API keys, passwords, recovery codes and small files"
  homepage "https://carriel.app/"

  # The manifest Carriel Updater reads. cr release uploads it only after the
  # archives it names, so livecheck never sees a version whose dmg is missing.
  livecheck do
    url "https://dl.carriel.dev/pouch/stable.json"
    strategy :json do |json|
      json["version"]
    end
  end

  # Carriel Updater checks Carriel's signed manifest by itself and swaps the
  # app. Homebrew still upgrades it when the installed app is older
  # than this cask (HOMEBREW_UPGRADE_AUTO_UPDATES_CASKS, the default).
  auto_updates true
  # Apple silicon only, and macOS 26 (Tahoe) or newer: LSMinimumSystemVersion
  # is 26.0 in all three bundles. The bare symbol means "this release or newer".
  depends_on arch: :arm64
  depends_on macos: :tahoe

  app "Carriel.app"

  # quit: the window, then the agent (the login item), both AppKit apps that
  # take the quit Apple Event (⌘Q: the agent locks and clears its copy).
  # Homebrew quits them on upgrade too, and opens them again afterwards.
  # signal: Carriel Updater has no AppKit event loop, so it can't take quit;
  # it runs a few minutes a day at most. Homebrew skips signal on upgrade and
  # reinstall, so an update it is installing is never cut short.
  # No login_item: Carriel's is an SMAppService login item, which System
  # Events' list doesn't hold. macOS keeps listing it in System Settings until
  # a restart (gotcha 9). Settings › About › Remove Carriel… turns it off.
  uninstall quit:   [
              "dev.carriel.app",
              "dev.carriel.app.agent",
            ],
            signal: [["TERM", "dev.carriel.app.updater"]]

  # Out of zap's reach, by design. The pouch's sealed copy on this Mac lives in
  # the agent's sandbox container, ~/Library/Containers/dev.carriel.app.agent:
  # for a pouch that is only on this Mac it is the only copy, and zap can't
  # ask first, so it isn't listed. Nor are its root key in iCloud Keychain,
  # the synced license, this Mac's keys and Secure Enclave keys (Keychain, not
  # files), the pouch in the person's iCloud, or this Mac's seat of a bigger
  # pouch. Remove Carriel… (Settings › About) gives the seat back, asks before
  # it deletes a pouch that is only here, and empties the container; the pouch
  # stays for the person's other Macs. The App Group container holds only the
  # agent's socket and lock; macOS may ask before Homebrew can trash it.
  zap trash: [
    "~/Library/Application Scripts/dev.carriel.app.agent",
    "~/Library/Application Scripts/RD9TC9MV83.dev.carriel.app",
    "~/Library/Application Support/Carriel Updater",
    "~/Library/Application Support/Carriel",
    "~/Library/Caches/Carriel",
    "~/Library/Caches/dev.carriel.app",
    "~/Library/Group Containers/RD9TC9MV83.dev.carriel.app",
    "~/Library/HTTPStorages/dev.carriel.app",
    "~/Library/Logs/Carriel",
    "~/Library/Preferences/dev.carriel.app.plist",
    "~/Library/Saved Application State/dev.carriel.app.savedState",
  ]
end
