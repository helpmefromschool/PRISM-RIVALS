# PRISM V5.17.1 protected release candidate

This is a separately packaged, **minified** release candidate. The executable PRISM file is **not** uploaded into this documentation branch. The public `main/PRISM.lua` remains V5.16 and is untouched.

- Protected candidate SHA-256: `AF97947EC3967D3C5BE1EABAA4525703CF8ED3D4EB028961D7BAD37E4CBFFFC4`
- The original V5.17.1 source has been kept separate, outside this release package.
- Lua parsing and comparison of meaningful Lua tokens passed; actual Matcha execution remains untested.
- Before publishing the candidate: test selection, Apply All, changing tabs afterward, backup recovery, and closing/reopening PRISM.
- Publish a versioned GitHub Release only after successful tests, and include this checksum in the official description. The ZIP is held privately until release.

**Important:** Minification is not encryption or uncrackable DRM. Local Lua can be read, copied and modified. Checksums let users compare files with a trusted official release, but do not enforce software restrictions. Do not publish passwords, tokens, private configurations, or personal Matcha files.
