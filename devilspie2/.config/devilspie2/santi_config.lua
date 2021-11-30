-- Assign Terminator and Firefox to workspace 1
if (get_application_name() == "terminator") then
  set_window_workspace(1);
end
if (get_application_name() == "Firefox") then
  set_window_workspace(1);
end

-- Assign Thunderbird to workspace 2
if (get_application_name() == "Thunderbird") then
  set_window_workspace(2);
end

-- Assign Telegram and Slack to workspace 3
if (get_application_name() == "TelegramDesktop") then
  set_window_workspace(3);
end
if (get_application_name() == "Slack") then
  set_window_workspace(3);
end

-- Assign Lollypop and Deluge to workspace 3
if (get_application_name() == "Lollypop") then
  set_window_workspace(4);
end
