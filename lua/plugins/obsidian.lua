return {
  {
    "vhyrro/luarocks.nvim",
    priority = 1001,
    opts = {
      rocks = { "magick" },
    },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = true,
          filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
        },
        neorg = {
          enabled = false,
        },
        html = {
          enabled = false,
        },
        css = {
          enabled = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 40,
      window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    },
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    event = {
      "VimEnter",
    },
    config = function(_, opts)
      -- Ensure obsidian.nvim loads if Neovim starts inside ~/Documents/Notes/
      if vim.fn.getcwd():match(vim.fn.expand("~/Documents/Notes")) then
        require("obsidian").setup(opts)
      end
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "3rd/image.nvim",
      "HakonHarnes/img-clip.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Documents/Notes",
        },
      },

      log_level = vim.log.levels.INFO,

      daily_notes = {
        folder = "Areas/Daily-Notes",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = "Resources/Templates/Daily Note Template.md",
      },

      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },

      -- Where to put new notes.
      new_notes_location = "Projects/Inbox",

      -- Optional, customize how note IDs are generated given an optional title.
      note_id_func = function(title)
        local suffix = "new-file"
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        end

        return suffix
      end,

      -- Optional, customize how wiki links are formatted. You can set this to one of:
      --  * "use_alias_only", e.g. '[[Foo Bar]]'
      --  * "prepend_note_id", e.g. '[[foo-bar|Foo Bar]]'
      --  * "prepend_note_path", e.g. '[[foo-bar.md|Foo Bar]]'
      --  * "use_path_only", e.g. '[[foo-bar.md]]'
      -- Or you can set it to a function that takes a table of options and returns a string, like this:
      wiki_link_func = function(opts)
        return require("obsidian.util").wiki_link_id_prefix(opts)
      end,

      -- Optional, customize how markdown links are formatted.
      markdown_link_func = function(opts)
        return require("obsidian.util").markdown_link(opts)
      end,

      -- Either 'wiki' or 'markdown'.
      preferred_link_style = "wiki",

      -- Optional, boolean or a function that takes a filename and returns a boolean.
      -- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
      disable_frontmatter = false,

      -- Optional, alternatively you can customize the frontmatter data.
      ---@return table
      note_frontmatter_func = function(note)
        -- Check if the note is inside the 'Areas/Daily-Notes' folder, then dont attach frontmatter
        if string.find(note.path.filename, "Areas/Daily-Notes", 1, true) then
          return {}
        end

        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

        local out = {
          id = note.id,
          aliases = note.aliases,
          tags = note.tags,
        }

        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end

        return out
      end,

      -- Optional, for templates (see below).
      templates = {
        folder = "Resources/Templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        -- A map for custom variables, the key should be the variable and the value a function
        substitutions = {},
      },

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      ---@param url string
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
        vim.ui.open(url) -- need Neovim 0.10.0+
      end,

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an image
      -- file it will be ignored but you can customize this behavior here.
      ---@param img string
      follow_img_func = function(img)
        vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
        -- vim.cmd(':silent exec "!start ' .. url .. '"') -- Windows
      end,

      -- Optional, set to true if you use the Obsidian Advanced URI plugin.
      -- https://github.com/Vinzent03/obsidian-advanced-uri
      use_advanced_uri = false,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,

      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-n>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-n>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },

      -- Optional, sort search results by "path", "modified", "accessed", or "created".
      -- The recommend value is "modified" and `true` for `sort_reversed`, which means, for example,
      -- that `:ObsidianQuickSwitch` will show the notes sorted by latest modified time
      sort_by = "modified",
      sort_reversed = true,

      -- Set the maximum number of lines to read from notes on disk when performing certain searches.
      search_max_lines = 1000,

      -- Optional, determines how certain commands open notes. The valid options are:
      -- 1. "current" (the default) - to always open in the current window
      -- 2. "vsplit" - to open in a vertical split if there's not already a vertical split
      -- 3. "hsplit" - to open in a horizontal split if there's not already a horizontal split
      open_notes_in = "current",

      -- Optional, configure additional syntax highlighting / extmarks.
      -- This requires you have `conceallevel` set to 1 or 2. See `:help conceallevel` for more details.
      ui = {
        enable = false, -- set to false to disable all additional syntax features
        -- update_debounce = 200,  -- update delay after a text change (in milliseconds)
        -- max_file_length = 5000, -- disable UI features for files with more than this many lines
        -- -- Define how various check-boxes are displayed
        -- checkboxes = {
        --   -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        --   [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
        --   ["x"] = { char = "", hl_group = "ObsidianDone" },
        --   [">"] = { char = "", hl_group = "ObsidianRightArrow" },
        --   ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
        --   ["!"] = { char = "", hl_group = "ObsidianImportant" },
        --   -- Replace the above with this if you don't have a patched font:
        --   -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        --   -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },
        --
        --   -- You can also add more custom ones...
        -- },
        -- -- Use bullet marks for non-checkbox lists.
        -- bullets = { char = "•", hl_group = "ObsidianBullet" },
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- -- Replace the above with this if you don't have a patched font:
        -- -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- reference_text = { hl_group = "ObsidianRefText" },
        -- highlight_text = { hl_group = "ObsidianHighlightText" },
        -- tags = { hl_group = "ObsidianTag" },
        -- block_ids = { hl_group = "ObsidianBlockID" },
        -- hl_groups = {
        --   -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        --   ObsidianTodo = { bold = true, fg = "#f78c6c" },
        --   ObsidianDone = { bold = true, fg = "#89ddff" },
        --   ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
        --   ObsidianTilde = { bold = true, fg = "#ff5370" },
        --   ObsidianImportant = { bold = true, fg = "#d73128" },
        --   ObsidianBullet = { bold = true, fg = "#89ddff" },
        --   ObsidianRefText = { underline = true, fg = "#c792ea" },
        --   ObsidianExtLinkIcon = { fg = "#c792ea" },
        --   ObsidianTag = { italic = true, fg = "#89ddff" },
        --   ObsidianBlockID = { italic = true, fg = "#89ddff" },
        --   ObsidianHighlightText = { bg = "#75662e" },
        -- },
      },

      -- Specify how to handle attachments.
      attachments = {
        -- The default folder to place images in via `:ObsidianPasteImg`.
        -- If this is a relative path it will be interpreted as relative to the vault root.
        -- You can always override this per image by passing a full path to the command instead of just a filename.
        img_folder = "Archive/Assets",

        -- Optional, customize the default name or prefix when pasting images via `:ObsidianPasteImg`.
        ---@return string
        img_name_func = function()
          -- Prefix image names with timestamp.
          return string.format("%s-", os.time())
        end,

        -- A function that determines the text to insert in the note when pasting an image.
        -- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
        -- This is the default implementation.
        ---@param client obsidian.Client
        ---@param path obsidian.Path the absolute path to the image file
        ---@return string
        img_text_func = function(client, path)
          path = client:vault_relative_path(path) or path
          return string.format("![%s](%s)", path.name, path)
        end,
      },
    },
  },
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        -- file and directory options
        dir_path = "Archive/Assets", ---@type string | fun(): string
        extension = "png", ---@type string | fun(): string
        use_absolute_path = false, ---@type boolean | fun(): boolean
        relative_to_current_file = false, ---@type boolean | fun(): boolean

        -- template options
        template = "$FILE_PATH", ---@type string | fun(context: table): string
        url_encode_path = false, ---@type boolean | fun(): boolean
        relative_template_path = true, ---@type boolean | fun(): boolean
        use_cursor_in_template = true, ---@type boolean | fun(): boolean
        insert_mode_after_paste = true, ---@type boolean | fun(): boolean

        -- prompt options
        prompt_for_file_name = true, ---@type boolean | fun(): boolean
        show_dir_path_in_prompt = true, ---@type boolean | fun(): boolean

        -- base64 options
        max_base64_size = 10, ---@type number | fun(): number
        embed_image_as_base64 = false, ---@type boolean | fun(): boolean

        -- image options
        process_cmd = "convert - -quality 75 png:-", ---@type string | fun(): string
        copy_images = false, ---@type boolean | fun(): boolean
        download_images = true, ---@type boolean | fun(): boolean

        -- drag and drop options
        drag_and_drop = {
          enabled = true, ---@type boolean | fun(): boolean
          insert_mode = false, ---@type boolean | fun(): boolean
        },
      },

      -- filetype specific options
      filetypes = {
        markdown = {
          url_encode_path = true, ---@type boolean | fun(): boolean
          template = "![$FILE_NAME]($FILE_PATH)", ---@type string | fun(context: table): string
          download_images = false, ---@type boolean | fun(): boolean
        },
      },

      -- file, directory, and custom triggered options
      files = {}, ---@type table | fun(): table
      dirs = {}, ---@type table | fun(): table
      custom = {}, ---@type table | fun(): table
    },
    keys = {
      -- suggested keymap
      { "<leader>v", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim", -- another markdown beautifier
    main = "render-markdown",
    opts = {
      render_modes = { "n", "v", "i", "c", "t", "x" },
      anti_conceal = {
        enabled = true,
      },
      checkbox = {
        enabled = true,
      },
      win_options = {
        conceallevel = {
          default = 2,
          rendered = 2,
        },
      },
      bullet = {
        enabled = true,
        -- Replaces '-'|'+'|'*' of 'list_item'
        -- How deeply nested the list is determines the 'level'
        -- The 'level' is used to index into the array using a cycle
        -- If the item is a 'checkbox' a conceal is used to hide the bullet instead
        icons = { "●", "○", "◆", "◇" },
        -- Padding to add to the left of bullet point
        left_pad = 1,
        -- Padding to add to the right of bullet point
        right_pad = 0,
        -- Highlight for the bullet icon
        highlight = "RenderMarkdownBullet",
      },
      link = {
        enabled = false,
      },
      heading = {
        -- Turn on / off heading icon & background rendering
        enabled = true,
        -- Turn on / off any sign column related rendering
        sign = false,
        -- Replaces '#+' of 'atx_h._marker'
        -- The number of '#' in the heading determines the 'level'
        -- The 'level' is used to index into the array using a cycle
        -- The result is left padded with spaces to hide any additional '#'
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        -- Added to the sign column if enabled
        -- The 'level' is used to index into the array using a cycle
        signs = { "󰫎 " },
        -- Width of the heading background:
        --  block: width of the heading text
        --  full: full width of the window
        width = "block",
        left_pad = 0,
        right_pad = 1,
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },

      code = {
        -- Turn on / off code block & inline code rendering
        enabled = true,
        -- Turn on / off any sign column related rendering
        sign = false,
        -- Determines how code blocks & inline code are rendered:
        --  none: disables all rendering
        --  normal: adds highlight group to code blocks & inline code, adds padding to code blocks
        --  language: adds language icon to sign column if enabled and icon + name above code blocks
        --  full: normal + language
        style = "full",
        -- Amount of padding to add to the left of code blocks
        left_pad = 1,
        -- Amount of padding to add to the right of code blocks when width is 'block'
        right_pad = 1,
        -- Width of the code block background:
        --  block: width of the code block
        --  full: full width of the window
        width = "block",
        -- Determins how the top / bottom of code block are rendered:
        --  thick: use the same highlight as the code body
        --  thin: when lines are empty overlay the above & below icons
        border = "thin",
        -- Used above code blocks for thin border
        -- above = '▄',
        above = "-",
        -- Used below code blocks for thin border
        -- below = '▀',
        below = "-",
        -- Highlight for code blocks & inline code
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
      },
      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
        -- Obsidian: https://help.a.md/Editing+and+formatting/Callouts
        abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
        todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
        success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
        question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
        failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
        danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
        bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
        example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
        quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
      },
      latex = { enabled = true },
    },

    name = "render-markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
  },
}
