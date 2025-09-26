# Navi – Interactive Package Manager for Arch/CachyOS

**Navi** is a lightweight, interactive TUI wrapper for Pacman, Paru (AUR), and Flatpak.  
It combines fuzzy search, clean menus, and automatic sleep inhibition during updates into a single tool.  

Think of it as **Omarchy-like**, but for Arch/CachyOS with extra polish. 🚀

---

## ✨ Features

- 🔍 **Fuzzy search** for finding and installing packages (with `fzf`)
- 📦 Works with **Pacman (official repos)**, **Paru (AUR)**, and **Flatpak**
- 📖 **Live descriptions** of packages in preview window
- 💤 **Prevents sleep/idle** during system updates (via `systemd-inhibit`)
- 🔑 **Single sudo prompt** at startup (no repeated passwords)
- ✅ Flexible confirmation modes:
  - Interactive (default)
  - Always Yes (`-y`)
  - Always No (`-n`)
- 🧭 **CamelCase menus** (Install, Remove, Update) for clarity
- 🖥️ Optional **non-interactive mode** (CLI arguments like `navi install pacman`)

---

## 📦 Installation

Clone the repository:

    git clone https://github.com/PrudviTeja99/navi.git

    cd navi

Make it executable:

    chmod +x navi

Optionally install system-wide:

    sudo mv navi /usr/local/bin/

Now you can run it anywhere using:

    navi

## 🛠 Dependencies

Ensure the following are installed:

    fzf (fuzzy finder)

    pacman (comes with Arch/CachyOS)

    paru (AUR helper)

    flatpak (optional, for Flatpak updates)

Install dependencies:

    sudo pacman -S fzf paru

(Flatpak is optional, install with sudo pacman -S flatpak)
## 🚀 Usage
Interactive Mode

Just run navi and use fuzzy menus:

    navi

You’ll see:

Select Action:
    Install
    Remove
    Update

Direct CLI Mode

You can skip menus by passing action and source:

#### Install packages from pacman
    navi install pacman

#### Remove packages from paru
    navi remove paru

#### Update everything (pacman, paru, flatpak) with auto-confirm
    navi update -y

Confirmation Modes

Default: asks before every install/remove/update

Always yes:

    navi install pacman -y

Always no:

    navi remove paru -n

## 📸 Screenshots

    (Pending...)

## 🔒 Security Notes

    Navi requests sudo once at the start, then keeps it alive in the background.

    Updates run under systemd-inhibit to prevent system from sleeping.

## 📄 License

MIT License – feel free to modify and share.
## 🤝 Contributing

Pull requests are welcome! For major changes, open an issue first to discuss.
## ⭐ Acknowledgements

    Inspired by [Omarchy Linux package UI]

    Built with Arch users in mind

    Thanks to the creators of fzf, paru, and pacman