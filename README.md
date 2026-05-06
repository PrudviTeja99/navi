# 🧭 Navi – Interactive Package Manager for Arch/CachyOS

**Navi** is a lightweight, interactive **TUI wrapper** for **Pacman**, **Paru (AUR)**, and **Flatpak**.  
It simplifies installing, removing, and updating packages from all major sources with a single interface — complete with fuzzy search, package previews, and automatic sleep prevention during updates.

Think of it as **Omarchy-like**, but for **Arch/CachyOS**, with extra polish. 🚀

---

## ✨ Features

- 🔍 **Fuzzy Search** — Quickly find packages using [`fzf`](https://github.com/junegunn/fzf)  
- 📦 **Unified Interface** — Manage packages from:
  - **Pacman** (official repositories)
  - **Paru** (AUR)
  - **Flatpak**
- 🖥️ **Interactive TUI Menus** — Clean layout with `fzf`-powered selection
- 📖 **Live Package Descriptions** in the preview window
- 💤 **Prevents Sleep/Idle** during updates (`systemd-inhibit`)
- 🔑 **Single sudo prompt** — Requests once, keeps alive for session
- ✅ **Confirmation Modes**
  - Default (interactive)
  - Always Yes (`-y`)
  - Always No (`-n`)
- 💻 **Command Line Mode** — Run actions directly without menus
- 🧰 **Automatic Dependency Installation** — Ensures `paru` and `flatpak` are installed if missing

---

## 📦 Installation

### The "Arch Way" (Recommended)
Since Navi is designed for Arch-based systems, the best way to install it is using the provided `PKGBUILD`. This allows your system to manage it like a native package.

```bash
git clone https://github.com/PrudviTeja99/navi.git
cd navi
makepkg -si
```

### Manual Installation
You can also use the provided installation script:

```bash
chmod +x install.sh
sudo ./install.sh
```

---

## 🧹 Uninstall

### If installed via PKGBUILD:
```bash
sudo pacman -Rs navi-git
```

### If installed via script:
```bash
chmod +x uninstall.sh
sudo ./uninstall.sh
```

---

Navi requires the following packages:

| Dependency | Purpose                        | Required    |
| ---------- | ------------------------------ | ----------- |
| `fzf`      | Fuzzy finder used for menus    | ✅ Yes       |
| `pacman`   | Default system package manager | ✅ Yes       |
| `paru`     | AUR package helper             | ⚙️ Optional |
| `flatpak`  | For Flatpak packages           | ⚙️ Optional |


Install essentials:

```
sudo pacman -S fzf
```

(Optional):
```
sudo pacman -S paru flatpak
```


## 🚀 Usage
Interactive Mode

Run:
```
navi
```

You’ll see a main menu:

```
Select Action:
    Install
    Remove
    System Update
```
Choose an action, then select the package source (Pacman, Paru, or Flatpak) if applicable.



## ⚙️ Command Line Mode (Non-interactive)

You can skip menus and directly perform actions.

🔹 Install
Install packages using:
```
navi install <source>
```
Examples:
```
navi install pacman
navi install paru
navi install flatpak
```

🔹 Remove
Remove packages:
```
navi remove <source>
```
Example:
```
navi remove paru
```

🔹 Update
Update all packages (from Pacman, Paru, and Flatpak):
```
navi update
```
Note: The update action does not accept a source argument — it automatically updates all available sources.

🔹 Confirmation Flags
| Flag | Description                         |
| ---- | ----------------------------------- |
| `-y` | Always confirm “Yes” to all prompts |
| `-n` | Always answer “No” (skip)           |

Examples:
```
navi update -y
navi install pacman -n
```


## 🔒 Security Notes

* Requests sudo once and maintains it using a background keep-alive.
* Uses systemd-inhibit to prevent system sleep during package updates, installs and removals.

## 🧩 Related Scripts

* navi-colors.sh – Provides color-coded logging functions.
* navi-ensure-source-installed – Ensures paru and flatpak are installed automatically if missing.

## 📸 Screenshots

    (Pending...)


## 📄 License

MIT License – feel free to modify and share.


## 🤝 Contributing

* Pull requests are welcome!
* For major feature proposals, please open an issue first to discuss design or behavior.


## ⭐ Acknowledgements

* Inspired by Omarchy Linux package UI
* Thanks to the creators of fzf, paru, flatpak, and pacman
* Built with ❤️ for Arch/CachyOS users