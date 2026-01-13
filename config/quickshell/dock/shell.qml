import Quickshell
import "widgets/dock"
import "widgets/overview"

ShellRoot {
  Dock {}
  Dock {
    name: "power-menu"
    screens: [Quickshell.screens.reduce((acc, screen) => screen.x > acc.x ? screen : acc, { x: -Infinity })]
  }
}