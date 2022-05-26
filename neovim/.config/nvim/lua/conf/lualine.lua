-- Configure lualine
local function getWords()
  if vim.bo.filetype == "tex" or vim.bo.filetype == "txt" or vim.bo.filetype == "markdown" then
    if vim.fn.wordcount().visual_words == 1 then
      return tostring(vim.fn.wordcount().visual_words) .. " word"
    elseif not (vim.fn.wordcount().visual_words == nil) then
      return tostring(vim.fn.wordcount().visual_words) .. " words"
    else
      return tostring(vim.fn.wordcount().words) .. " words"
    end
  else
    return ""
  end
end

-- Define function for getting conda environment
local function getCondaEnv()
    local conda_env = os.getenv("CONDA_DEFAULT_ENV")
    if conda_env == "" then
        return ""
    end
    return " " .. conda_env
end

require('lualine').setup {
  options = {
    section_separators = '',
    component_separators = ''
  },
  sections = {
    lualine_b = {'branch', 'diff', getCondaEnv, 'diagnostics'},
    lualine_y = {getWords, 'progress'},
  },
}
