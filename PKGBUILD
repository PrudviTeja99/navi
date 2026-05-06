# Maintainer: Prudvi Teja <https://github.com/PrudviTeja99>
pkgname=navi-git
_pkgname=navi
pkgver=r91.db858b9
pkgrel=1
pkgdesc="Interactive TUI wrapper for Pacman, Paru, and Flatpak"
arch=('any')
url="https://github.com/PrudviTeja99/navi"
license=('MIT')
depends=('fzf' 'pacman' 'bash')
optdepends=('paru: for AUR support'
            'flatpak: for Flatpak support'
            'systemd: for sleep inhibition during updates')
provides=("$_pkgname")
conflicts=("$_pkgname")
source=("git+$url.git")
sha256sums=('SKIP')

pkgver() {
  cd "$_pkgname"
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
  cd "$_pkgname"
  
  # Install main script
  install -Dm755 navi "$pkgdir/usr/bin/navi"
  
  # Install helper scripts
  install -dm755 "$pkgdir/usr/share/navi"
  install -m755 navi-colors.sh "$pkgdir/usr/share/navi/navi-colors.sh"
  install -m755 navi-ensure-source-installed.sh "$pkgdir/usr/share/navi/navi-ensure-source-installed.sh"
  install -m755 navi-fetch-packages.sh "$pkgdir/usr/share/navi/navi-fetch-packages.sh"
  install -m755 navi-cleanup.sh "$pkgdir/usr/share/navi/navi-cleanup.sh"
  
  # Install license
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
