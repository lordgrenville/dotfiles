import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.FadeInactive (fadeInactiveLogHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.SpawnOnce

import Graphics.X11.ExtraTypes.XF86

main = do
  xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

myModMask            = mod4Mask
myLayoutHook         = avoidStruts $ spacingRaw False (Border 0 10 10 10) True (Border 10 10 10 10) True $ smartBorders (layoutHook gnomeConfig)
myBorderWidth        = 0
myFocusedBorderColor = "#ffffff"
myNormalBorderColor  = "#cccccc"
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- support xcompmgr events
myLogHook            = do
  logHook gnomeConfig
  fadeInactiveLogHook 0.6

myStartupHook        = do
  startupHook gnomeConfig
  setWMName "LG3D"
  spawn "xcompmgr -cfF -t-9 -l-11 -r9 -o.95 -D6 &"
  spawnOnce "feh --no-fehbg --bg-fill '/home/josh/street_computer/Pictures/background pics/bike (2).jpg' '/home/josh/street_computer/Pictures/background pics/best-nature-full-hd-wallpapers31.jpg'"
-- Command to launch the bar.
myBar = "xmobar"
myPP = xmobarPP

myKeys = [
                -- toggle through workspaces in order
                  ((mod4Mask, xK_Down),  nextWS)
                , ((mod4Mask, xK_Up),    prevWS)
                -- switch focus between *screens*
                -- (by default this is M-w,e,r...)
                , ((mod4Mask, xK_Right), nextScreen)
                , ((mod4Mask, xK_Left),  prevScreen)
                -- alt tab to toggle most recent two windows
                , ((mod4Mask, xK_Tab),     toggleWS)
                , ((mod4Mask, xK_p     ), spawn "dmenu_run")
                -- alt-Space à la macOS Spotlight Cmd-Space
                -- requires rofi + drun (obvs), papirus-icon-theme
                , ((mod1Mask, xK_space     ), spawn "rofi -combi-modi drun -theme solarized -font 'hack 10' -show combi -icon-theme 'Papirus' -show-icons")
                -- special audio keys
                ,((0        , xK_F1), spawn "amixer -D pulse sset Master toggle")
                ,((0        , xK_F2), spawn "amixer -q -D pulse sset Master 1%-")
                ,((0        , xK_F3), spawn "amixer -q -D pulse sset Master 1%+")
                -- ,((0        , xF86XK_AudioPlay), spawn "playerctl play-pause")
                -- ,((0        , xF86XK_AudioPrev), spawn "playerctl previous")
                -- ,((0        , xF86XK_AudioNext), spawn "playerctl next")
                ,((0        , xF86XK_PowerDown), spawn "sudo systemctl suspend")
                -- alternatively with keysyms
                -- ,((0        , 0x1008FF11), spawn "amixer -q sset Master 1%-")
                ]

myConfig = def { modMask = myModMask
          , layoutHook         = myLayoutHook
          , borderWidth        = myBorderWidth
          , focusedBorderColor = myFocusedBorderColor
          , normalBorderColor  = myNormalBorderColor
          , logHook            = myLogHook
          , startupHook        = myStartupHook
          } `additionalKeys` myKeys
