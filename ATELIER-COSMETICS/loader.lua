-- ATELIER COSMETICS v0.3 public GitHub launcher.
-- For a Luau environment that explicitly supports loadstring and game:HttpGet.
-- Run only code from a GitHub repository you own and trust.
local url = "https://raw.githubusercontent.com/helpmefromschool/PRISM-RIVALS/main/ATELIER-COSMETICS/main.lua"
local source = game:HttpGet(url)
local compile = assert(loadstring(source), "ATELIER failed to compile")
compile()