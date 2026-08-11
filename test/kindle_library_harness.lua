-- Kindle-library downloads must select the native documents directory only when both the device
-- and the opt-in setting say so. Drive the real helper without loading KOReader UI modules.

local PLUGIN = assert(arg[1], "usage: luajit kindle_library_harness.lua <plugin-root> <luasocket-src>")
local support = dofile(PLUGIN .. "/test/support.lua")
local r = support.reporter()

local downloadDir = support.extract_function(PLUGIN .. "/zlibrary/download.lua", "_downloadDir", {
    Config = {
        KINDLE_DOCUMENTS_DIR = "/mnt/us/documents",
        DEFAULT_DOWNLOAD_DIR_FALLBACK = "/fallback",
    },
})

r.check("an opted-in Kindle uses its native documents directory",
    downloadDir(true, true, "/custom") == "/mnt/us/documents")
r.check("the setting does not affect a non-Kindle device",
    downloadDir(false, true, "/custom") == "/custom")
r.check("an opted-out Kindle keeps the configured KOReader directory",
    downloadDir(true, false, "/custom") == "/custom")
r.check("a missing configured directory falls back safely",
    downloadDir(false, false, nil) == "/fallback")

r.finish()
