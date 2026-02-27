-- ==============================================
-- 💬 TAB_DISCORD.LUA - Discord Invite Button (Fixed)
-- ==============================================

local DiscordTab = {}

function DiscordTab.Init(Dependencies)
    local Tab = Dependencies.Tab
    local Shared = Dependencies.Shared
    local Bdev = Dependencies.Bdev
    local GUI = Dependencies.GUI
    
    -- Services
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local HttpService = game:GetService("HttpService")
    
    -- Discord invite link
    local DISCORD_LINK = "https://discord.gg/abcd" -- Ganti dengan link Discord Anda
    local DISCORD_INVITE = "discord.gg/abcd" -- Untuk display
    
    -- ===== DISCORD INVITE BUTTON =====
    
    -- Header
    Tab:CreateLabel({
        Text = "💬 JOIN OUR COMMUNITY",
        Size = 16,
        Color = Color3.fromRGB(255, 40, 40)
    })
    
    -- Discord Logo/Icon
    local discordIcon = Tab:CreateLabel({
        Text = "⚡ DISCORD ⚡",
        Size = 24,
        Color = Color3.fromRGB(255, 255, 255)
    })
    
    -- Info text
    Tab:CreateLabel({
        Text = "Join our Discord server for:",
        Size = 12,
        Color = Color3.fromRGB(200, 200, 200)
    })
    
    -- Benefits list
    Tab:CreateLabel({
        Text = "• Latest updates & announcements",
        Size = 12,
        Color = Color3.fromRGB(150, 150, 150)
    })
    
    Tab:CreateLabel({
        Text = "• Report bugs & suggest features",
        Size = 12,
        Color = Color3.fromRGB(150, 150, 150)
    })
    
    Tab:CreateLabel({
        Text = "• Chat with other users",
        Size = 12,
        Color = Color3.fromRGB(150, 150, 150)
    })
    
    Tab:CreateLabel({
        Text = "• Get support & help",
        Size = 12,
        Color = Color3.fromRGB(150, 150, 150)
    })
    
    -- Separator
    Tab:CreateLabel({
        Text = "───────────",
        Size = 12,
        Color = Color3.fromRGB(100, 100, 100)
    })
    
    -- Discord invite display
    Tab:CreateLabel({
        Text = DISCORD_INVITE,
        Size = 18,
        Color = Color3.fromRGB(0, 255, 255) -- Cyan color like Discord
    })
    
    -- Main Discord Button
    Tab:CreateButton({
        Name = "DiscordJoin",
        Text = "🔷 JOIN DISCORD SERVER 🔷",
        Callback = function()
            -- Show popup/modal confirmation
            local modal = GUI:CreateModal({
                Title = "Join Discord Server?",
                Message = string.format("You will be redirected to:\n%s\n\nOpen in browser?", DISCORD_INVITE),
                ConfirmText = "✅ Yes, Open",
                CancelText = "❌ Cancel",
                Callback = function(confirmed)
                    if confirmed then
                        -- Try to open Discord link - VERSI DIPERBAIKI
                        local success = pcall(function()
                            -- Method 1: Using HttpService (if available)
                            HttpService:RequestAsync({
                                Url = DISCORD_LINK,
                                Method = "GET"
                            })
                            
                            -- Method 2: Open in browser
                            local player = LocalPlayer
                            if player and player.PlayerGui then
                                player:OpenBrowserFrame(DISCORD_LINK)
                            end
                        end)
                        
                        if success then
                            Bdev:Notify({
                                Title = "Discord",
                                Content = "✅ Opening Discord link...",
                                Duration = 3
                            })
                        else
                            -- Fallback: copy to clipboard - DIPISAHKAN DARI PCALL
                            if setclipboard then
                                setclipboard(DISCORD_LINK)
                                Bdev:Notify({
                                    Title = "Discord",
                                    Content = "📋 Link copied to clipboard!",
                                    Duration = 3
                                })
                            else
                                Bdev:Notify({
                                    Title = "Discord",
                                    Content = string.format("📋 Join us at: %s", DISCORD_INVITE),
                                    Duration = 5
                                })
                            end
                        end
                    end
                end
            })
        end
    })
    
    -- Copy Link Button (alternative)
    Tab:CreateButton({
        Name = "CopyDiscordLink",
        Text = "📋 Copy Invite Link",
        Callback = function()
            -- Try to copy to clipboard
            if setclipboard then
                setclipboard(DISCORD_LINK)
                Bdev:Notify({
                    Title = "Copied!",
                    Content = "📋 Discord link copied to clipboard!",
                    Duration = 2
                })
            else
                -- Fallback: show in notification
                Bdev:Notify({
                    Title = "Discord Link",
                    Content = DISCORD_INVITE,
                    Duration = 5
                })
            end
        end
    })
    
    -- Small credit line
    Tab:CreateLabel({
        Text = "───────────",
        Size = 12,
        Color = Color3.fromRGB(100, 100, 100)
    })
    
    Tab:CreateLabel({
        Text = "BeeHub Community",
        Size = 10,
        Color = Color3.fromRGB(150, 150, 150)
    })
    
    print("✅ Discord Button Module Loaded")
end

return DiscordTab