local colour = require("arshlib.colour")
require("arshlib.util")

local store = {} --{{{
__Clipboard_storage = __Clipboard_storage or _t()
store = __Clipboard_storage

local clipboard_group = vim.api.nvim_create_augroup("CLIPBOARD", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = clipboard_group,
  pattern = "*",
  callback = function()
    table.insert(store, 1, vim.v.event)
  end,
})
--}}}

local defaults = {
  history = "<leader>yh",
}

return {
  config = function(opts)
    opts = vim.tbl_extend("force", defaults, opts or {})
    vim.validate({ --{{{
      history = { opts.history, { "string", "boolean", "nil" } },
    }) --}}}

    if opts.history then
      -- Lists all yank history, and will set it to the unnamed register on
      -- selection.
      vim.keymap.set("n", opts.history, function()
        local yank_list = {}
        local seen = {}
        _t(store)
          :filter(function(v) --{{{
            local key = table.concat(v.regcontents, "\n"):gsub("%s+", "")
            if seen[key] then
              return false
            end
            seen[key] = true
            return true
          end) --}}}
          :map(function(v, i) --{{{
            local value = table.concat(
              v.regcontents,
              colour.ansi_color(colour.colours.blue, "<CR>")
            )
            local type = "BLOCK"
            if v.regtype == "v" then
              type = "visual"
            elseif v.regtype == "V" then
              type = "VISUAL"
            end
            table.insert(
              yank_list,
              string.format(
                "%d\t%s\t%s\t%s",
                i,
                v.regtype,
                colour.ansi_color(colour.colours.green, type),
                value
              )
            )
          end) --}}}

        if #yank_list == 0 then
          return
        end

        local wrapped = vim.fn["fzf#wrap"]({ --{{{
          source = yank_list,
          options = table.concat({
            '--prompt "Preciously Yanked > "',
            "+m",
            "--ansi",
            '-d "\t"',
            "--with-nth 1,3..",
            "--nth 1,3..",
          }, " "),
        })

        wrapped["sink*"] = function(line)
          local type, value = string.gmatch(line[2], "%d+\t([^\t]+)\t.+\t(.+)$")()
          value = value:gsub("<CR>", "\n")
          vim.fn.setreg('"', value, type)
        end --}}}
        vim.fn["fzf#run"](wrapped)
      end, { silent = true, desc = "Show yank history" })
    end
  end,
}

-- vim: fdm=marker fdl=0
