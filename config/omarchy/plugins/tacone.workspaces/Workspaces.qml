import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  // Show every workspace that currently exists (including 11, aaa, 12-20...),
  // labeled with its configured name (kanji) rather than its numeric id.
  function workspaceIds() {
    var ids = []
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      if (values[i].id < 0) continue // skip special workspaces (scratchpads etc.)
      ids.push(values[i].id)
    }

    ids.sort(function(left, right) {
      if (typeof left === "number" && typeof right === "number") return left - right
      if (typeof left === "number") return -1
      if (typeof right === "number") return 1
      return String(left).localeCompare(String(right))
    })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceIds().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property var modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        activeColor: Color.accent
        text: workspace !== null ? workspace.name : String(modelData)
        active: focused
        dimmed: !occupied && !focused
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : -1
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }

        // Instant dimming: override the base WidgetButton's 140ms opacity
        // animation so empty workspaces dim immediately instead of fading.
        Behavior on opacity {
          enabled: false
        }
      }
    }
  }
}
