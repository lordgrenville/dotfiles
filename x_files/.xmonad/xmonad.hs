-- default desktop configuration for Fedora

-- import System.Posix.Env (getEnv)
-- import Data.Maybe (maybe)

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
-- import XMonad.Config.Desktop
-- import XMonad.Config.Gnome
-- import XMonad.Config.Kde
-- import XMonad.Config.Xfce

main = xmonad =<< statusBar myBar myPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP, configure it as you like. It determines what is being written to the bar.
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "<" ">" }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

-- Main configuration, override the defaults to your liking.
myConfig = def { terminal = "/usr/bin/gnome-terminal"
               , modMask = mod4Mask
               , layoutHook=avoidStruts $ layoutHook def
               , manageHook=manageHook def <+> manageDocks}

-- main = do
--     xmproc <- spawnPipe "xmobar"
--     xmonad $ defaultConfig
--        { terminal = "/usr/bin/gnome-terminal"
--         , modMask = mod4Mask
--         , layoutHook=avoidStruts $ layoutHook def
--         , manageHook=manageHook def <+> manageDocks
--        }
