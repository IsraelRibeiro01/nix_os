from libqtile import bar, layout, widget, hook
from libqtile.config import Group, Key, Screen
from libqtile.command import lazy
mod = "mod4"
keys = []
groups = [Group(i) for i in "12345"]
layouts = [layout.Max()]
screens = [Screen(top=bar.Bar([widget.GroupBox(), widget.WindowName()], 24))]

