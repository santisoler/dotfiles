-- Assign Terminator workspace 1
if (get_application_name() == "terminator") then
  set_window_workspace(1);
  change_workspace(1);
end

-- Assign Firefox to workspace 1
if (get_application_name() == "Firefox") then
  set_window_workspace(1);
  change_workspace(1);
end

-- Assign Thunar to workspace 2
if (get_application_name() == "Thunar") then
  set_window_workspace(2);
  change_workspace(2);
end

-- Assign Thunderbird to workspace 3
if (get_application_name() == "Thunderbird") then
  set_window_workspace(3);
  change_workspace(3);
end

-- Assign Telegram and Slack to workspace 4
if (get_application_name() == "TelegramDesktop") then
  set_window_workspace(4);
  change_workspace(4);
end
if string.match(get_application_name(), "Slack") then
  set_window_workspace(4);
  change_workspace(4);
end

-- Assign Lollypop to workspace 5
if (get_application_name() == "Lollypop") then
  set_window_workspace(5);
  change_workspace(5);
end
