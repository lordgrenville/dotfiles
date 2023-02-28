import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Gnome
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.FadeInactive (fadeInactiveLogHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab

import Graphics.X11.ExtraTypes.XF86

{- my config, designed on ubuntu. requirements:
    - xmonad 0.17+ (the one packaged by Debian is lower, so you need to build yourself)
    - xmobar (duh)
    - feh
    - rofi
    - dmenu
    - and scrot, but I think this was already installed
    - xcompmgr (for transparency)
    - xdotool, xclip (for rofimoji)
    - (optional) audacious
-}
main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myBorderWidth        = 0
myFocusedBorderColor = "#ffffff"
myNormalBorderColor  = "#cccccc"
-- fancy spacing - a little bit of space between edges of screen and window, plus windows from each other
myLayoutHook         = avoidStruts $ spacingRaw False (Border 0 10 10 10) True (Border 10 10 10 10) True $ smartBorders (layoutHook gnomeConfig)

-- support xcompmgr events (cool transparency effect for inactive window)
myLogHook            = do
  logHook gnomeConfig
  fadeInactiveLogHook 0.6

myStartupHook        = do
  startupHook gnomeConfig
  spawn "xcompmgr -cfF -t-9 -l-11 -r9 -o.95 -D6 &"
  spawnOnce "feh --no-fehbg --bg-fill '/home/josh/street_computer/Pictures/background pics/bike (2).jpg' '/home/josh/street_computer/Pictures/background pics/best-nature-full-hd-wallpapers31.jpg'"

-- nice xmobar preferences (pp = pretty print) - show me active workspace, don't tell me layout (i don't care)
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- Windows should have *some* title, which should not not exceed a sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 50

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

myConfig = def
    { modMask            = mod4Mask
    , terminal           = "gnome-terminal"
    , layoutHook         = myLayoutHook
    , borderWidth        = myBorderWidth
    , focusedBorderColor = myFocusedBorderColor
    , normalBorderColor  = myNormalBorderColor
    , logHook            = myLogHook
    , startupHook        = myStartupHook
    }
  `additionalKeys`
    [ -- toggle through workspaces in order
      ((mod4Mask, xK_Down),  nextWS)
    , ((mod4Mask, xK_Up),    prevWS)
    -- switch focus between *screens* (by default this is M-w,e,r...)
    , ((mod4Mask, xK_Right), nextScreen)
    , ((mod4Mask, xK_Left),  prevScreen)
    -- alt tab to toggle most recent two windows
    , ((mod4Mask, xK_Tab),     toggleWS)
    , ((mod4Mask, xK_p     ), spawn "dmenu_run")
    -- alt-Space à la macOS Spotlight Cmd-Space
    -- requires rofi + drun (obvs), papirus-icon-theme
    , ((mod1Mask, xK_space     ), spawn "rofi -combi-modi drun -theme solarized -font 'hack 10' -show combi -icon-theme 'Papirus' -show-icons")
    , ((mod1Mask, xK_e     ), spawn "rofi -modi \"emoji:$(which rofimoji) --action copy --clipboarder xclip\" -show emoji")
    -- special audio keys
    ,((0        , xF86XK_AudioMute), spawn "amixer -D pulse sset Master toggle")
    ,((0        , xF86XK_AudioLowerVolume), spawn "amixer -q -D pulse sset Master 5%-")
    ,((0        , xF86XK_AudioRaiseVolume), spawn "amixer -q -D pulse sset Master 5%+")
    -- ,((0        , xF86XK_AudioPlay), spawn "playerctl play-pause")
    -- ,((0        , xF86XK_AudioPrev), spawn "playerctl previous")
    -- ,((0        , xF86XK_AudioNext), spawn "playerctl next")
    -- print screen - xK_Print doesn't work, seems to be a known issue
    --, ((0       , xK_Print), unGrab *> spawn "scrot -s")
    , ((0       , 0xff61), unGrab *> spawn "scrot -s")
    ,((0        , xF86XK_PowerDown), spawn "sudo systemctl suspend")
    ]

