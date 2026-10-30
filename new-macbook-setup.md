# New MacBook Setup (Nix + nix-darwin)

Host: `mimer` · User: `lehoff` · Config: `git@github.com:lehoff/nix-darwin-config.git`
Backup drive: `/Volumes/U/macbook-backup/lehoff` · Backup tooling: `~/backup-macbook` (also copied to the drive)

---

## Part 1: On the old Mac

- [ ] Mount the drive `/Volumes/U`.
- [ ] Run a final backup (`.ssh` and `.gnupg` are now in `backup-list.txt`):

  ```bash
  cd ~/backup-macbook && ./backup.sh backup-list.txt
  ```

- [ ] Check the log ends with `0 warning(s)/error(s)`.
- [ ] Check what the list does **not** cover: `~/Documents`, `~/Desktop`, `~/Library/Application Support` (except MailMate and logseq), `~/.docker`, `~/cert`, cloud credential dirs. Copy anything you need by hand.
- [ ] Optional: push repos under `~/git` that have a remote. The backup already copies `.git`, so this is only a second copy.
- [ ] Push `~/nix-darwin-config` (`git status` should be clean, `git push`). This one is required, since the new Mac clones it.
- [ ] Sync Anki to AnkiWeb, and let Dropbox and Google Drive finish syncing.
- [ ] Find your license keys or emails for licensed apps (AlDente, BetterDisplay, BetterTouchTool, Fork, Nimble Commander, Raycast, etc.).
- [ ] Note your Mac App Store apps: Amphetamine, Pages, Keynote, Numbers, Slack, Bear, Toggl.
- [ ] Keep the old Mac usable for about a week after the switch. Do not sign out of apps yet.

---

## Part 2: On the new Mac

### 1. Basics

- [ ] Create the user `lehoff` (the name is hardcoded in `darwin.nix` and `home.nix`).
- [ ] Set the hostname to `mimer`:

  ```bash
  sudo scutil --set HostName mimer
  sudo scutil --set LocalHostName mimer
  sudo scutil --set ComputerName mimer
  ```

- [ ] Sign in to the **App Store** (needed for the `masApps` entries).
- [ ] Install the Xcode command line tools:

  ```bash
  xcode-select --install
  ```

### 2. Install Nix

- [ ] Install Nix (Lix, per your README) with the same installer you used before.
- [ ] Open a **new** terminal and check `nix --version`.

### 3. Get the backup tooling and your keys

- [ ] Mount the drive `/Volumes/U`.
- [ ] Copy the backup tooling from the drive:

  ```bash
  rsync -av /Volumes/U/macbook-backup/lehoff/backup-macbook ~/
  ```

- [ ] Restore SSH and GPG keys first (the Nix repo needs the SSH key to clone):

  ```bash
  printf '.ssh\n.gnupg\n' > /tmp/keys-list.txt
  ~/backup-macbook/restore.sh /tmp/keys-list.txt
  chmod 700 ~/.ssh ~/.gnupg
  chmod 600 ~/.ssh/id_*
  ```

- [ ] Test GitHub access: `ssh -T git@github.com`

### 4. Clone the Nix config

```bash
git clone git@github.com:lehoff/nix-darwin-config.git ~/nix-darwin-config
```

- [ ] Cloned.

### 5. First switch (bootstraps nix-darwin)

```bash
cd ~/nix-darwin-config
sudo nix --extra-experimental-features "nix-command flakes" \
  run nix-darwin/nix-darwin-26.05#darwin-rebuild -- \
  switch --flake .#mimer --impure
```

- [ ] If it complains about existing files (`/etc/zshrc`, `/etc/nix/nix.conf`, ...), rename them and re-run:

  ```bash
  sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
  ```

- [ ] If cask installs fail with `undefined method 'first' for nil`, the pinned Homebrew taps are stale. Run `./rebuild`, which refreshes them.
- [ ] From now on, use `./rebuild` instead of calling `darwin-rebuild` directly.
- [ ] Open a new terminal after the switch.

### 6. Restore the rest of your files

```bash
~/backup-macbook/restore.sh backup-list.txt
```

- [ ] Check the log ends with `0 warning(s)/error(s)`.
- [ ] Re-run `./rebuild` if restored config changed anything Nix manages.

### 7. Manual steps

- [ ] **Zed:** run `cli: install binary` inside Zed.
- [ ] **Logins:** `gh auth login`, `claude`, other CLI tools.
- [ ] **macOS permissions** (System Settings > Privacy & Security): Accessibility for Aerospace, Rectangle, Raycast, BetterTouchTool; Full Disk Access where needed.
- [ ] **Accounts:** Dropbox, Google Drive, Bitwarden, Signal, Slack, Bear.
- [ ] **Karabiner:** profiles come back with the restore; check they load.
- [ ] **Toolchains:**

  ```bash
  mise install
  asdf install
  mix local.hex
  ```

  Rebuild Erlang with kerl if needed.
- [ ] **Elixir projects:** run `mix deps.get` (the backup excludes `deps/` and `_build/`).

### 8. Verify

- [ ] `darwin-rebuild --version` works.
- [ ] Shell, aliases and prompt look right.
- [ ] Spot-check `~/git`, `~/notes`, `~/.claude`.
- [ ] Open the apps you use daily.

---

---

## Part 3: Retiring the old Mac (after about a week)

Wiping the Mac clears local app data, but not what services keep on their side (device lists, linked devices, license activations). Clean those up as follows.

- [ ] Run one last backup and confirm the new Mac has everything.
- [ ] Phone: Signal and WhatsApp > Settings > Linked devices > remove the old Mac.
- [ ] Deactivate licensed apps that offer it (Settings > License).
- [ ] Erase the Mac: System Settings > General > Transfer or Reset > Erase All Content and Settings. This signs out of Apple ID and turns off Find My and Activation Lock.
- [ ] From the web, remove the old Mac from device lists:
  - Dropbox: dropbox.com > avatar > Settings > Security > Devices
  - Bitwarden: web vault > Account settings > Security > Devices (hygiene only, no install limit)
  - Google: myaccount.google.com > Security > Your devices

---

## Known gotchas

- `flake.lock` pins the Homebrew tap inputs. Old pins break cask installs, so `./rebuild` refreshes them before each switch.
- `darwin.nix` has a TODO about the `asdf-vm` pin (see the README).
- Migration Assistant is not needed. Your setup is declarative and Migration Assistant would only drag along cruft.
