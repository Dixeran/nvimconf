print("hello world")

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- setup plugins
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
  }
  use {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional
    },
    config = function()
      require("nvim-tree").setup {}
    end
  }
  use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
  use 'folke/tokyonight.nvim'
  use {'neoclide/coc.nvim', branch = 'release'}
  use {'akinsho/bufferline.nvim', tag = "*", requires = 'nvim-tree/nvim-web-devicons'}
  use 'karb94/neoscroll.nvim'
  use 'm4xshen/autoclose.nvim'
  use {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup()
    end,
  }
  use 'dstein64/nvim-scrollview'
  use "lukas-reineke/indent-blankline.nvim"
  use { 'ibhagwan/smartyank.nvim' }
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'rmagatti/auto-session'
  use { 'rainbowhxch/accelerated-jk.nvim' }
  use {
    'gelguy/wilder.nvim',
    config = function()
      -- config goes here
    end,
  }
  use 'tpope/vim-unimpaired'

  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
vim.opt.cursorline = true

require('neoscroll').setup()
require("bufferline").setup{}
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  hijack_cursor = true,
  view = {
    width = 30,
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "ruby", "python" },
  highlight = {
    enable = true,
  },
  auto_install = true,
}

require("autoclose").setup()
require('scrollview').setup()

-- indent indicator
vim.opt.list = true

require("indent_blankline").setup {
    show_end_of_line = false,
}
require('smartyank').setup {}
require("auto-session").setup {
  log_level = "error",

  cwd_change_handling = {
    restore_upcoming_session = true, -- already the default, no need to specify like this, only here as an example
    pre_cwd_changed_hook = nil, -- already the default, no need to specify like this, only here as an example
    post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
      require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
    end,
  },
  pre_save_cmds = {"tabdo NvimTreeClose"},
  post_restore_cmds = {"tabdo NvimTreeOpen"}
  
}
require('accelerated-jk').setup()

local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})
wilder.set_option('renderer', wilder.renderer_mux({
  [':'] = wilder.popupmenu_renderer({
    highlighter = wilder.basic_highlighter(),
  }),
  ['/'] = wilder.wildmenu_renderer({
    highlighter = wilder.basic_highlighter(),
  }),
}))

-- set colro theme
vim.cmd [[colorscheme tokyonight-day]]

-- set nvim-tree autoclose
vim.api.nvim_create_autocmd({"QuitPre"}, {
    callback = function() vim.cmd("NvimTreeClose") end,
})

-- require other configs
dofile(os.getenv("HOME") .. '/.config/nvim/coc_keymap.lua')
dofile(os.getenv("HOME") .. '/.config/nvim/basic_edit.lua')
dofile(os.getenv("HOME") .. '/.config/nvim/telescope_conf.lua')

