-- Apply the discOS theme and re-apply whenever discos-theme regenerates it.
local dir  = vim.fn.expand('~/.config/discos/current-theme')
local file = dir .. '/nvim.lua'

local function apply()
  if vim.uv.fs_stat(file) then
    local ok, err = pcall(dofile, file)
    if not ok then vim.notify('discOS theme: ' .. err, vim.log.levels.WARN) end
  end
end

apply()

-- Watch the folder (not the file) so it survives the file being rewritten,
-- and debounce, since one discos-theme run triggers several write events.
local timer = vim.uv.new_timer()
vim.uv.new_fs_event():start(dir, {}, function(_, fname)
  if fname ~= 'nvim.lua' then return end
  timer:start(150, 0, vim.schedule_wrap(apply))
end)
