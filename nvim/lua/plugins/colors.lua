return {

    {
        "AlexvZyl/nordic.nvim",
        name = "nordic",
        config = function()
            require('nordic').setup({
                bold_keywords = false,
                italic_comments = true,
                transparent = {
                    bg = true,
                    float = true,
                },
                bright_border = false,
                reduced_blue = true,
                swap_backgrounds = false,
                cursorline = {
                    bold = false,
                    bold_number = true,
                    theme = 'dark',
                    blend = 0.85,
                },
                noice = {
                    style = 'classic',
                },
                telescope = {
                    style = 'flat',
                },
                leap = {
                    dim_backdrop = false,
                },
                ts_context = {
                    dark_background = true,
                },
                on_palette = function(palette) end,
                after_palette = function(palette) end,
                on_highlight = function(highlights, palette) end,
            })

            -- vim.cmd("colorscheme nordic")
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                variant = "auto", -- auto, main, moon, or dawn
                dark_variant = "main", -- main, moon, or dawn
                dim_inactive_windows = false,
                extend_background_behind_borders = true,

                enable = {
                    terminal = true,
                    legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
                    migrations = true, -- Handle deprecated options automatically
                },

                styles = {
                    bold = true,
                    italic = false, -- no italics bro
                    transparency = true,
                },

                groups = {
                    border = "muted",
                    link = "iris",
                    panel = "surface",

                    error = "love",
                    hint = "iris",
                    info = "foam",
                    note = "pine",
                    todo = "rose",
                    warn = "gold",

                    git_add = "foam",
                    git_change = "rose",
                    git_delete = "love",
                    git_dirty = "rose",
                    git_ignore = "muted",
                    git_merge = "iris",
                    git_rename = "pine",
                    git_stage = "iris",
                    git_text = "rose",
                    git_untracked = "subtle",

                    h1 = "iris",
                    h2 = "foam",
                    h3 = "rose",
                    h4 = "gold",
                    h5 = "pine",
                    h6 = "foam",
                },

                palette = {
                    -- Override the builtin palette per variant
                    -- moon = {
                        --     base = '#18191a',
                        --     overlay = '#363738',
                        -- },
                    },

                    -- NOTE: Highlight groups are extended (merged) by default. Disable this
                    -- per group via `inherit = false`
                    highlight_groups = {
                        -- Comment = { fg = "foam" },
                        -- StatusLine = { fg = "love", bg = "love", blend = 15 },
                        -- VertSplit = { fg = "muted", bg = "muted" },
                        -- Visual = { fg = "base", bg = "text", inherit = false },
                    },

                    before_highlight = function(group, highlight, palette)
                        -- Disable all undercurls
                        -- if highlight.undercurl then
                        --     highlight.undercurl = false
                        -- end
                        --
                        -- Change palette colour
                        -- if highlight.fg == palette.pine then
                        --     highlight.fg = palette.foam
                        -- end
                    end,
                })

                -- vim.cmd("colorscheme rose-pine")
                -- vim.cmd("colorscheme rose-pine-main")
                vim.cmd("colorscheme rose-pine-moon")
                -- vim.cmd("colorscheme rose-pine-dawn")
            end
        },

        {
            "vague-theme/vague.nvim",
            lazy = false, -- make sure we load this during startup if it is your main colorscheme
            priority = 1000, -- make sure to load this before all the other plugins
            config = function()
                -- NOTE: you do not need to call setup if you don't want to.
                require("vague").setup({
                    -- optional configuration here
                    -- Don't set background
                    transparent = true,
                    -- Disable bold/italic globally
                    bold = true,
                    italic = false,

                    -- Override highlights or add new highlights
                    on_highlights = function(highlights, colors) end,

                    -- Override colors
                    colors = {
                        bg = "#141415",
                        inactiveBg = "#1c1c24",
                        fg = "#cdcdcd",
                        floatBorder = "#878787",
                        line = "#252530",
                        comment = "#71718A",
                        builtin = "#b4d4cf",
                        func = "#c48282",
                        string = "#e8b589",
                        number = "#e0a363",
                        property = "#c3c3d5",
                        constant = "#aeaed1",
                        parameter = "#bb9dbd",
                        visual = "#333738",
                        error = "#d8647e",
                        warning = "#f3be7c",
                        hint = "#7e98e8",
                        operator = "#90a0b5",
                        keyword = "#6e94b2",
                        type = "#9bb4bc",
                        search = "#405065",
                        plus = "#7fa563",
                        delta = "#f3be7c",
                    }
                })
                vim.cmd("colorscheme vague")
            end
        },

    }
