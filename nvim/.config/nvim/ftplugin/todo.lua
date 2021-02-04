function ToggleTask()
    local line = vim.api.nvim_get_current_line()

    if vim.regex("☐"):match_str(line) ~= nil then
        local new_line = string.gsub(line, "☐", "✔")
        vim.api.nvim_set_current_line(new_line)
    elseif vim.regex("✔"):match_str(line) ~= nil then
        local new_line = string.gsub(line, "✔", "☐")
        vim.api.nvim_set_current_line(new_line)
    end
end

function AddTask()
    vim.api.nvim_input("o☐ ")
end

map("n", "<leader>ta", "<cmd>lua AddTask()<CR>")
map("n", "<leader>tt", "<cmd>lua ToggleTask()<CR>")
