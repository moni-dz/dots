{-# LANGUAGE FlexibleContexts #-}

-- fortuneteller2k's XMonad config
-- This file is managed by NixOS, don't edit it directly!

import Data.Char
import Data.Monoid
import Data.Tree

import System.IO
import System.Exit

import XMonad

import XMonad.Actions.CycleWS
import XMonad.Actions.Sift
import XMonad.Actions.SpawnOn
import XMonad.Actions.TiledWindowDragging
import XMonad.Actions.TreeSelect
import XMonad.Actions.WithAll

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.BoringWindows
import XMonad.Layout.Decoration
import XMonad.Layout.DraggingVisualizer
import XMonad.Layout.Grid
import XMonad.Layout.LayoutHints
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Maximize
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation

import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Shell

import XMonad.Util.EZConfig
import XMonad.Util.Hacks
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import qualified Codec.Binary.UTF8.String as UTF8
import qualified Data.Map                 as M
import qualified DBus                     as D
import qualified DBus.Client              as D
import qualified XMonad.Actions.Sift      as W
import qualified XMonad.StackSet          as W

modkey = mod1Mask
term = "/nix/store/ifip8n572lj5p5b471gvgrwryga2zvr3-alacritty-0.7.2/bin/alacritty"
fontNameGTK = "Iosevka FT"
fontFamily = "xft:" ++ fontNameGTK ++ ":size=9.7:antialias=true:hinting=true"
sansFontFamily = "xft:Sarasa Gothic J:size=10:antialias=true:hinting=true"
ws = [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "J" ]

actions = [ Node (TSNode "Session" "session management" (return ()))
                 [ Node (TSNode "Logout" "exit current XMonad session" (io (exitWith ExitSuccess))) []
                 , Node (TSNode "Lock" "lock session" (safeSpawnProg "slock")) []
                 , Node (TSNode "Reboot" "reboot this machine" (safeSpawn "/nix/store/fdbsckqrhfmwy73mck958pcw5z51wa3b-systemd-247.2/bin/systemctl" ["reboot"])) []
                 , Node (TSNode "Power Off" "power off this machine" (safeSpawn "/nix/store/fdbsckqrhfmwy73mck958pcw5z51wa3b-systemd-247.2/bin/systemctl" ["poweroff"])) []
                 ]
          , Node (TSNode "Media" "media controls" (return ()))
                 [ Node (TSNode "MPD" "control the music player daemon" (return ()))
                        [ Node (TSNode "Play" "play current song" (safeSpawn "/nix/store/6fjax8bsxii5brb90rqryk3bndccdp5j-mpc-0.33/bin/mpc" ["play"])) []
                        , Node (TSNode "Pause" "pause current song" (safeSpawn "/nix/store/6fjax8bsxii5brb90rqryk3bndccdp5j-mpc-0.33/bin/mpc" ["pause"])) []
                        , Node (TSNode "Previous" "play previous song in playlist" (safeSpawn "/nix/store/6fjax8bsxii5brb90rqryk3bndccdp5j-mpc-0.33/bin/mpc" ["prev"])) []
                        , Node (TSNode "Next" "play next song in playlist" (safeSpawn "/nix/store/6fjax8bsxii5brb90rqryk3bndccdp5j-mpc-0.33/bin/mpc" ["next"])) []
                        , Node (TSNode "Repeat" "toggle repeat" (safeSpawn "/nix/store/6fjax8bsxii5brb90rqryk3bndccdp5j-mpc-0.33/bin/mpc" ["repeat"])) []
                        , Node (TSNode "Single" "toggle single song mode" (safeSpawn "/nix/store/6fjax8bsxii5brb90rqryk3bndccdp5j-mpc-0.33/bin/mpc" ["single"])) []
                        ]
                 , Node (TSNode "MPRIS" "control general media" (return ()))
                        [ Node (TSNode "Play" "play media" (safeSpawn "/nix/store/7ny7cgfkiz6v10w7nsm6mgijxwdw5gmw-playerctl-2.3.1/bin/playerctl" ["play"])) []
                        , Node (TSNode "Pause" "pause media" (safeSpawn "/nix/store/7ny7cgfkiz6v10w7nsm6mgijxwdw5gmw-playerctl-2.3.1/bin/playerctl" ["pause"])) []
                        , Node (TSNode "Previous" "go to previous" (safeSpawn "/nix/store/7ny7cgfkiz6v10w7nsm6mgijxwdw5gmw-playerctl-2.3.1/bin/playerctl" ["previous"])) []
                        , Node (TSNode "Next" "go to next" (safeSpawn "/nix/store/7ny7cgfkiz6v10w7nsm6mgijxwdw5gmw-playerctl-2.3.1/bin/playerctl" ["next"])) []
                        ]
                 ]
          ]

tsConfig = TSConfig
           { ts_hidechildren = True
           , ts_background   = 0xe016161c
           , ts_font         = sansFontFamily
           , ts_node         = (0xff16161c, 0xffe95678)
           , ts_nodealt      = (0xff16161c, 0xffec6a88)
           , ts_highlight    = (0xff16161c, 0xfffab795)
           , ts_extra        = 0xfffdf0ed
           , ts_node_width   = 200
           , ts_node_height  = 30
           , ts_originX      = 0
           , ts_originY      = 0
           , ts_indent       = 80
           , ts_navigate     = defaultNavigation
           }

keybindings =
  [ ("M-<Return>",                 spawnHere term)
  , ("M-b",                        namedScratchpadAction scratchpads "terminal")
  , ("M-`",                        distractionLess)
  , ("M-d",                        shellPromptHere promptConfig)
  , ("M-q",                        kill)
  , ("M-w",                        treeselectAction tsConfig actions)
  , ("M-<F2>",                     spawnHere browser)
  , ("M-e",                        withFocused (sendMessage . maximizeRestore))
  , ("M-<Tab>",                    sendMessage NextLayout)
  , ("M-s",                        windows W.swapMaster)
  , ("M--",                        sendMessage Shrink)
  , ("M-=",                        sendMessage Expand)
  , ("M-[",                        sendMessage MirrorShrink)
  , ("M-]",                        sendMessage MirrorExpand)
  , ("M-t",                        withFocused toggleFloat)
  , ("M-,",                        sendMessage (IncMasterN 1))
  , ("M-.",                        sendMessage (IncMasterN (-1)))
  , ("C-<Left>",                   prevWS)
  , ("C-<Right>",                  nextWS)
  , ("<Print>",                    safeSpawn "/etc/nixos/scripts/screenshot" ["wind"])
  , ("M-<Print>",                  safeSpawn "/etc/nixos/scripts/screenshot" ["area"])
  , ("M-S-s",                      safeSpawn "/etc/nixos/scripts/screenshot" ["full"])
  , ("M-S-q",                      io (exitWith ExitSuccess))
  , ("M-S-h",                      safeSpawn "/nix/store/rp6ilhn28yjf2whalgzb7biwr99rr3yz-gxmessage-3.4.3/bin/gxmessage" ["-fn", fontNameGTK, help])
  , ("M-S-<Delete>",               safeSpawnProg "slock")
  , ("M-S-c",                      withFocused $ \w -> safeSpawn "/nix/store/mz9vhsvf0f5giqkkrmrhybr9f2wp3gda-xkill-1.0.5/bin/xkill" ["-id", show w])
  , ("M-C-<Left>",                 sendMessage $ pullGroup L)
  , ("M-C-<Right>",                sendMessage $ pullGroup R)
  , ("M-C-<Up>",                   sendMessage $ pullGroup U)
  , ("M-C-<Down>",                 sendMessage $ pullGroup D)
  , ("M-C-m",                      withFocused (sendMessage . MergeAll))
  , ("M-C-u",                      withFocused (sendMessage . UnMerge))
  , ("M-C-,",                      onGroup W.focusUp')
  , ("M-C-.",                      onGroup W.focusDown')
  , ("M-S-r",                      unsafeSpawn (restartcmd ++ "&& sleep 2 &&" ++ restackcmd))
  , ("M-S-<Left>",                 shiftToPrev >> prevWS)
  , ("M-S-<Right>",                shiftToNext >> nextWS)
  , ("M-<Left>",                   focusUp)
  , ("M-<Right>",                  focusDown)
  , ("M-S-<Tab>",                  sendMessage FirstLayout)
  , ("M-C-c",                      killAll)
  , ("<XF86AudioMute>",            safeSpawn "/etc/nixos/scripts/volume" ["toggle"])
  , ("<XF86AudioRaiseVolume>",     safeSpawn "/etc/nixos/scripts/volume" ["up"])
  , ("<XF86AudioLowerVolume>",     safeSpawn "/etc/nixos/scripts/volume" ["down"])
  , ("<XF86AudioPlay>",            safeSpawn "/nix/store/7ny7cgfkiz6v10w7nsm6mgijxwdw5gmw-playerctl-2.3.1/bin/playerctl" ["play-pause"])
  , ("<XF86AudioPrev>",            safeSpawn "/nix/store/7ny7cgfkiz6v10w7nsm6mgijxwdw5gmw-playerctl-2.3.1/bin/playerctl" ["previous"])
  , ("<XF86AudioNext>",            safeSpawn "/nix/store/7ny7cgfkiz6v10w7nsm6mgijxwdw5gmw-playerctl-2.3.1/bin/playerctl" ["next"])
  , ("<XF86MonBrightnessUp>",      safeSpawn "/nix/store/492kia7xhn4p9sv1ciyvknjmb7hl7gaz-brightnessctl-0.5.1/bin/brightnessctl" ["s", "+10%"])
  , ("<XF86MonBrightnessDown>",    safeSpawn "/nix/store/492kia7xhn4p9sv1ciyvknjmb7hl7gaz-brightnessctl-0.5.1/bin/brightnessctl" ["s", "10%-"])
  ]
  ++
  [ (otherModMasks ++ "M-" ++ key, action tag)
      | (tag, key) <- zip ws (map show ([1..9] ++ [0]))
      , (otherModMasks, action) <- [ ("", windows . W.greedyView)
                                   , ("S-", windows . W.shift) ] ]
  where
    distractionLess = sequence_ [unsafeSpawn restackcmd, sendMessage ToggleStruts, toggleScreenSpacingEnabled, toggleWindowSpacingEnabled]
    restartcmd = "/nix/store/3y286fzl2h4y9b6vn772075apvw7l7sr-xmonad-with-packages-8.10.4/bin/xmonad --restart && /nix/store/q09wcs6zygjrbh48wxp952h5gnsbzavi-polybar-3.5.2/bin/polybar-msg cmd restart"
    restackcmd = "/nix/store/qnax36vva8f36n4l4jhqcv60mg4675yi-xdo-0.5.7/bin/xdo lower $(/nix/store/nd8rb3izr8207yzwld329v1a78pzh6jx-xwininfo-1.1.4/bin/xwininfo -name polybar-xmonad | /nix/store/j299i91khakyv8a2gv37xz37083lasm6-ripgrep-12.1.1/bin/rg 'Window id' | /nix/store/ypsd29c5hgj1x7xz5ddffanxw5d8fh7b-coreutils-8.32/bin/cut -d ' ' -f4)"
    browser = concat
      [ "/nix/store/al47an6f1liik98c9day7ixp7vhd4wkn-qutebrowser-2.0.2/bin/qutebrowser"
      , " --qt-flag ignore-gpu-blacklist"
      , " --qt-flag enable-gpu-rasterization"
      , " --qt-flag enable-native-gpu-memory-buffers"
      , " --qt-flag num-raster-threads=4"
      , " --qt-flag enable-oop-rasterization" ]
    toggleFloat w = windows (\s -> if M.member w (W.floating s)
                                    then W.sink w s
                                    else (W.float w (W.RationalRect 0.15 0.15 0.7 0.7) s))

mousebindings =
  [ ((modkey .|. shiftMask, button1), dragWindow)
  , ((modkey, button1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))
  , ((modkey, button3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)) ]

scratchpads = [ NS "terminal" (term ++ " -t ScratchpadTerm") (title =? "ScratchpadTerm") (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)) ]

promptConfig = def
  { font                = fontFamily
  , bgColor             = "#16161c"
  , fgColor             = "#fdf0ed"
  , bgHLight            = "#e95678"
  , fgHLight            = "#16161c"
  , position            = Top
  , height              = 17
  , historySize         = 256
  , historyFilter       = id
  , showCompletionOnTab = False
  , searchPredicate     = fuzzyMatch
  , sorter              = fuzzySort
  , defaultPrompter     = \_ -> "xmonad λ: "
  , alwaysHighlight     = True
  , maxComplRows        = Just 5
  }

layouts = avoidStruts
          $ renamed [CutWordsLeft 5]
          $ smartBorders
          $ windowNavigation
          $ tabs
          $ boringWindows
          $ spacingRaw False (Border 4 4 4 4) True (Border 4 4 4 4) True
          $ draggingVisualizer
          $ maximizeWithPadding 0
          $ layoutHints
          $ (tall ||| Mirror tall ||| threecol ||| Grid)
  where
    tall = ResizableTall 1 (3/100) (11/20) []
    threecol = ResizableThreeColMid 1 (3/100) (1/2) []
    tabs x = addTabs shrinkText tabTheme $ subLayout [] Simplest x
    tabTheme = def
      { fontName            = fontFamily
      , activeColor         = "#e95678"
      , inactiveColor       = "#16161c"
      , urgentColor         = "#ee64ae"
      , activeTextColor     = "#16161c"
      , inactiveTextColor   = "#fdf0ed"
      , urgentTextColor     = "#16161c"
      , activeBorderColor   = "#e95678"
      , inactiveBorderColor = "#2e303e"
      , urgentBorderColor   = "#fab795"
      , activeBorderWidth   = 2
      , inactiveBorderWidth = 2
      , urgentBorderWidth   = 2
      }

windowRules = composeAll
  [ placeHook (smart (0.5, 0.5))
	, className  =? "Gimp"                                 --> doFloat
  , (className =? "Ripcord" <&&> title =? "Preferences") --> doFloat
  , className  =? "Gxmessage"                            --> doFloat
  , className  =? "Peek"                                 --> doFloat
  , className  =? "Xephyr"                               --> doFloat
  , className  =? "Sxiv"                                 --> doFloat
  , className  =? "mpv"                                  --> doFloat
  , appName    =? "polybar"                              --> doLower
  , appName    =? "desktop_window"                       --> doIgnore
  , appName    =? "kdesktop"                             --> doIgnore
  , isDialog                                             --> doF W.siftUp <+> doFloat
	, manageSpawn
	, namedScratchpadManageHook scratchpads
	, insertPosition End Newer
	, manageDocks
	, manageHook defaultConfig
	]
  where
    doLower = ask >>= \w -> unsafeSpawn ("/nix/store/qnax36vva8f36n4l4jhqcv60mg4675yi-xdo-0.5.7/bin/xdo lower " ++ show w) >> mempty

autostart = do
  spawnOnce "/nix/store/djc17y3h2qb36vszj0prch0gxwcs2cvw-xwallpaper-0.6.6/bin/xwallpaper --zoom /etc/nixos/config/wallpapers/horizon.jpg &"
  spawnOnce "/nix/store/10l39q3wrrjcr2ywi06wni1jdwv2jsqx-xsetroot-1.1.2/bin/xsetroot -cursor_name left_ptr &"
  spawnOnce "/nix/store/3w6n571gahilr2hs8294grvmm47i9fxp-xidlehook-0.9.1/bin/xidlehook --not-when-fullscreen --not-when-audio --timer 120 slock \'\' &"
  spawnOnce "/nix/store/q09wcs6zygjrbh48wxp952h5gnsbzavi-polybar-3.5.2/bin/polybar-msg cmd restart &"
  spawnOnce "/nix/store/h49sa2iaacr71ijfxg29hf9wz08lkyix-notify-desktop-0.2.0/bin/notify-desktop -u critical 'xmonad' 'started successfully'"

barHook dbus =
  let signal     = D.signal (D.objectPath_ "/org/xmonad/Log") (D.interfaceName_ "org.xmonad.Log") (D.memberName_ "Update")
      output str = D.emit dbus $ signal { D.signalBody = [D.toVariant $ UTF8.decodeString str] }
  in dynamicLogWithPP $ xmobarPP
    { ppOutput = output
    , ppOrder  = \(_:l:_:_) -> [l]
    }

main' dbus = xmonad . ewmhFullscreen . docks . ewmh . javaHack $ def
  { focusFollowsMouse  = True
  , clickJustFocuses   = True
  , borderWidth        = 2
  , modMask            = modkey
  , workspaces         = ws
  , normalBorderColor  = "#2e303e"
  , focusedBorderColor = "#e95678"
  , layoutHook         = layouts
  , manageHook         = windowRules
  , logHook            = barHook dbus
  , handleEventHook    = swallowEventHook (return True) (return True) <+> hintsEventHook
  , startupHook        = autostart
  }
  `additionalKeysP` keybindings
  `additionalMouseBindings` mousebindings

main = do
  dbus <- D.connectSession
  D.requestName dbus (D.busName_ "org.xmonad.log") [ D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue ]
  main' dbus -- "that was easy, xmonad rocks!"

help = unlines
  [ "fortuneteller2k's XMonad configuration"
  , ""
  , "Default keybindings:"
  , ""
  , "Alt-Enter:              spawn alacritty"
  , "Alt-b:                  spawn alacritty in a scratchpad"
  , "Alt-`:                  toggle distraction less mode"
  , "Alt-d:                  show run prompt"
  , "Alt-q:                  quit window"
  , "Alt-w:                  open treeselect for actions"
  , "Alt-F2:                 spawn qutebrowser"
  , "Alt-e:                  maximize window"
  , "Alt-Tab:                cycle through layouts"
  , "Alt-s:                  swap focused window with master window"
  , "Alt-minus:              shrink window"
  , "Alt-=:                  expand window"
  , "Alt-[:                  shrink window mirrored"
  , "Alt-]:                  expand window mirrored"
  , "Alt-t:                  toggle floating of window"
  , "Alt-,:                  increase number of master windows"
  , "Alt-.:                  decrease number of master windows"
  , "Alt-Left:               focus previous window"
  , "Alt-Right:              focus next window"
  , "Alt-LeftClick:          float window and drag it with cursor"
  , "Alt-RightClick:         float window and resize it"
  , "Alt-[0-9]:              for [1-9] go to nth workspace, for 0 go to 10th workspace"
  , "Alt-Print:              take screenshot of focused window and copy to clipboard"
  , "Alt-Shift-s:            take screenshot of whole screen and save it to a file"
  , "Alt-Shift-q:            exit xmonad"
  , "Alt-Shift-c:            force quit window"
  , "Alt-Shift-Delete:       lock screen"
  , "Alt-Shift-h:            show this help window"
  , "Alt-Shift-r:            restart xmonad and polybar"
  , "Alt-Shift-Left:         move window to previous workspace and focus that workspace"
  , "Alt-Shift-Right:        move window to next workspace and focus that workspace"
  , "Alt-Shift-Tab:          reset layout to Tall (master and stack)"
  , "Alt-Shift-LeftClick:    move window to dragged position"
  , "Alt-Ctrl-c:             kill all windows in workspace"
  , "Alt-Ctrl-Left:          group focused window to it's left"
  , "Alt-Ctrl-Right:         group focused window to it's right"
  , "Alt-Ctrl-Up:            group focused window to it's up"
  , "Alt-Ctrl-Down:          group focused window to it's down"
  , "Alt-Ctrl-m:             group all windows in workspace"
  , "Alt-Ctrl-u:             ungroup focused window"
  , "Alt-Ctrl-,:             focus previous window in group"
  , "Alt-Ctrl-.:             focus next window in group"
  , "Ctrl-Left:              focus previous workspace"
  , "Ctrl-Right:             focus next workspace"
  , "XF86AudioMute:          mute audio"
  , "XF86AudioPlay:          toggle play/pause"
  , "XF86AudioPrev:          go to previous"
  , "XF86AudioNext:          go to next"
  , "XF86AudioRaiseVolume:   raise volume by 10%"
  , "XF86AudioLowerVolume:   lower volume by 10%"
  , "XF86MonBrightnessUp:    raise brightness by 10%"
  , "XF86MonBrightnessDown:  lower brightness by 10%"
  ]
