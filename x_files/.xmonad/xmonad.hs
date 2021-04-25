import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.GroupNavigation
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

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
               , modMask = mod4Mask
               }
                               `additionalKeys`
                -- alt tab to switch windows
                [ ((mod1Mask , xK_Tab), nextMatch Backward (return True)) ]
