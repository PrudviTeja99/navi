# Maintainer: Your Name <your email>
pkgname=navi
pkgver=1.0.3
pkgrel=1
pkgdesc="Interactive TUI wrapper for Pacman, Paru, and Flatpak"
arch=('any')
url="https://github.com/PrudviTeja99/navi"
license=('MIT')
depends=('fzf' 'pacman' 'bash')
optdepends=('paru: for AUR support'
            'flatpak: for Flatpak support'
            'systemd: for sleep inhibition during updates')
source=('navi'
        'navi-colors.sh'
        'navi-ensure-source-installed.sh'
        'navi-fetch-packages.sh'
        'navi-cleanup.sh'
        'LICENSE')
sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

package() {
  # Install main script
  install -Dm755 "$srcdir/navi" "$pkgdir/usr/bin/navi"
  
  # Install helper scripts
  install -dm755 "$pkgdir/usr/share/navi"
  install -m755 "$srcdir/navi-colors.sh" "$pkgdir/usr/share/navi/navi-colors.sh"
  install -m755 "$srcdir/navi-ensure-source-installed.sh" "$pkgdir/usr/share/navi/navi-ensure-source-installed.sh"
  install -m755 "$srcdir/navi-fetch-packages.sh" "$pkgdir/usr/share/navi/navi-fetch-packages.sh"
  install -m755 "$srcdir/navi-cleanup.sh" "$pkgdir/usr/share/navi/navi-cleanup.sh"
  
  # Install license
  install -Dm644 "$srcdir/LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
