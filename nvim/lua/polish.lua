-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Silence Neovim core's "method ... is not supported by any server activated
-- for this buffer" notify spam (textDocument/documentHighlight,
-- textDocument/signatureHelp) fired by AstroLSP's CursorHold autocmd and
-- blink.cmp's per-keystroke signature help while a client (e.g. gopls) is
-- still attaching to a buffer. Cosmetic race, not a real error.
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:match "is not supported by any server activated" then return end
  notify(msg, level, opts)
end
