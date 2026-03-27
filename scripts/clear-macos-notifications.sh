#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clear Notifications
# @raycast.mode silent
# @raycast.icon 🔕

osascript <<'EOF'

-- macOS 15 Sequoia Compatibility
-- Set of close action phrases in multiple languages
property closeActionSet : {"Close", "Clear All", "Schließen", "Alle entfernen", "Cerrar", "Borrar todo", "关闭", "清除全部", "Fermer", "Tout effacer", "Закрыть", "Очистить все", "إغلاق", "مسح الكل", "Fechar", "Limpar tudo", "閉じる", "すべてクリア", "बंद करें", "सभी हटाएं", "Zamknij", "Wyczyść wszystko"}

-- Function to perform close action on a given element
on closeNotification(elemRef)
	tell application "System Events"
		try
			set theActions to actions of elemRef
			repeat with act in theActions
				if description of act is in closeActionSet then
					perform act
					return true
				end if
			end repeat
		end try
	end tell
	return false
end closeNotification

-- Function to recursively search for and close notifications
on searchAndCloseNotifications(elemRef)
	tell application "System Events"
		-- If the element has subelements, search them first
		try
			set subElements to UI elements of elemRef
			repeat with subElem in subElements
				if my searchAndCloseNotifications(subElem) then
					return true
				end if
			end repeat
		end try

		-- Try to close the current element if it's a notification
		if my closeNotification(elemRef) then
			return true
		end if
	end tell
	return false
end searchAndCloseNotifications

-- Main script to clear notifications
on run
	tell application "System Events"
		if not (exists process "NotificationCenter") then
			return "NotificationCenter process not running"
		end if

		tell process "NotificationCenter"
			if not (exists window "Notification Center") then
				return "Notification Center is not open"
			end if

			set notificationWindow to window "Notification Center"
			set closedCount to 0

			-- Main loop to clear notifications
			repeat
				try
					if not my searchAndCloseNotifications(notificationWindow) then
						-- If no notifications were closed, we're done
						exit repeat
					end if

					set closedCount to closedCount + 1
					-- Reduced delay to speed up the script
					delay 0.1
				on error errMsg
					-- If an error occurs, return it to Raycast
					return "Error: " & errMsg
				end try
			end repeat

			if closedCount > 0 then
				return "Cleared notifications"
			else
				return "No notifications to clear"
			end if
		end tell
	end tell
end run

EOF

