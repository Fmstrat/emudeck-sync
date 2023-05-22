# EmuDeck Sync
An automatic save-game synchronization service for Steam Deck and EmuDeck that will also sync with your PC.

## How does it work?
EmuDeck Sync uses [rclone](https://rclone.org/) under the hood to synchronize game saves on the Steam Deck. When EmuDeck starts an emulator/game, it runs a script on your Steam Deck. EmuDeck Sync adds a command to display a window in Game Mode which synchronizes saves before a game starts, and after it finishes, even if exiting with the Steam Button/Menu.

**Unlike EmuDeck Cloud Backup, EmuDeck Sync runs before and after games, to make sure resources aren't being used every 15 minutes in the background.**

## Supported cloud providers
EmuDeck Sync is being configured to support all major [providers](https://rclone.org/#providers) supported by `rclone`. Today, we have tested and support:
- Nextcloud
- Dropbox
- Google Drive

## Supported EmuDeck game systems
EmuDeck Sync is being configured to support all gaming systems. Today we have tested and support:
- Yuzu