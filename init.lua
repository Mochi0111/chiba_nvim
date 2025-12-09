vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bold = true })
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.swapfile = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.termguicolors = true
vim.o.pumblend=10
vim.o.winblend=30
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
keymap("n", "<Space>", "<Nop>", {silent = true})
keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", ":q<CR>")
keymap("n", "<leader>co", "<cmd>copen<CR>", { silent = true })
keymap("n", "<leader>cc", "<cmd>cclose<CR>", { silent = true })
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")
keymap("n", "<leader>lr", ":LspRestart<CR>", { desc = "Restart LSP"})

require("lazy").setup({
	-- カラースキーム
	{
		"talha-akram/noctis.nvim",
		name = "noctis",
        lazy = false,
	},
    -- Lualine 
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config = function()
            require("lualine").setup({
                options = {
                    theme = "auto",
                    icons_enabled = true,
                    section_separators = "",
                    component_separators = "",
                },
            })
        end
    },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "vim",
                    "bash",
                    "python",
                    "cpp",
                    "json",
                    "markdown",
                },
                highlight = { enable = true },
                indent = { enable = true },
                auto_install = true,
            })
        end
    },
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

            telescope.setup({
                defaults = {
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    layout_config = {
                        prompt_position = "top",
                    },
                },
                pickers = {
                    buffers = {
                        sort_mru = true,
                        ignore_current_buffer = true,
                        mappings = {
                            i = {
                                ["<C-d>"] = actions.delete_buffer,
                            },
                            n = {
                                ["dd"] = actions.delete_buffer,
                            },
                        },
                    },
                },
            })
            -- ⏩ キーバインド（好みで変更可）
            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fc", builtin.current_buffer_fuzzy_find, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
        end
    },
    -- toggleterm.nvim
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup {
                open_mapping = [[<leader>tt]],
                direction = "float",
            }
        end,
    },
    -- lazygit (toggletermと組み合わせるパターン
    {
        "kdheepak/lazygit.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function()
            vim.keymap.set("n", "<leader>gg", function()
                vim.cmd("LazyGit")
            end, { desc = "open LazyGit" })
        end
    },
    --  neo-tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies =  { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
        },
        config = function()
            require("nvim-tree").setup({})
        end,
    },
    -- autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({})
        end
    },
    --  LSP + 補完まわり
    {
        --  LSPサーバー管理
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    {
        -- masonとlspconfigの橋渡し
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"williamboman/mason.nvim"},
    },
    {
        -- LSP本体
        "neovim/nvim-lspconfig",
    },
    -- 補完エンジン本体
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "numTOStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },
})

-- カラースキーム適用
vim.cmd("colorscheme noctis_obscuro")

-- lsp config読み出し
require("config.lsp")
require("config.cmp")

-- Comment.nvim 用のキーマップ（Ctrl + / でトグル）
vim.keymap.set("n", "<C-_>", function()
    require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true, desc = "Toggle comment (line)" })

vim.keymap.set("v", "<C-_>", function()
    local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
    vim.api.nvim_feedkeys(esc, "nx", false)
    require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true, desc = "Toggle comment (visual)" })
