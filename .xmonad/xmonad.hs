--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.WorkspaceNames
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.ResizableTile
import XMonad.Layout.TrackFloating
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.BoringWindows as B
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.StackSet hiding (focus, workspaces)
import XMonad.Util.Run
import Control.Applicative
import Control.Monad
import Control.Monad.Writer
import Data.Maybe
import Data.Traversable (traverse)
import Graphics.X11.Xinerama
import System.Exit
import System.IO

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal :: String
myTerminal = "urxvt"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth :: Dimension
myBorderWidth = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
myModMask = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces :: [String]
myWorkspaces = map show [1 .. 9]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#073642"
myFocusedBorderColor = "#dc322f"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    , ((modm,               xK_o     ), spawn "chrome")
    , ((modm,               xK_e     ), spawn "emacs")
    , ((modm .|. shiftMask, xK_r     ), spawn "sudo systemctl suspend")
    , ((modm .|. shiftMask, xK_d     ), spawn "sudo systemctl hibernate")
    , ((modm,               xK_p     ), shellPrompt myXPConfig)
    , ((modm .|. shiftMask, xK_p     ), renameWorkspace myXPConfig)
    , ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm,               xK_space ), sendMessage NextLayout)
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)
    , ((modm,               xK_n     ), refresh)
    , ((modm,               xK_Tab   ), toggleWS)
    , ((modm,               xK_j     ), windows W.focusDown)
    , ((modm,               xK_k     ), windows W.focusUp)
    , ((modm,               xK_m     ), windows W.focusMaster)
    , ((modm,               xK_Return), windows W.swapMaster)
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown)
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp)
    , ((modm,               xK_h     ), sendMessage Shrink)
    , ((modm,               xK_l     ), sendMessage Expand)
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))
    , ((modm .|. shiftMask, xK_h     ), moveTo Prev NonEmptyWS)
    , ((modm .|. shiftMask, xK_l     ), moveTo Next NonEmptyWS)
    , ((modm .|. controlMask,               xK_h     ), nextScreen)
    , ((modm .|. controlMask,               xK_l     ), prevScreen)
    , ((modm .|. controlMask .|. shiftMask, xK_h     ), swapNextScreen)
    , ((modm .|. controlMask .|. shiftMask, xK_l     ), swapPrevScreen)
    , ((modm              , xK_b     ), sendMessage ToggleStruts)
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm              , xK_BackSpace), focusUrgent)
    , ((modm              , xK_a     ), sendMessage MirrorShrink)
    , ((modm              , xK_z     ), sendMessage MirrorExpand)
    , ((modm .|. shiftMask,                 xK_x     ), spawn "xscreensaver-command -lock")
    ]

    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = smartBorders
         . avoidStruts
         $ tiled ||| trackFloating (tabbed shrinkText myTabConfig) ||| Mirror tiled ||| Full
         -- $ tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = ResizableTall nmaster delta ratio []
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"          --> doFloat
    , resource  =? "desktop_window"   --> doIgnore
    , resource  =? "kdesktop"         --> doIgnore
    , isFullscreen                    --> doFullFloat
    , manageDocks
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = fullscreenEventHook <+> docksEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook hs = multiPP myPP myPP { ppTitle = const "" } hs

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad . withUrgencyHook NoUrgencyHook
              -- . withNavigation2DConfig defaultNavigation2DConfig
              . defaults =<< mapM xmobarScreen =<< getScreens

myPP = xmobarPP { ppTitle   = xmobarColor "#657b83" ""
                , ppSep     = " | "
                , ppLayout  = xmobarColor "#dc322f" "" .
                    (\x -> case x of
                             "Tall"                        -> "T"
                             "ResizableTall"               -> "T"
                             "Tabbed ResizableTall"        -> "T"
                             "Mirror Tall"                 -> "MT"
                             "Mirror ResizableTall"        -> "MT"
                             "Tabbed Mirror ResizableTall" -> "MT"
                             "Full"                        -> "F"
                             "Hinted Full"                 -> "HF"
                             "Tabbed Full"                 -> "TF"
                             "Tabbed Simplest"             -> "TS"
                             "Tabbed Tabbed Simplest"      -> "TS"
                             _                             -> x
                    )
                , ppUrgent  = xmobarColor "#fdf6e3" "#dc322f" . pad
                , ppCurrent = xmobarColor "#fdf6e3" "#268bd2" . pad
                , ppVisible = xmobarColor "#fdf6e3" "#586e75" . pad
                }

myXPConfig = defaultXPConfig
    { font     = "xft:Inconsolata:size=14:Medium"
    , position = Top
    , bgColor  = "#002330"
    , fgColor  = "#657b83"
    , bgHLight = "#268bd2"
    , fgHLight = "#fdf6e3"
    , height   = 24
    , promptBorderWidth = 0
    }

myTabConfig = defaultTheme
    { fontName            = "xft:Inconsolata:size=12:Medium"
    , activeColor         = "#002b36"
    , activeBorderColor   = "#dc322f"
    , activeTextColor     = "#657b83"
    , inactiveColor       = "#002330"
    , inactiveBorderColor = "#002330"
    , inactiveTextColor   = "#657b83"
    , urgentColor         = "#dc322f"
    , urgentBorderColor   = "#dc322f"
    , urgentTextColor     = "#fdf6e3"
    }

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults hs = defaultConfig {
    -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook hs,
        startupHook        = myStartupHook
    }

-------------------- Support for per-screen xmobars ---------
-- Some parts of this should be merged into contrib sometime
getScreens :: IO [Int]
getScreens = openDisplay "" >>= liftA2 (<*) f closeDisplay
    where f = fmap (zipWith const [0..]) . getScreenInfo

multiPP :: PP -- ^ The PP to use if the screen is focused
        -> PP -- ^ The PP to use otherwise
        -> [Handle] -- ^ Handles for the status bars, in order of increasing X
                    -- screen number
        -> X ()
multiPP = multiPP' dynamicLogString

multiPP' :: (PP -> X String) -> PP -> PP -> [Handle] -> X ()
multiPP' dynlStr focusPP unfocusPP handles = do
    state <- get
    let pickPP :: WorkspaceId -> WriterT (Last XState) X String
        pickPP ws = do
            let isFoc = (ws ==) . W.tag . W.workspace . W.current $ windowset state
            put state { windowset = W.view ws $ windowset state }
            namedPP <- lift $ workspaceNamesPP $ if isFoc then focusPP else unfocusPP
            out <- lift $ dynlStr namedPP
            when isFoc $ get >>= tell . Last . Just
            return out
    traverse put . getLast
        =<< execWriterT . (io . zipWithM_ hPutStrLn handles <=< mapM pickPP) . catMaybes
        =<< mapM screenWorkspace (zipWith const [0..] handles)
    return ()

-- | Requires a recent addition to xmobar (>0.9.2), otherwise you have to use
-- multiple configuration files, which gets messy
xmobarScreen :: Int -> IO Handle
xmobarScreen = spawnPipe . ("xmobar -x " ++) . show
