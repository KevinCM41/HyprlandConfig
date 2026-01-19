import Quickshell
import Quickshell.Widgets
import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts

import "root:/utils"
import "root:/components"

Scope {
  property string name: "default"

  Config {
    id: config
    path: Qt.resolvedUrl(`./configs/${name}.json`)
  }

  property list<int> screenIds: Quickshell.screens.map((_, i) => i)
  property list<ShellScreen> screens: Quickshell.screens.filter((_, i) => screenIds.includes(i))

  IpcHandler {
    target: `dock_${name}`
    function expand(monitor: int): void {
      const instance = variants.instances[monitor]
      instance.expand(instance.apps.length / 2)
    }
    function collapse(monitor: int): void {
      const instance = variants.instances[monitor]
      instance.collapse(instance.apps.length / 2)
    }
  }

  Variants {
    id: variants
    model: screens

    PanelWindow {
      id: window
      property var modelData
      screen: modelData

      exclusionMode: ExclusionMode.Ignore 

      function getAnchor(pos) { return Boolean(config.data.position == pos || config.data.margins?.[pos]) }
      anchors {
        left: getAnchor("left")
        right: getAnchor("right")
        top: getAnchor("top")
        bottom: getAnchor("bottom")
      }

      function getMargin(pos) { return config.data.margins?.[pos] || 0 }
      margins {
        left: getMargin("left")
        right: getMargin("right")
        top: getMargin("top")
        bottom: getMargin("bottom")
      }

      property int length: (config.data.iconSize + Appearance.data.spacing.large) * apps.length
      property int breadth: config.data.iconSize * ((config.data.scaleFactor ?? .3) + 1.4) * 1.1 + Appearance.data.spacing.small

      implicitWidth: config.data.orientation == "vertical" ? breadth : length
      implicitHeight: config.data.orientation == "vertical" ? length : breadth
      color: "transparent"

      mask: Region { item: row }

      readonly property var apps: {
        let apps = config.data.items || [];
        if (apps.length == 0) apps = DesktopEntries.applications.values
        else apps = config.data.items.map(name => DesktopEntries.applications.values.find(app => app.name == name))
        return apps.filter(app => app?.name && app?.icon)
      }

      property bool isExpanded: false

      function expand(startIndex) {
        isExpanded = true
        apps.forEach((_, ind) => {
          repeater.itemAt(ind).delay(config.data.iconSize + Appearance.data.spacing.small, startIndex)
        })
      }
      function collapse(startIndex) {
        isExpanded = false
        apps.forEach((_, ind) => {
          repeater.itemAt(ind).delay(0, startIndex)
        })
      }

      Rectangle {
        id: dock
        height: parent.height + 4
        width: parent.width + 4
        anchors.top: config.data.position == "top" ? parent.top : undefined
        anchors.right: config.data.position == "right" ? parent.right : undefined
        anchors.bottom: config.data.position == "bottom" ? parent.bottom : undefined
        anchors.left: config.data.position == "left" ? parent.left : undefined
        color: "transparent"

        // Background with fixed height based on icon size only
        Rectangle {
          id: dockBackground
          width: row.width + Appearance.data.spacing.small * 1
          height: config.data.iconSize + Appearance.data.spacing.small * 1
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.bottom: config.data.position == "bottom" ? parent.bottom : undefined
          anchors.top: config.data.position == "top" ? parent.top : undefined
          anchors.bottomMargin: config.data.position == "bottom" ? 2 : 0
          anchors.topMargin: config.data.position == "top" ? 6 : 0
          
          // Glassmorphism effect
          color: "#1A1A1A"
          radius: config.data.iconSize / 2
          border.width: 1
          border.color: "#33FFFFFF"
          
          gradient: Gradient {
            GradientStop { position: 0.0; color: "#2A2A2A" }
            GradientStop { position: 1.0; color: "#1A1A1A" }
          }

          // Slide animation based on alwaysVisible setting
          opacity: config.data.alwaysVisible ? 1.0 : (window.isExpanded ? 1.0 : 0.0)
          scale: config.data.alwaysVisible ? 1.0 : (window.isExpanded ? 1.0 : 0.8)

          Behavior on opacity {
            NumberAnimation {
              duration: Appearance.data.animation.duration.normal
              easing.type: Easing.OutCubic
            }
          }

          Behavior on scale {
            NumberAnimation {
              duration: Appearance.data.animation.duration.normal
              easing.type: Easing.OutBack
            }
          }
        }

        Grid {
          id: row

          columns: config.data.orientation == "vertical" ? 1 : apps.length
          rows: config.data.orientation == "vertical" ? apps.length : 1

          horizontalItemAlignment: config.data.position == "left" ? Grid.AlignLeft :
                                  config.data.position == "right" ? Grid.AlignRight : Grid.AlignHCenter

          verticalItemAlignment: config.data.position == "top" ? Grid.AlignTop :
                                  config.data.position == "bottom" ? Grid.AlignBottom : Grid.AlignVCenter

          anchors.top: config.data.position == "top" ? parent.top : undefined
          anchors.right: config.data.position == "right" ? parent.right : undefined
          anchors.bottom: config.data.position == "bottom" ? parent.bottom : undefined
          anchors.margins: -2
          anchors.left: config.data.position == "left" ? parent.left : undefined

          anchors.horizontalCenter: config.data.orientation == "horizontal" ? parent.horizontalCenter : undefined
          anchors.verticalCenter: config.data.orientation == "vertical" ? parent.verticalCenter : undefined

          spacing: 0

          property int current: -1

          Repeater {
            id: repeater
            model: apps

            DockItem {}
          }
        }
      }
    }
  }
}