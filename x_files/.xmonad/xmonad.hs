import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.CycleWS
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

-- use names instead of keysyms for audio keys. on Arch you first need to cabal install --lib X11
import Graphics.X11.ExtraTypes.XF86

main = do
    xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Main configuration, override the defaults to your liking.
myConfig = def { terminal = "/usr/bin/urxvt"
               , startupHook = spawn "feh --no-fehbg --bg-fill '/josh/Pictures/hill.webp' '/josh/Pictures/trees.jpg'"
               , layoutHook = noBorders Full
               , modMask = mod4Mask
               }
                               `additionalKeys`
                [
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
                ,((0        , xF86XK_AudioLowerVolume), spawn "amixer -q sset Master 1%-")
                ,((0        , xF86XK_AudioRaiseVolume), spawn "amixer -q sset Master 1%+")
                ,((0        , xF86XK_AudioMute), spawn "amixer set Master toggle")
                ,((0        , xF86XK_AudioPlay), spawn "playerctl play-pause")
                ,((0        , xF86XK_AudioPrev), spawn "playerctl previous")
                ,((0        , xF86XK_AudioNext), spawn "playerctl next")
                -- alternatively with keysyms
                -- ,((0        , 0x1008FF11), spawn "amixer -q sset Master 1%-")
                -- ,((0        , 0x1008FF12), spawn "amixer set Master toggle")
                -- ,((0        , 0x1008FF13), spawn "amixer -q sset Master 1%+")
                -- ,((0        , 0x1008FF14), spawn "playerctl play-pause")
                -- ,((0        , 0x1008FF16), spawn "playerctl previous")
                -- ,((0        , 0x1008FF17), spawn "playerctl next")
                ]
