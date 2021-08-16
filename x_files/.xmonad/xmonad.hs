import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.CycleWS
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Config.Desktop
import XMonad.Wallpaper
import System.IO

main = do
    xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

    setRandomWallpaper ["$HOME/Pictures/desktop pics"]
-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Main configuration, override the defaults to your liking.
myConfig = def { terminal = "/usr/bin/urxvt"
               ,layoutHook = noBorders Full
               , modMask = mod4Mask
               }
                               `additionalKeys`
                [
                -- ((mod4Mask , xK_Tab), nextMatch Backward (return True))
                -- toggle through workspaces in order
                  ((mod4Mask,               xK_Down),  nextWS)
                , ((mod4Mask,               xK_Up),    prevWS)
                -- switch focus between *screens*
                -- (by default this is M-w,e,r...)
                , ((mod4Mask,               xK_Right), nextScreen)
                , ((mod4Mask,               xK_Left),  prevScreen)
                -- alt tab to toggle most recent two windows
                , ((mod4Mask,               xK_Tab),     toggleWS)
                -- , ((mod4Mask, xK_Tab), cycleRecentWS [xK_Alt_L] xK_Tab xK_grave)
                , ((mod4Mask,               xK_p     ), spawn "dmenu_run")
                -- alt-Space à la macOS Spotlight Cmd-Space
                , ((mod1Mask,               xK_space     ), spawn "rofi -combi-modi window,drun,ssh -theme solarized -font 'hack 10' -show combi -icon-theme 'Papirus' -show-icons")
                ]
