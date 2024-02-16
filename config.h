/* See LICENSE file for copyright and license details. */
    /* appearance */
    static const unsigned int borderpx  = 1;        /* border pixel of windows */
    static const unsigned int snap      = 32;       /* snap pixel */
    static const int showbar            = 0;        /* 0 means no bar */
    static const int topbar             = 1;        /* 0 means bottom bar */
    static const char *fonts[]          = { "monospace:size=10" };
    static const char dmenufont[]       = "monospace:size=10";
    static const char col_gray1[]       = "#222222";
    static const char col_gray2[]       = "#444444";
    static const char col_gray3[]       = "#bbbbbb";
    static const char col_gray4[]       = "#eeeeee";
    static const char col_cyan[]        = "#005577";
    static const char *colors[][3]      = {
        /*               fg         bg         border   */
        [SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
        [SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
    };

    /* tagging */
    static const char *tags[] = {"surf"};

    static const Rule rules[] = {
        /* xprop(1):
         *	WM_CLASS(STRING) = instance, class
         *	WM_NAME(STRING) = title
         */
        /* class      instance    title       tags mask     isfloating   monitor */
        { "surf",     NULL,       NULL,       1 << 0,            False,           -1 },
    };

    /* layout(s) */
    static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
    static const int nmaster     = 1;    /* number of clients in master area */
    static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
    static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

    static const Layout layouts[] = {
        /* symbol     arrange function */
        { "[]=",      tile },    /* first entry is default */
        { "><>",      NULL },    /* no layout function means floating behavior */
        { "[M]",      monocle },
    };

    /* key definitions */
    #define MODKEY Mod1Mask
    #define TAGKEYS(KEY,TAG) \
        { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
        { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
        { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
        { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

    /* helper for spawning shell commands in the pre dwm-5.0 fashion */
    #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

    /* commands */
    static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
    static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
    static const char *termcmd[]  = { "st", NULL };

    static const Key keys[] = {
        /* modifier                     key        function        argument */
        TAGKEYS(                        XK_1,                      0)

    };

    /* button definitions */
    /* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
    static const Button buttons[] = {
        /* click                event mask      button          function        argument */
        { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },

    };
